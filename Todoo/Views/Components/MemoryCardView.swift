//
//  MemoryCardView.swift
//  Todoo
//
//  Created on 2025-12-30.
//

import SwiftUI

enum CardSize {
    case small
    case medium
    case large
}

struct MemoryCardView: View {
    let memory: Memory
    let size: CardSize
    @EnvironmentObject var dataManager: DataManager

    var cardHeight: CGFloat {
        switch size {
        case .small: return 120
        case .medium: return 200
        case .large: return 250
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if memory.isPinned {
                HStack {
                    Spacer()
                    Image(systemName: "bookmark.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
            }

            Spacer()

            VStack(alignment: .leading, spacing: 4) {
                Text(memory.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)

                Text(formatDate(memory.createdAt))
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))

                if !memory.category.isEmpty {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 6, height: 6)
                        Text(memory.category)
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
            }
        }
        .padding()
        .frame(height: cardHeight)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(memory.color.gradient)
        .cornerRadius(20)
        .contextMenu {
            Button(action: { dataManager.togglePin(memory) }) {
                Label(memory.isPinned ? "Unpin" : "Pin", systemImage: memory.isPinned ? "pin.slash" : "pin")
            }

            Button(action: {}) {
                Label("Set as Current Status", systemImage: "play.circle")
            }

            Button(action: {}) {
                Label("Add Reminder", systemImage: "list.bullet")
            }

            Button(action: {}) {
                Label("Add Image", systemImage: "photo")
            }

            Button(action: { dataManager.archiveMemory(memory) }) {
                Label("Archive Memory", systemImage: "archivebox")
            }

            Button(role: .destructive, action: { dataManager.deleteMemory(memory) }) {
                Label("Delete Memory", systemImage: "trash")
            }
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")

        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "'Today' HH:mm"
        } else if Calendar.current.isDateInYesterday(date) {
            formatter.dateFormat = "'Yesterday' HH:mm"
        } else {
            formatter.dateFormat = "MMM d HH:mm"
        }

        return formatter.string(from: date)
    }
}

// MARK: - Upcoming Card View

struct UpcomingCardView: View {
    let memory: Memory
    let reminder: Reminder

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer()
                Image(systemName: "bookmark.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
            }

            Spacer()

            VStack(alignment: .leading, spacing: 6) {
                Text(memory.title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)

                Text(memory.category)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)

                Text(formatReminderTime(reminder.remindTime))
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.9))

                if !memory.category.isEmpty {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 6, height: 6)
                        Text(memory.category)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
        }
        .padding(20)
        .frame(height: 200)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(memory.color.gradient)
        .cornerRadius(20)
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
