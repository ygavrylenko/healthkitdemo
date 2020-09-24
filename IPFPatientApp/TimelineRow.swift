//
//  TimelineRow.swift
//  IPFPatientApp
//
//  Created by Yuriy Gavrylenko on 29.07.20.
//  Copyright © 2020 IPFPatientAppOrganizationName. All rights reserved.
//

import SwiftUI

struct TimelineRow: View {
    var type: String
    var task: Task?
    
    var body: some View {
        HStack{
            Image("task_icon")
                .resizable()
                .frame(width: 25, height: 30)
                .foregroundColor(Color(red: 97 / 255, green: 164 / 255, blue: 103 / 255))
            VStack {
                HStack {
                    Text(self.task!.subject)
                            .font(.headline)
                            .foregroundColor(Color(red: 97 / 255, green: 164 / 255, blue: 103 / 255))
                            .bold()
                        Spacer()
                    }
                    HStack{
                        Text("Due Date: ")
                            .font(.headline)
                            .foregroundColor(Color.gray)
                        Text(self.task!.activityDate)
                            .foregroundColor(Color.black)
                            .bold()
                        Spacer()
                    }
                }
        }
        //.padding()
        .background(Color.white)
    }
}

struct TimelineRow_Previews: PreviewProvider {
    static var previews: some View {
        TimelineRow(type: "task",
        task: Task(id: "1234567890", subject: "Evening Blood Glucose Check", activityDate: "16-07-2020"))
    }
}
