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
        Message(content: "Hi, I really love your templates and I would like to buy the chat template", user: DataSource.firstUser),
        Message(content: "Thanks, nice to hear that, can I have your email please?", user: DataSource.secondUser),
        Message(content: "😇", user: DataSource.firstUser),
        Message(content: "Oh actually, I have just purchased the chat template, so please check your email, you might see my order", user: DataSource.firstUser),
        Message(content: "Great, wait me a sec, let me check", user: DataSource.secondUser),
        Message(content: "Sure", user: DataSource.firstUser)
    ]
}
