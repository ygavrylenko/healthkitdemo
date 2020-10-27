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
    let type: String
    let icon: String
    let unit: String
}

fileprivate enum ATError: Error {
    case notAvailable, missingType
}

class HealthDataModel: ObservableObject {
    let store: HKHealthStore
    var bodyMassData: [HealthKitMeasurement] = []
    var heartRateData: [HealthKitMeasurement] = []
    let formatter = DateFormatter()
   
    
    init(){
        formatter.dateFormat = "HH:mm E, d MMM y"
        store = HKHealthStore()
        self.authorize { (success, error) in
            print("HK Authorization finished - success: \(success); error: \(error)")
            self.fetchBodyMass()
            self.fetchHeartRate()
        }
    }
    
    
    func fetchData(){
        self.bodyMassData = []
        self.heartRateData = []
        self.fetchBodyMass()
        self.fetchHeartRate()
    }
    
    func getBodyMassData() -> [HealthKitMeasurement]{
        return self.bodyMassData
    }
    
    func getHeartRateData() -> [HealthKitMeasurement]{
        return self.heartRateData
    }
 
    
    private func authorize(completion: @escaping (Bool, Error?) -> Void) {
           guard HKHealthStore.isHealthDataAvailable() else {
               completion(false, ATError.notAvailable)
               return
           }
           
           guard
            let bodyMassData = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let heartRateData = HKObjectType.quantityType(forIdentifier: .heartRate) else {
                   completion(false, ATError.missingType)
                   return
           }
           
           let writing: Set<HKSampleType> = [bodyMassData, heartRateData]
           let reading: Set<HKObjectType> = [bodyMassData, heartRateData]
           
           HKHealthStore().requestAuthorization(toShare: writing, read: reading, completion: completion)
       }
    
    private func fetchBodyMass(){
        guard let fvcType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
                    print("Sample type not available")
                    return
            }
        
        let lastWeekPredicate = HKQuery.predicateForSamples(withStart: Date().oneWeekAgo, end: Date(), options: .strictEndDate)
        
        let bodyMassQuery = HKSampleQuery.init(sampleType: fvcType,
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
                                            self.bodyMassData.append(HealthKitMeasurement(id: values.uuid.uuidString,
                                                                                    quantityString: String(format: "%.2f",
                                                                                                           values.quantity.doubleValue(for: HKUnit.pound())),
                                                                                    quantityDouble: values.quantity.doubleValue(for: HKUnit.pound()),
                                                                                    date: values.endDate,
                                                                                    dateString: self.formatter.string(from: values.endDate),
                                                                                    deviceName: values.device?.name,
                                                                                    type: "bodyMass",
                                                                                    icon: "Weight",
                                                                                    unit: "lbs"))
                                        }
        }
        store.execute(bodyMassQuery)
    }
    
    private func fetchHeartRate(){
        guard let fvcType = HKSampleType.quantityType(forIdentifier: .heartRate) else {
                    print("Sample type not available")
                    return
            }
        
        let lastWeekPredicate = HKQuery.predicateForSamples(withStart: Date().oneWeekAgo, end: Date(), options: .strictEndDate)
        let bpmUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
        
        let heartRateQuery = HKSampleQuery.init(sampleType: fvcType,
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
                                            self.heartRateData.append(HealthKitMeasurement(id: values.uuid.uuidString,
                                                                                    quantityString: String(format: "%.2f",
                                                                                                           values.quantity.doubleValue(for: bpmUnit)),
                                                                                    quantityDouble: values.quantity.doubleValue(for: bpmUnit),
                                                                                    date: values.endDate,
                                                                                    dateString: self.formatter.string(from: values.endDate),
                                                                                    deviceName: values.device?.name,
                                                                                    type: "heartRate",
                                                                                    icon: "Heart",
                                                                                    unit: "bpm"))
                                        }
        }
        store.execute(heartRateQuery)
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
