//
//  HealthDataCorrelationTypeRow.swift
//  SFHealthKitDemoApp
//
//  Created by Yuriy Gavrylenko on 28.12.20.
//  Copyright © 2020 IPFPatientAppOrganizationName. All rights reserved.
//

import SwiftUI

struct HealthDataCorrelationTypeRow: View {
    var kpiname: String //name of health measurement
    var correlationMeasurement: HealthKitCorrelationMeasurement
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            HStack {
                Image(self.correlationMeasurement.icon)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 25, height: 25)
                Text(self.kpiname)
                    .font(.headline)
                    //.foregroundColor(Color(red: 97 / 255, green: 164 / 255, blue: 103 / 255))
                    .bold()
                Spacer()
                Image(systemName: "arrow.right.circle")
                .foregroundColor(Color(red: 97 / 255, green: 164 / 255, blue: 103 / 255))
            }
            HStack{
                Text(self.correlationMeasurement.measurement1.quantityString + " / " + self.correlationMeasurement.measurement2.quantityString)
                    .font(.title)
                    //.foregroundColor(Color.black)
                Text(self.correlationMeasurement.unit)
                    .foregroundColor(Color.gray)
                    .bold()
                Spacer()
            }
        }
    .padding()
    }
}

struct HealthDataCorrelationTypeRow_Previews: PreviewProvider {
    static var previews: some View {
        HealthDataCorrelationTypeRow(kpiname: "Blood Pressure",
                                     correlationMeasurement: HealthKitCorrelationMeasurement(
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
}
