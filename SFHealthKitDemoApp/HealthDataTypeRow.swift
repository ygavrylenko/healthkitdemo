//
//  HealthDataTypeRow.swift
//  IPFPatientApp
//
//  Created by Yuriy Gavrylenko on 16.07.20.
//  Copyright © 2020 IPFPatientAppOrganizationName. All rights reserved.
//

import SwiftUI

struct HealthDataTypeRow: View {
    var kpiname: String //name of health measurement
    var measurement: HealthKitMeasurement
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            HStack {
                Image(self.measurement.icon)
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
                Text(self.measurement.quantityString)
                    .font(.title)
                    //.foregroundColor(Color.black)
                Text(self.measurement.unit)
                    .foregroundColor(Color.gray)
                    .bold()
                Spacer()
            }
        }
    .padding()
    }
}

struct HealthDataTypeRow_Previews: PreviewProvider {
    static var previews: some View {
        HealthDataTypeRow(kpiname: "Forced Expiratory Volume, 1 sec",
                          measurement: HealthKitMeasurement(id: "1234567890", quantityString: "4.55", quantityDouble: 4.55, date: Date(), dateString: "16-07-2020", deviceName: "NuvoAir", type: "heartRate", icon: "Weight", unit: "bpm"))
    }
}
