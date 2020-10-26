import Foundation
import SalesforceSDKCore
import SwiftUI
import Combine

struct Task: Hashable, Identifiable, Decodable {
    var id: String
    var subject: String
    var activityDate: String
    
    static func generateDemoTasks(numberOfClaims: Int) -> [Task] {
      var demoTasks = [Task]()
      for indexCounter in 1...numberOfClaims {
        demoTasks.append(
          Task(id: "TASK1234\(indexCounter)",
            subject: "Demo Subject - \(indexCounter)",
            activityDate: "16-07-2020")
        )
      }
      return demoTasks
    }

  static func fromJson(record: RestClient.SalesforceRecord) -> Task {
    return .init(
      id: record["Id"] as? String ?? "9999999",
      subject: record["Subject"] as? String ?? "None Listed",
      activityDate: record["ActivityDate"] as? String ?? "0"
    )
  }

}
