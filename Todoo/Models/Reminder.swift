//
//  Reminder.swift
//  Todoo
//
//  Created on 2025-12-30.
//

import Foundation

struct Reminder: Identifiable, Codable {
    var id: UUID
    var memoryID: UUID
    var title: String
    var remindTime: Date
    var isCompleted: Bool
    var createdAt: Date

    init(
        id: UUID = UUID(),
        memoryID: UUID,
        title: String,
        remindTime: Date,
        isCompleted: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.memoryID = memoryID
        self.title = title
        self.remindTime = remindTime
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}
