//
//  Memory.swift
//  Todoo
//
//  Created on 2025-12-30.
//

import Foundation
import SwiftUI

struct Memory: Identifiable, Codable {
    var id: UUID
    var title: String
    var content: String
    var category: String
    var createdAt: Date
    var updatedAt: Date
    var isPinned: Bool
    var isArchived: Bool
    var tags: [String]
    var imageData: Data?
    var reminderIDs: [UUID]
    var color: MemoryColor

    init(
        id: UUID = UUID(),
        title: String,
        content: String,
        category: String = "",
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        isPinned: Bool = false,
        isArchived: Bool = false,
        tags: [String] = [],
        imageData: Data? = nil,
        reminderIDs: [UUID] = [],
        color: MemoryColor = .brown
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.category = category
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isPinned = isPinned
        self.isArchived = isArchived
        self.tags = tags
        self.imageData = imageData
        self.reminderIDs = reminderIDs
        self.color = color
    }
}

enum MemoryColor: String, Codable, CaseIterable {
    case brown = "brown"
    case purple = "purple"
    case green = "green"
    case pink = "pink"
    case blue = "blue"
    case orange = "orange"

    var gradient: LinearGradient {
        switch self {
        case .brown:
            return LinearGradient(colors: [Color(red: 0.55, green: 0.35, blue: 0.25), Color(red: 0.65, green: 0.45, blue: 0.35)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .purple:
            return LinearGradient(colors: [Color(red: 0.35, green: 0.25, blue: 0.50), Color(red: 0.45, green: 0.35, blue: 0.60)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .green:
            return LinearGradient(colors: [Color(red: 0.30, green: 0.50, blue: 0.35), Color(red: 0.40, green: 0.60, blue: 0.45)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .pink:
            return LinearGradient(colors: [Color(red: 0.60, green: 0.30, blue: 0.40), Color(red: 0.70, green: 0.40, blue: 0.50)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .blue:
            return LinearGradient(colors: [Color(red: 0.20, green: 0.35, blue: 0.55), Color(red: 0.30, green: 0.45, blue: 0.65)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .orange:
            return LinearGradient(colors: [Color(red: 0.70, green: 0.45, blue: 0.25), Color(red: 0.80, green: 0.55, blue: 0.35)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}
