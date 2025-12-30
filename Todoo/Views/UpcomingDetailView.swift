//
//  UpcomingDetailView.swift
//  Todoo
//
//  Created on 2025-12-30.
//

import SwiftUI

struct UpcomingDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager

    var upcomingReminders: [Reminder] {
        dataManager.upcomingReminders
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

                    Text("Upcoming")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()

                    // Placeholder for symmetry
                    Color.clear
                        .frame(width: 44, height: 44)
                }
                .padding(.top, 50)

                // Upcoming reminders list
                if upcomingReminders.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)

                        Text("No upcoming reminders")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 100)
                } else {
                    ForEach(upcomingReminders) { reminder in
                        if let memory = dataManager.getMemory(for: reminder) {
                            NavigationLink(destination: MemoryDetailView(memory: memory)) {
                                UpcomingCardView(memory: memory, reminder: reminder)
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding(.horizontal)
        }
        .background(Color.black)
        .navigationBarHidden(true)
    }
}

#Preview {
    UpcomingDetailView()
        .environmentObject(DataManager.shared)
}
