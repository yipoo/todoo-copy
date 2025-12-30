//
//  MemoryDetailView.swift
//  Todoo
//
//  Created on 2025-12-30.
//

import SwiftUI

struct MemoryDetailView: View {
    let memory: Memory
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @State private var showingShareSheet = false

    var reminders: [Reminder] {
        dataManager.getReminders(for: memory)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle())
                    }

                    Spacer()

                    Text("Memory Details")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)

                    Spacer()

                    HStack(spacing: 12) {
                        Button(action: { showingShareSheet = true }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                        }

                        Button(action: {}) {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.top, 50)

                // Title
                Text(memory.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 10)

                // Category badge
                if !memory.category.isEmpty {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 6, height: 6)
                        Text(memory.category)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                }

                // Timestamp
                Text(formatDate(memory.createdAt))
                    .font(.system(size: 14))
                    .foregroundColor(.gray)

                // Content
                Text(memory.content)
                    .font(.system(size: 17))
                    .foregroundColor(.white)
                    .padding(.top, 10)
                    .lineSpacing(6)

                // Reminders section
                if !reminders.isEmpty {
                    Divider()
                        .background(Color.gray.opacity(0.3))
                        .padding(.vertical, 10)

                    Text("Reminders")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)

                    ForEach(reminders) { reminder in
                        ReminderRowView(reminder: reminder)
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .background(Color.black)
        .navigationBarHidden(true)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMM d, yyyy HH:mm"
        return formatter.string(from: date)
    }
}

struct ReminderRowView: View {
    let reminder: Reminder
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                dataManager.toggleReminderCompletion(reminder)
            }) {
                Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(reminder.isCompleted ? .green : .gray)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(reminder.title)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .strikethrough(reminder.isCompleted)

                Text(formatReminderTime(reminder.remindTime))
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }

            Spacer()

            if !reminder.isCompleted && reminder.remindTime < Date() {
                Text("Overdue")
                    .font(.system(size: 12))
                    .foregroundColor(.red)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }

    private func formatReminderTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")

        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "'Today' HH:mm"
        } else if Calendar.current.isDateInTomorrow(date) {
            formatter.dateFormat = "'Tomorrow' HH:mm"
        } else {
            formatter.dateFormat = "MMM d HH:mm"
        }

        return formatter.string(from: date)
    }
}

#Preview {
    let memory = Memory(
        title: "今天晚上 10 点睡觉",
        content: "今天晚上 10:00 睡觉。",
        category: "睡觉",
        color: .brown
    )
    return MemoryDetailView(memory: memory)
        .environmentObject(DataManager.shared)
}
