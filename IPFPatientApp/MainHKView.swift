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
        
    var body: some View {
        NavigationView {
            VStack{
             
                NavigationLink(destination: HealthMeasurementsList(hkdata: healthDataModel.fevData, dataTypeLabel: "Forced Expiratory Volume, 1 sec")) {
                    HealthDataTypeRow(kpiname: "Forced Expiratory Volume, 1 sec", measurement: healthDataModel.fevData.last)
                        .cornerRadius(20)
                }
                
                NavigationLink(destination: HealthMeasurementsList(hkdata: healthDataModel.fvcData, dataTypeLabel: "Forced Vital Capacity")) {
                    HealthDataTypeRow(kpiname: "Forced Vital Capacity", measurement: healthDataModel.fvcData.last)
                        .cornerRadius(20)
                }                
                Spacer()
            }
            .padding()
            //.padding(.top, 10)
            .background(Color(red: 242 / 255, green: 242 / 255, blue: 247 / 255))
            //.edgesIgnoringSafeArea(.all)
            .navigationBarTitle("Your Respiratory Data", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.showProgress.toggle()
                    self.syncHKDataModel.setMeasurementsFromHK(measurements: self.healthDataModel.getFVCData())
                    print("Submitting")
                    self.uploadComplete = self.syncHKDataModel.syncObservations()
                      .sink { _ in
                        self.mode.wrappedValue.dismiss()
                    }
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
