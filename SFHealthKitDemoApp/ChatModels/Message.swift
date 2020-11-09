//
//  Message.swift
//  SFHealthKitDemoApp
//
//  Created by Yuriy Gavrylenko on 26.10.20.
//  Copyright © 2020 IPFPatientAppOrganizationName. All rights reserved.
//

import Foundation

struct Message: Hashable {
    var content: String
    var user: User
}

struct DataSource {
    static let firstUser = User(name: "Healthcare Chat", avatar: "Astro_Health")
    static var secondUser = User(name: "Patient", avatar: "Astro_Patient", isCurrentUser: true)
    static let messages = [
        Message(content: "Dear patient, due to the recent measurements you made using HealthKit devices we would like to make new apointment", user: DataSource.firstUser),
        Message(content: "Thanks, could I make an apointment the next Thusday at 10am?", user: DataSource.secondUser),
        Message(content: "Yes, we confirm an apointment on Thusday at 10am.", user: DataSource.firstUser),
        Message(content: "Please also don't eat anything 2 hours before and no alcohol 48 hours before", user: DataSource.firstUser),
        Message(content: "Great, thank you for your efforts!", user: DataSource.secondUser),
        Message(content: "You are welcome!", user: DataSource.firstUser)
    ]
}
