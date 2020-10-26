//
//  ChatHelper.swift
//  SFHealthKitDemoApp
//
//  Created by Yuriy Gavrylenko on 26.10.20.
//  Copyright © 2020 IPFPatientAppOrganizationName. All rights reserved.
//

import Combine

class ChatHelper : ObservableObject {
    var didChange = PassthroughSubject<Void, Never>()
    @Published var realTimeMessages = DataSource.messages
    
    func sendMessage(_ chatMessage: Message) {
        realTimeMessages.append(chatMessage)
        didChange.send(())
    }
}
