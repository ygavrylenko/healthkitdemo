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

struct Measurement: Hashable, Identifiable, Decodable {
    let id: String
    let date: Date
    let type: String
    let value: Double
}

class SyncHKDataModel: ObservableObject {
    let newSync = PassthroughSubject<SyncHKDataModel, Never>()
    let completedPublisher = PassthroughSubject<Bool, Never>()
    
    private var compositeRequestBuilder = CompositeRequestBuilder().setAllOrNone(false)
    
    var measurements: [HealthKitMeasurement] = []
    
    @Published var accountId = "" {
      didSet {
        newSync.send(self)
      }
    }
    
    @Published var showActivityIndicator: Bool = false
    
    private var syncTaskCancellable: AnyCancellable?
    private var accountIdCancellable: AnyCancellable?
    private var compositeCancellable: AnyCancellable?
    
    func setMeasurementsFromHK(measurements: [HealthKitMeasurement]){
        self.measurements = measurements
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
    
    func syncObservations() -> Future<Bool, Never>{
        compositeRequestBuilder = CompositeRequestBuilder().setAllOrNone(true)
       
        return Future { promise in
            self.accountIdCancellable = self.fetchAccountId()
                .receive(on: RunLoop.main)
                .map({$0})
                .sink { accountId in
                    print("Uploading to Salesforce: fetched accountId: ", accountId)
                    self.createObservationEventsRequests(accountIdString: accountId)
                    //self.createTestObservationsRequests(accountIdString: accountId)
                    
                    let compositeRequest = self.compositeRequestBuilder.buildCompositeRequest("v49.0")
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
    }
    
    func createObservationEventsRequests(accountIdString : String){
        let customFormatter = DateFormatter()
        customFormatter.locale = Locale(identifier: "en_US_POSIX")
        customFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        customFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        self.measurements.enumerated().forEach { (index, measurement) -> Void in
            var record = RestClient.SalesforceRecord()
            record["ObservationName__c"] = "AppleHK Forced Vital Capacity"
            record["ObservedSubjectId__c"] = accountIdString
            record["ObservationValue__c"] = String(format: "%.2f", measurement.quantityDouble)
            record["ObservationDate__c"] = customFormatter.string(from: measurement.date)

            let observationRequest = RestClient.shared.requestForCreate(withObjectType: "Observation_Event__e", fields: record, apiVersion: "v49.0")
            
            compositeRequestBuilder.add(observationRequest, referenceId: "observationevents\(index)")
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