//
//  User.swift
//  SFHealthKitDemoApp
//
//  Created by Yuriy Gavrylenko on 26.10.20.
//  Copyright © 2020 IPFPatientAppOrganizationName. All rights reserved.
//

import Foundation

struct User: Hashable {
    var name: String
    var avatar: String
    var isCurrentUser: Bool = false
}
