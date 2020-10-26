//
//  HealthDataModel.swift
//  IPFPatientApp
//
//  Created by Yuriy Gavrylenko on 16.07.20.
//  Copyright © 2020 IPFPatientAppOrganizationName. All rights reserved.
//

import SwiftUI
import Combine
import HealthKit


struct HealthKitMeasurement: Hashable, Identifiable, Decodable {
    let id: String
    let quantityString: String
    let quantityDouble: Double
    let date: Date
    let dateString: String
    let deviceName: String?
}

fileprivate enum ATError: Error {
    case notAvailable, missingType
}

class HealthDataModel: ObservableObject {
    let store: HKHealthStore
    var fvcData: [HealthKitMeasurement] = []
    var fevData: [HealthKitMeasurement] = []
    let formatter = DateFormatter()
   
    
    init(){
        formatter.dateFormat = "HH:mm E, d MMM y"
        store = HKHealthStore()
        self.authorize { (success, error) in
            print("HK Authorization finished - success: \(success); error: \(error)")
            self.fetchFVC()
            self.fetchFEV()
        }
    }
    
    
    func fetchData(){
        self.fvcData = []
        self.fevData = []
        self.fetchFVC()
        self.fetchFEV()
    }
    
    func getFVCData() -> [HealthKitMeasurement]{
        return self.fvcData
    }
    
    func getFEVData() -> [HealthKitMeasurement]{
        return self.fevData
    }
 
    
    private func authorize(completion: @escaping (Bool, Error?) -> Void) {
           guard HKHealthStore.isHealthDataAvailable() else {
               completion(false, ATError.notAvailable)
               return
           }
           
           guard
               let fvc = HKObjectType.quantityType(forIdentifier: .forcedVitalCapacity),
               let fev = HKObjectType.quantityType(forIdentifier: .forcedExpiratoryVolume1) else {
                   completion(false, ATError.missingType)
                   return
           }
           
           let writing: Set<HKSampleType> = [fvc, fev]
           let reading: Set<HKObjectType> = [fvc, fev]
           
           HKHealthStore().requestAuthorization(toShare: writing, read: reading, completion: completion)
       }
    
    private func fetchFVC(){
        guard let fvcType = HKSampleType.quantityType(forIdentifier: .forcedVitalCapacity) else {
                    print("Sample type not available")
                    return
            }
        
        let lastWeekPredicate = HKQuery.predicateForSamples(withStart: Date().oneWeekAgo, end: Date(), options: .strictEndDate)
        
        let fvcQuery = HKSampleQuery.init(sampleType: fvcType,
                                       predicate: lastWeekPredicate,
                                       limit: HKObjectQueryNoLimit,
                                       sortDescriptors: nil) { (query, results, error) in
                                        guard
                                            error == nil,
                                            let quantitySamples = results as? [HKQuantitySample] else {
                                                //print("Something went wrong: \(error)")
                                                return
                                        }
                                        
                                        for values in quantitySamples
                                        {
                                            self.fvcData.append(HealthKitMeasurement(id: values.uuid.uuidString,
                                                                                    quantityString: String(format: "%.2f",
                                                                                    values.quantity.doubleValue(for: HKUnit.liter())),
                                                                                    quantityDouble: values.quantity.doubleValue(for: HKUnit.liter()),
                                                                                    date: values.endDate,
                                                                                    dateString: self.formatter.string(from: values.endDate),
                                                                                    deviceName: values.device?.name))
                                        }
        }
        store.execute(fvcQuery)
    }
    
    private func fetchFEV(){
        guard let fvcType = HKSampleType.quantityType(forIdentifier: .forcedExpiratoryVolume1) else {
                    print("Sample type not available")
                    return
            }
        
        let lastWeekPredicate = HKQuery.predicateForSamples(withStart: Date().oneWeekAgo, end: Date(), options: .strictEndDate)
        
        let fevQuery = HKSampleQuery.init(sampleType: fvcType,
                                       predicate: lastWeekPredicate,
                                       limit: HKObjectQueryNoLimit,
                                       sortDescriptors: nil) { (query, results, error) in
                                        guard
                                            error == nil,
                                            let quantitySamples = results as? [HKQuantitySample] else {
                                                //print("Something went wrong: \(error)")
                                                return
                                        }
                                        
                                        for values in quantitySamples
                                        {
                                            self.fevData.append(HealthKitMeasurement(id: values.uuid.uuidString,
                                                                                    quantityString: String(format: "%.2f",
                                                                                    values.quantity.doubleValue(for: HKUnit.liter())),
                                                                                    quantityDouble: values.quantity.doubleValue(for: HKUnit.liter()),
                                                                                    date: values.endDate,
                                                                                    dateString: self.formatter.string(from: values.endDate),
                                                                                    deviceName: values.device?.name))
                                        }
        }
        store.execute(fevQuery)
    }
}

extension Date {
    var oneDayAgo: Date {
        return self.addingTimeInterval(-86400)
    }
    
    var oneWeekAgo: Date {
        return self.addingTimeInterval(-86400*7)
    }
}
