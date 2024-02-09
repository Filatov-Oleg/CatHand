//
//  Task.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 11.01.2024.
//

import Foundation
import SwiftUI

struct TaskPlanner: Identifiable, Equatable {
    var id: UUID = .init()
    var taskTitle: String
    var creationDate: Date = .init()
    var isComleted: Bool = false
    var tint: Color
}

var sampleTask: [TaskPlanner] = [
    .init(taskTitle: "Record Video", creationDate: .updateHour(-5), isComleted: true, tint: .teal),
    .init(taskTitle: "Go for a walk", creationDate: .updateHour(-3), isComleted: false, tint: .teal),
    .init(taskTitle: "Edit video", creationDate: .updateHour(0), isComleted: true, tint: .teal),
    .init(taskTitle: "Published video", creationDate: .updateHour(2), isComleted: false, tint: .teal),
]

extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value , to: .init()) ?? .init()
    }
}
