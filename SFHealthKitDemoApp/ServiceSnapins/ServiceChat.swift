//
//  ServiceChat.swift
//  SFHealthKitDemoApp
//
//  Created by Yuriy Gavrylenko on 22.12.20.
//  Copyright © 2020 IPFPatientAppOrganizationName. All rights reserved.
//

import SwiftUI
import ServiceChat

struct ServiceChat: View {
    var chatConfig = SCSChatConfiguration(liveAgentPod: "d.la3-c2-fra.salesforceliveagent.com",
                                      orgId: "00D09000002YUJE",
                                      deploymentId: "572090000000GbK",
                                      buttonId: "573090000000Gkn")
    
    var body: some View {
        Button(action: {
            ServiceCloud.shared().chatUI.showChat(with: chatConfig!)
        }) {
            Text("Chat with doctor")
        }
    }
}

struct ServiceChat_Previews: PreviewProvider {
    static var previews: some View {
        ServiceChat()
    }
}
