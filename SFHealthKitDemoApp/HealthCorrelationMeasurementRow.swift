//
//  HealthCorrelationMeasurementRow.swift
//  SFHealthKitDemoApp
//
//  Created by Yuriy Gavrylenko on 28.12.20.
//  Copyright © 2020 IPFPatientAppOrganizationName. All rights reserved.
//

import SwiftUI

struct HealthCorrelationMeasurementRow: View {
    var correlationMeasurement: HealthKitCorrelationMeasurement
    @Environment(\.colorScheme) var colorScheme
        
    var body: some View {
        VStack {
                HStack {
                    Image(correlationMeasurement.icon)
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text(correlationMeasurement.measurement1.quantityString + " / " +     correlationMeasurement.measurement2.quantityString)
                        .font(.headline)
                        .bold()
                    Text(correlationMeasurement.unit)
                        .font(.headline)
                        .foregroundColor(Color.gray)
                        .bold()
                    Spacer()
                    Text(correlationMeasurement.dateString)
                        .foregroundColor(Color.gray)
                }
            }
        .padding()
    }
}

struct HealthCorrelationMeasurementRow_Previews: PreviewProvider {
    static var previews: some View {
        HealthCorrelationMeasurementRow(correlationMeasurement: HealthKitCorrelationMeasurement(
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





