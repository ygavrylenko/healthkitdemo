//
//  MainHKView.swift
//  IPFPatientApp
//
//  Created by Yuriy Gavrylenko on 16.07.20.
//  Copyright © 2020 IPFPatientAppOrganizationName. All rights reserved.
//

import SwiftUI
import HealthKit
import Combine
import SalesforceSDKCore

struct MainHKView: View {
    @State private var isAnimating = false
    @State private var showProgress = false
    @State var uploadComplete: AnyCancellable?
    
    var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
    
    @ObservedObject var healthDataModel = HealthDataModel()
    @EnvironmentObject var syncHKDataModel : SyncHKDataModel
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
        
    var body: some View {
        
        NavigationView {
            List{
                Section {
                    NavigationLink(destination: HealthCorrelationMeasurementList(hkdata: healthDataModel.bloodPressureData, dataTypeLabel: "Blood Pressure")) {
                        HealthDataCorrelationTypeRow(kpiname: "Blood Pressure",
                                                     correlationMeasurement: healthDataModel.bloodPressureData.last ?? HealthKitCorrelationMeasurement(
                                                        id: "1234567890",
                                                        type: "bloodPressure",
                                                        icon: "BloodPressure",
                                                        unit: "mmHg",
                                                        date: Date(),
                                                        dateString: "28-12-2020",
                                                        measurement1: HealthKitMeasurement(id: "1234567890", quantityString: "120", quantityDouble: 120.0, date: Date(), dateString: "28-12-2020", deviceName: "BloodPressureDevice", type: "systolicBloodPressure", icon: "Heart", unit: "mmHg"),
                                                        measurement2: HealthKitMeasurement(id: "1234567890", quantityString: "80", quantityDouble: 80.0, date: Date(), dateString: "28-12-2020", deviceName: "BloodPressureDevice", type: "diastolicBloodPressure", icon: "Heart", unit: "mmHg")
                                                    ))
                    }
                    
                    NavigationLink(destination: HealthMeasurementsList(hkdata: healthDataModel.bodyMassData, dataTypeLabel: "Body Mass")) {
                        HealthDataTypeRow(kpiname: "Body Mass", measurement: healthDataModel.bodyMassData.last ?? HealthKitMeasurement(id: "1234567890", quantityString: "0.00", quantityDouble: 0.00, date: Date(), dateString: "16-07-2020", deviceName: "Unknown Device", type: "heabodyMass", icon: "Weight", unit: "lbs"))
                    }
                    
                    NavigationLink(destination: HealthMeasurementsList(hkdata: healthDataModel.heartRateData, dataTypeLabel: "Heart Rate")) {
                        HealthDataTypeRow(kpiname: "Heart Rate", measurement: healthDataModel.heartRateData.last ?? HealthKitMeasurement(id: "1234567890", quantityString: "0.00", quantityDouble: 0.00, date: Date(), dateString: "16-07-2020", deviceName: "Unknown Device", type: "heartRate", icon: "Heart", unit: "bpm"))
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .padding(.top, 0)
            .navigationBarTitle("Your Health Data", displayMode: .inline)
            .navigationBarItems(
                trailing:
                Button(action: {
                    self.showProgress.toggle()
                    self.syncHKDataModel.setWeightMeasurementsFromHK(measurements: self.healthDataModel.getBodyMassData())
                    self.syncHKDataModel.setHeartRateMeasurementsFromHK(measurements: self.healthDataModel.getHeartRateData())
                    self.syncHKDataModel.setSystolicBloodPressureFromHK(measurements: self.healthDataModel.getSystolicBloodPressureData())
                    self.syncHKDataModel.setDiastolicBloodPressureFromHK(measurements: self.healthDataModel.getDiastolicBloodPressureData())
                    print("Submitting")
                    self.syncHKDataModel.syncObservations()
                    let seconds = 3.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                        self.showProgress.toggle()
                    }
                }, label: {
                      if showProgress {
                          Image(systemName: "arrow.2.circlepath.circle.fill")
                              .resizable()
                              .foregroundColor(Color(red: 97 / 255, green: 164 / 255, blue: 103 / 255))
                              .frame(width: 30, height: 30)
                              .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
                              .animation(self.isAnimating ? foreverAnimation : .default)
                              .onAppear { self.isAnimating = true }
                              .onDisappear { self.isAnimating = false }
                      } else {
                          Image(systemName: "arrow.2.circlepath.circle.fill")
                            .resizable()
                            .foregroundColor(Color(red: 97 / 255, green: 164 / 255, blue: 103 / 255))
                            .frame(width: 30, height: 30)
                      }
                  })
                  .onAppear { self.showProgress = false }
            )
        }
        .edgesIgnoringSafeArea(.leading)
        .onAppear{
            self.healthDataModel.fetchData()
        }
    }
}

struct MainHKView_Previews: PreviewProvider {
    static let env = SyncHKDataModel()
    static var previews: some View {
        MainHKView().environmentObject(env)
    }
}
