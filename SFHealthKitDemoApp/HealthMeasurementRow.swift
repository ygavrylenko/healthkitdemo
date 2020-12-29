//
//  HealthMeasurementRow.swift
//  IPFPatientApp
//
//  Created by Yuriy Gavrylenko on 16.07.20.
//  Copyright © 2020 IPFPatientAppOrganizationName. All rights reserved.
//

import SwiftUI

struct HealthMeasurementRow: View {
    var measurement: HealthKitMeasurement
    @Environment(\.colorScheme) var colorScheme
        
    var body: some View {
        VStack {
                HStack {
                    Image(measurement.icon)
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text(measurement.quantityString)
                        .font(.headline)
                        .bold()
                    Text(measurement.unit)
                        .font(.headline)
                        .foregroundColor(Color.gray)
                        .bold()
                    Spacer()
                    Text(measurement.dateString)                        
                        .foregroundColor(Color.gray)
                }
            }
        .padding()
    }
}

struct HealthMeasurementRow_Previews: PreviewProvider {
    static var previews: some View {
        HealthMeasurementRow(measurement: HealthKitMeasurement(id: "1234567890", quantityString: "4.55", quantityDouble: 4.55, date: Date(), dateString: "16-07-2020", deviceName: "NuvoAir", type: "bodyMass", icon: "Heart", unit: "lbs"))
    }
}
