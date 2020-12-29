//
//  SyncHKDataModel.swift
//  IPFPatientApp
//
//  Created by Yuriy Gavrylenko on 17.07.20.
//  Copyright © 2020 IPFPatientAppOrganizationName. All rights reserved.
//
import Foundation
import SalesforceSDKCore
import Combine

class SyncHKDataModel: ObservableObject {
    let newSync = PassthroughSubject<SyncHKDataModel, Never>()
    let completedPublisher = PassthroughSubject<Bool, Never>()
    
    //private var compositeRequestBuilder = CompositeRequestBuilder().setAllOrNone(false)
    
    var requests: [RestRequest] = []
    var weightMeasurements: [HealthKitMeasurement] = []
    var heartMeasurements: [HealthKitMeasurement] = []
    var systolicBloodPressure: [HealthKitMeasurement] = []
    var diastolicBloodPressure: [HealthKitMeasurement] = []
    
    @Published var accountId = "" {
      didSet {
        newSync.send(self)
      }
    }
    
    @Published var showActivityIndicator: Bool = false
    
    private var syncTaskCancellable: AnyCancellable?
    private var accountIdCancellable: AnyCancellable?
    private var compositeCancellable: AnyCancellable?
    
    func setWeightMeasurementsFromHK(measurements: [HealthKitMeasurement]){
        self.weightMeasurements = measurements
    }
    
    func setHeartRateMeasurementsFromHK(measurements: [HealthKitMeasurement]){
        self.heartMeasurements = measurements
    }
    
    func setSystolicBloodPressureFromHK(measurements: [HealthKitMeasurement]){
        self.systolicBloodPressure = measurements
    }
    
    func setDiastolicBloodPressureFromHK(measurements: [HealthKitMeasurement]){
        self.diastolicBloodPressure = measurements
    }
    
    func fetchAccountId() -> AnyPublisher<String, Never> {
      let userId = UserAccountManager.shared.currentUserAccount!.accountIdentity.userId
      let accountIdQuery = RestClient.shared.request(forQuery: "SELECT contact.accountId FROM User WHERE ID = '\(userId)' LIMIT 1",
        apiVersion: "v49.0")
      return RestClient.shared.publisher(for: accountIdQuery)
        .tryMap { try $0.asJson() as? RestClient.JSONKeyValuePairs ?? [:] }
        .map { $0["records"] as? RestClient.SalesforceRecords ?? [] }
        .mapError { dump($0) }
        .replaceError(with: [])
        .receive(on: RunLoop.main)
        .map {records in
          let accountRecord = records.first!
          let contact = accountRecord["Contact"] as! RestClient.SalesforceRecord // swiftlint:disable:this force_cast
          let accountId = contact["AccountId"] as! String // swiftlint:disable:this force_cast
          return accountId
      }.eraseToAnyPublisher()
    }
    
    func syncObservations(){
        self.requests = []
        
        self.accountIdCancellable = self.fetchAccountId()
            .receive(on: RunLoop.main)
            .map({$0})
            .sink {accountId in
                print("Uploading to Salesforce: fetched accountId: ", accountId)
                
                self.createObservationEventsRequests(accountIdString: accountId)
                
                let maxNumberOfSubrequests = 25 //see specification of Composite API (maybe there is a more elegant way the fetch this information?)
                
                //now we separate all requests in chunks of 25 subrequests needed to build composite request
                let chunks = stride(from: 0, to: self.requests.count, by: maxNumberOfSubrequests).map {
                    Array(self.requests[$0..<min($0 + maxNumberOfSubrequests, self.requests.count)])
                }
                
                for index in 0...Int(chunks.count - 1){
                    let compositeRequestBuilder = CompositeRequestBuilder().setAllOrNone(true)
                    
                    let tempRequests: [RestRequest] = chunks[index]
                    tempRequests.enumerated().forEach { (index, measurement) -> Void in
                        compositeRequestBuilder.add(measurement, referenceId: "hkevents\(index)")
                      }
                    self.createCompositeRequestPromise(compositeRequest: compositeRequestBuilder.buildCompositeRequest("v49.0"))
                }
            }
        
    }
    
    func createCompositeRequestPromise(compositeRequest: CompositeRequest) -> Future<Bool, Never>{
        return Future { promise in
                    self.syncTaskCancellable = RestClient.shared.publisher(for: compositeRequest)
                        .receive(on: RunLoop.main)
                        .mapError { dump($0) }
                        .replaceError(with: CompositeResponse())
                        .sink { value in
                            print(value)
                            //self.showActivityIndicator = false
                            self.completedPublisher.send(true)
                            promise(.success(true))
                            self.showActivityIndicator = false;
                        }
        }
    }
    
    func createObservationEventsRequests(accountIdString : String){
        let customFormatter = DateFormatter()
        customFormatter.locale = Locale(identifier: "en_US_POSIX")
        customFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        customFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        
        self.weightMeasurements.enumerated().forEach { (index, measurement) -> Void in
            var record = RestClient.SalesforceRecord()
            record["CodeSet_Id__c"] = "healthkit-weight"
            record["Id__c"] = measurement.id
            record["ObservationName__c"] = "AppleHK Weight Measurement"
            record["ObservedSubjectId__c"] = accountIdString
            record["ObservationValue__c"] = String(format: "%.2f", measurement.quantityDouble)
            record["ObservationDate__c"] = customFormatter.string(from: measurement.date)
            record["UOM__c"] = "lbs"

            let observationRequest = RestClient.shared.requestForCreate(withObjectType: "Observation_Event__e", fields: record, apiVersion: "v49.0")
            requests.append(observationRequest)
          }
        
        self.heartMeasurements.enumerated().forEach { (index, measurement) -> Void in
            var record = RestClient.SalesforceRecord()
            record["Id__c"] = measurement.id
            record["ObservationName__c"] = "AppleHK Heart Rate Measurement"
            record["ObservedSubjectId__c"] = accountIdString
            record["ObservationValue__c"] = String(format: "%.2f", measurement.quantityDouble)
            record["ObservationDate__c"] = customFormatter.string(from: measurement.date)
            record["CodeSet_Id__c"] = "healthkit-heartrate"
            record["UOM__c"] = "bpm"

            let observationRequest = RestClient.shared.requestForCreate(withObjectType: "Observation_Event__e", fields: record, apiVersion: "v49.0")
            requests.append(observationRequest)
          }
        
        
        self.systolicBloodPressure.enumerated().forEach { (index, measurement) -> Void in
            var record = RestClient.SalesforceRecord()
            record["Id__c"] = measurement.id
            record["ObservationName__c"] = "AppleHK Systolic Blood Pressure Measurement"
            record["ObservedSubjectId__c"] = accountIdString
            record["ObservationValue__c"] = String(format: "%.2f", measurement.quantityDouble)
            record["ObservationDate__c"] = customFormatter.string(from: measurement.date)
            record["CodeSet_Id__c"] = "healthkit-systolic"
            record["UOM__c"] = "mmHg"

            let observationRequest = RestClient.shared.requestForCreate(withObjectType: "Observation_Event__e", fields: record, apiVersion: "v49.0")
            requests.append(observationRequest)
          }
        
        
        self.diastolicBloodPressure.enumerated().forEach { (index, measurement) -> Void in
            var record = RestClient.SalesforceRecord()
            record["Id__c"] = measurement.id
            record["ObservationName__c"] = "AppleHK Diastolic Blood Pressure Measurement"
            record["ObservedSubjectId__c"] = accountIdString
            record["ObservationValue__c"] = String(format: "%.2f", measurement.quantityDouble)
            record["ObservationDate__c"] = customFormatter.string(from: measurement.date)
            record["CodeSet_Id__c"] = "healthkit-systolic"
            record["UOM__c"] = "mmHg"

            let observationRequest = RestClient.shared.requestForCreate(withObjectType: "Observation_Event__e", fields: record, apiVersion: "v49.0")
            requests.append(observationRequest)
          }
    }
    
    
    private func handleError(_ error: Error?, urlResponse: URLResponse? = nil) {
      let errorDescription: String
      if let error = error {
        errorDescription = "\(error)"
      } else {
        errorDescription = "An unknown error occurred."
      }
      
      print(errorDescription)
    }
}
