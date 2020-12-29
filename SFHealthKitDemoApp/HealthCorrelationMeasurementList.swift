//
//  HealthCorrelationMeasurementList.swift
//  SFHealthKitDemoApp
//
//  Created by Yuriy Gavrylenko on 28.12.20.
//  Copyright © 2020 IPFPatientAppOrganizationName. All rights reserved.
//

import SwiftUI

struct HealthCorrelationMeasurementList: View {
    var hkdata: [HealthKitCorrelationMeasurement] = []
    var dataTypeLabel: String
    
    var body: some View {
        List(hkdata, id: \.id) { correlationMeasurement in
                HealthCorrelationMeasurementRow(correlationMeasurement: correlationMeasurement)
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(Text(self.dataTypeLabel).font(.title))
    }
}

struct HealthCorrelationMeasurementList_Previews: PreviewProvider {
    static var previews: some View {
        HealthCorrelationMeasurementList(hkdata:
            [
                HealthKitCorrelationMeasurement(
                    id: "1234567890",
                    type: "bloodPressure",
                    icon: "BloodPressure",
                    unit: "mmHg",
                    date: Date(),
                    dateString: "28-12-2020",
                    measurement1: HealthKitMeasurement(id: "1234567890", quantityString: "120", quantityDouble: 120.0, date: Date(), dateString: "28-12-2020", deviceName: "BloodPressureDevice", type: "systolicBloodPressure", icon: "Heart", unit: "mmHg"),
                    measurement2: HealthKitMeasurement(id: "1234567890", quantityString: "80", quantityDouble: 80.0, date: Date(), dateString: "28-12-2020", deviceName: "BloodPressureDevice", type: "diastolicBloodPressure", icon: "Heart", unit: "mmHg")
                ),
                HealthKitCorrelationMeasurement(
                    id: "1234567890",
                    type: "bloodPressure",
                    icon: "BloodPressure",
                    unit: "mmHg",
                    date: Date(),
                    dateString: "28-12-2020",
                    measurement1: HealthKitMeasurement(id: "1234567890", quantityString: "136", quantityDouble: 136.0, date: Date(), dateString: "28-12-2020", deviceName: "BloodPressureDevice", type: "systolicBloodPressure", icon: "Heart", unit: "mmHg"),
                    measurement2: HealthKitMeasurement(id: "1234567890", quantityString: "87", quantityDouble: 87.0, date: Date(), dateString: "28-12-2020", deviceName: "BloodPressureDevice", type: "diastolicBloodPressure", icon: "Heart", unit: "mmHg")
                )
            ],
            dataTypeLabel: "Blood Pressure")
    }
}
