//
//  ExistingClaimsListModel.swift
//  RedwoodsInsurance
//
//  Created by Kevin Poorman on 1/9/20.
//  Copyright © 2020 RedwoodsInsuranceOrganizationName. All rights reserved.
//

import Foundation
import SalesforceSDKCore
import SwiftUI
import Combine

class TimelineModel: ObservableObject {

  @Published var tasks: [Task] = []
  private var taskCancellable: AnyCancellable?



  func fetchDataFromSalesforce() {
    let userId = UserAccountManager.shared.currentUserAccount!.accountIdentity.userId
    let tasksQuery = "SELECT Id, Subject, ActivityDate FROM Task WHERE OwnerId = '\(userId)'"
    
    taskCancellable = RestClient.shared.records(fromQuery: tasksQuery, returningModel: Task.fromJson(record:))
      .receive(on: RunLoop.main)
      .map {$0}
      .assign(to: \.tasks, on: self)
  }
}
