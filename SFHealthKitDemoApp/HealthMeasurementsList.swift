//
//  HealthMeasurementsList.swift
//  IPFPatientApp
//
//  Created by Yuriy Gavrylenko on 17.07.20.
//  Copyright © 2020 IPFPatientAppOrganizationName. All rights reserved.
//

import SwiftUI

struct HealthMeasurementsList: View {
    var hkdata: [HealthKitMeasurement] = []
    var dataTypeLabel: String
    
    var body: some View {
        List(hkdata, id: \.id) { measurement in
                HealthMeasurementRow(measurement: measurement)
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(Text(self.dataTypeLabel).font(.title))
    }
}

struct HealthMeasurementsList_Previews: PreviewProvider {
    static var previews: some View {
        HealthMeasurementsList(hkdata:
            [HealthKitMeasurement(id: "1234567890", quantityString: "4.55", quantityDouble: 4.55, date: Date(), dateString: "17-07-2020", deviceName: "NuvoAir"),
            HealthKitMeasurement(id: "2345678901", quantityString: "3.99", quantityDouble: 3.99, date: Date(), dateString: "17-07-2020", deviceName: "NuvoAir")],
                               dataTypeLabel: "Forced Vital Capacity"
        )
    }
}
