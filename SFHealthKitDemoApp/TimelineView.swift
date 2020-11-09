//
//  TimelineView.swift
//  IPFPatientApp
//
//  Created by Yuriy Gavrylenko on 27.08.20.
//  Copyright © 2020 IPFPatientAppOrganizationName. All rights reserved.
//

import SwiftUI

struct TimelineView: View {
@ObservedObject var timelineModel = TimelineModel()
    
    var body: some View {
        NavigationView {
            ZStack{
                List(self.timelineModel.tasks, id: \.id) { task in
                        TimelineRow(type: "task", task: task)
                        }
                        //.listStyle(GroupedListStyle())
                    .environment(\.horizontalSizeClass, .regular)
                
                    .navigationBarTitle(Text("Your next tasks").font(.title))
                    
                    .onAppear {
                            print("On Appear firing for ExistingClaims()")
                        self.timelineModel.fetchDataFromSalesforce()
                        }
                
                }
            }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        let preview = TimelineView()
        preview.timelineModel.tasks = Task.generateDemoTasks(numberOfClaims: 5)
        return preview
    }
}
