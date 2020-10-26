//
//  MainProfileView.swift
//  IPFPatientApp
//
//  Created by Yuriy Gavrylenko on 28.07.20.
//  Copyright © 2020 IPFPatientAppOrganizationName. All rights reserved.
//

import SwiftUI

struct MainProfileView: View {
    var body: some View {
        NavigationView {
            VStack{
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
            .padding()
            //.padding(.top, 10)
            .background(Color(red: 242 / 255, green: 242 / 255, blue: 247 / 255))
            //.edgesIgnoringSafeArea(.all)
            .navigationBarTitle("Your Profile Data", displayMode: .inline)
        }
        

    }
}

struct MainProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MainProfileView()
    }
}
