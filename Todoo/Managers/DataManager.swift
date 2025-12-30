//
//  DataManager.swift
//  Todoo
//
//  Created on 2025-12-30.
//

import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()

    @Published var memories: [Memory] = []
    @Published var reminders: [Reminder] = []

    private let memoriesKey = "memories"
    private let remindersKey = "reminders"

    private init() {
        loadData()
    }

    // MARK: - Memory Operations

    func addMemory(_ memory: Memory) {
        memories.append(memory)
        saveMemories()
    }

    func updateMemory(_ memory: Memory) {
        if let index = memories.firstIndex(where: { $0.id == memory.id }) {
            memories[index] = memory
            saveMemories()
        }
    }

    func deleteMemory(_ memory: Memory) {
        memories.removeAll { $0.id == memory.id }
        // Also delete associated reminders
        reminders.removeAll { $0.memoryID == memory.id }
        saveMemories()
        saveReminders()
    }

    func togglePin(_ memory: Memory) {
        if let index = memories.firstIndex(where: { $0.id == memory.id }) {
            memories[index].isPinned.toggle()
            saveMemories()
        }
    }

    func archiveMemory(_ memory: Memory) {
        if let index = memories.firstIndex(where: { $0.id == memory.id }) {
            memories[index].isArchived = true
            saveMemories()
        }
    }

    // MARK: - Reminder Operations

    func addReminder(_ reminder: Reminder) {
        reminders.append(reminder)
        saveReminders()
        scheduleNotification(for: reminder)
    }

    func updateReminder(_ reminder: Reminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index] = reminder
            saveReminders()
            scheduleNotification(for: reminder)
        }
    }

    func deleteReminder(_ reminder: Reminder) {
        reminders.removeAll { $0.id == reminder.id }
        saveReminders()
        cancelNotification(for: reminder)
    }

    func toggleReminderCompletion(_ reminder: Reminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index].isCompleted.toggle()
            saveReminders()
        }
    }

    func getReminders(for memory: Memory) -> [Reminder] {
        return reminders.filter { $0.memoryID == memory.id }
    }

    func getMemory(for reminder: Reminder) -> Memory? {
        return memories.first { $0.id == reminder.memoryID }
    }

    // MARK: - Filtered Data

    var pinnedMemories: [Memory] {
        memories.filter { $0.isPinned && !$0.isArchived }
    }

    var activeMemories: [Memory] {
        memories.filter { !$0.isArchived }
    }

    var upcomingReminders: [Reminder] {
        reminders
            .filter { !$0.isCompleted && $0.remindTime > Date() }
            .sorted { $0.remindTime < $1.remindTime }
    }

    // MARK: - Persistence

    private func saveMemories() {
        if let encoded = try? JSONEncoder().encode(memories) {
            UserDefaults.standard.set(encoded, forKey: memoriesKey)
        }
    }

    private func saveReminders() {
        if let encoded = try? JSONEncoder().encode(reminders) {
            UserDefaults.standard.set(encoded, forKey: remindersKey)
        }
    }

    private func loadData() {
        if let memoriesData = UserDefaults.standard.data(forKey: memoriesKey),
           let decodedMemories = try? JSONDecoder().decode([Memory].self, from: memoriesData) {
            memories = decodedMemories
        }

        if let remindersData = UserDefaults.standard.data(forKey: remindersKey),
           let decodedReminders = try? JSONDecoder().decode([Reminder].self, from: remindersData) {
            reminders = decodedReminders
        }
    }

    // MARK: - Notifications

    private func scheduleNotification(for reminder: Reminder) {
        guard let memory = getMemory(for: reminder) else { return }
        NotificationManager.shared.scheduleNotification(
            for: reminder,
            with: memory.title,
            body: memory.category.isEmpty ? "Time for your task" : memory.category
        )
    }

    private func cancelNotification(for reminder: Reminder) {
        NotificationManager.shared.cancelNotification(for: reminder)
    }
}
