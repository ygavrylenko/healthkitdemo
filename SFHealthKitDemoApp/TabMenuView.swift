//
//  HealthDataOverview.swift
//  IPFPatientApp
//
//  Created by Yuriy Gavrylenko on 07.07.20.
//  Copyright © 2020 IPFPatientAppOrganizationName. All rights reserved.
//

import SwiftUI
import ServiceChat

struct TabMenuView: View {
    @ObservedObject var viewRouter = ViewRouter()
    @State var showPopUp = false
    //@State var accountListView: AccountsListView = AccountsListView()
    //@State var healthData: HealthDataView = HealthDataView()
    @State var healthData: MainHKView = MainHKView()
    @State var timelineView: TimelineView = TimelineView()
    //@State var chatView: ChatView = ChatView()
    @State var serviceChat: ServiceChat = ServiceChat()
    @EnvironmentObject var syncHKDataModel: SyncHKDataModel
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                if self.viewRouter.currentView == "home" {
                    self.timelineView
                } else if self.viewRouter.currentView == "settings" {
                    self.healthData
                } else if self.viewRouter.currentView == "chat" {
                    self.serviceChat
                }
                Spacer()
                ZStack {
                    
                    if self.showPopUp {
                       PlusMenu()
                        .offset(y: -geometry.size.height/6)
                    }
                    HStack {
                        Image(systemName: "calendar.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(15)
                            .frame(width: geometry.size.width/6, height: 70)
                            .foregroundColor(self.viewRouter.currentView == "home" ? Color(red: 97 / 255, green: 164 / 255, blue: 103 / 255) : .gray)
                            .onTapGesture {
                                self.viewRouter.currentView = "home"
                            }
                        Image(systemName: "heart.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(15)
                            .frame(width: geometry.size.width/6, height: 70)
                            .foregroundColor(self.viewRouter.currentView == "settings" ? Color(red: 97 / 255, green: 164 / 255, blue: 103 / 255) : .gray)
                            .onTapGesture {
                                self.viewRouter.currentView = "settings"
                            }
                        ZStack {
                            Circle()
                                .foregroundColor(Color.white)
                                .frame(width: 75, height: 75)
                            Image(systemName: "cross.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75, height: 75)
                                .foregroundColor(Color(red: 97 / 255, green: 164 / 255, blue: 103 / 255))
                                .rotationEffect(Angle(degrees: self.showPopUp ? 90 : 0))
                        }
                            .offset(y: -geometry.size.height/10/2)
                            .onTapGesture {
                                withAnimation {
                                   self.showPopUp.toggle()
                                }
                            }
                        
                        Image(systemName: "bag.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(15)
                            .frame(width: geometry.size.width/6, height: 70)
                            .foregroundColor(self.viewRouter.currentView == "contact" ? Color(red: 97 / 255, green: 164 / 255, blue: 103 / 255) : .gray)
                            .onTapGesture {
                                self.viewRouter.currentView = "chat"
                            }
                        Image(systemName: "questionmark.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(15)
                            .frame(width: geometry.size.width/6, height: 70)
                            .foregroundColor(self.viewRouter.currentView == "contact" ? Color(red: 97 / 255, green: 164 / 255, blue: 103 / 255) : .gray)
                            .onTapGesture {
                                self.viewRouter.currentView = "chat"
                            }
                    }
                        .frame(width: geometry.size.width, height: geometry.size.height/10)
                    .background(Color(UIColor.systemBackground).shadow(radius: 2))
                }
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct TabMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TabMenuView()
    }
}

struct PlusMenu: View {
    var body: some View {
        HStack(spacing: 50) {
            ZStack {
                Circle()
                    .foregroundColor(Color(red: 97 / 255, green: 164 / 255, blue: 103 / 255))
                    .frame(width: 70, height: 70)
                    .onTapGesture {
                        ServiceCloud.shared().chatUI.showChat(with: SnapinsConfig.instance.chatConfig!,
                                                              showPrechat: SnapinsConstants.ENABLE_PRECHAT_FIELDS)
                    }
                Image(systemName: "message")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(20)
                    .frame(width: 70, height: 70)
                    .foregroundColor(.white)
            }
            ZStack {
                Circle()
                    .foregroundColor(Color(red: 97 / 255, green: 164 / 255, blue: 103 / 255))
                    .frame(width: 70, height: 70)
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(20)
                    .frame(width: 70, height: 70)
                    .foregroundColor(.white)
            }
        }
            .transition(.scale)
    }
}
