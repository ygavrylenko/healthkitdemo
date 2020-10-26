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
        
    var body: some View {
        VStack {
                HStack {
                    Image("lung_icon")
                        .resizable()
                        .frame(width: 25, height: 20)
                    Text(measurement.quantityString)
                        .font(.headline)
                        .bold()
                    Text("L")
                        .font(.headline)
                        .foregroundColor(Color.gray)
                        .bold()
                    Spacer()
                    Text(measurement.dateString)
                        .foregroundColor(Color.gray)
                }
            }
        .padding()
        .background(Color.white)
    }
}

struct HealthMeasurementRow_Previews: PreviewProvider {
    static var previews: some View {
        HealthMeasurementRow(measurement: HealthKitMeasurement(id: "1234567890", quantityString: "4.55", quantityDouble: 4.55, date: Date(), dateString: "16-07-2020", deviceName: "NuvoAir"))
    }
}
