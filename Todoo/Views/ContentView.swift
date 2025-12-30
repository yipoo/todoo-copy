//
//  ContentView.swift
//  Todoo
//
//  Created on 2025-12-30.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingCreateSheet = false
    @State private var newMemoryText = ""

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with logo
                        HeaderView()

                        // Upcoming section
                        UpcomingSection()

                        // Memories section
                        MemoriesSection()

                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal)
                }
                .background(Color.black)

                // Bottom input bar
                BottomInputBar(showingCreateSheet: $showingCreateSheet)
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingCreateSheet) {
            CreateMemoryView()
        }
    }
}

// MARK: - Header View

struct HeaderView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 4) {
                Image(systemName: "circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                    .overlay(
                        VStack {
                            HStack {
                                Spacer()
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 12, height: 12)
                                    .offset(x: -8, y: 8)
                            }
                        }
                    )
                    .overlay(
                        Image(systemName: "greaterthan")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .offset(x: 5)
                    )
            }
            Spacer()
        }
        .padding(.top, 50)
        .padding(.bottom, 20)
    }
}

// MARK: - Upcoming Section

struct UpcomingSection: View {
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            NavigationLink(destination: UpcomingDetailView()) {
                HStack {
                    Text("Upcoming")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }

            if let nextReminder = dataManager.upcomingReminders.first,
               let memory = dataManager.getMemory(for: nextReminder) {
                NavigationLink(destination: MemoryDetailView(memory: memory)) {
                    UpcomingCardView(memory: memory, reminder: nextReminder)
                }
            }
        }
    }
}

// MARK: - Memories Section

struct MemoriesSection: View {
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            NavigationLink(destination: AllMemoriesView()) {
                HStack {
                    Text("Memories")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }

            // Filter buttons
            HStack(spacing: 12) {
                FilterButton(title: "All", icon: "square.grid.2x2.fill", isSelected: true)
                FilterButton(title: "", icon: "bookmark.fill", isSelected: false)
                Spacer()
                Button(action: {}) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.gray.opacity(0.3))
                        .clipShape(Circle())
                }
            }

            // Info card
            InfoCardView()

            // Recent memories grid
            RecentMemoriesGrid()
        }
    }
}

struct FilterButton: View {
    let title: String
    let icon: String
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
            if !title.isEmpty {
                Text(title)
            }
        }
        .font(.system(size: 16, weight: .semibold))
        .foregroundColor(isSelected ? .black : .white)
        .padding(.horizontal, title.isEmpty ? 16 : 20)
        .padding(.vertical, 12)
        .background(isSelected ? Color.blue : Color.gray.opacity(0.3))
        .clipShape(Capsule())
    }
}

struct InfoCardView: View {
    @State private var showInfo = true

    var body: some View {
        if showInfo {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("All Memories")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    Text("View all saved memories, sorted by time in reverse chronological order, for quick browsing...")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(2)
                }
                Spacer()
                Button(action: { showInfo = false }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                }
            }
            .padding()
            .background(Color.blue.opacity(0.3))
            .cornerRadius(16)
        }
    }
}

struct RecentMemoriesGrid: View {
    @EnvironmentObject var dataManager: DataManager

    var recentMemories: [Memory] {
        dataManager.activeMemories
            .sorted { $0.createdAt > $1.createdAt }
            .prefix(2)
            .map { $0 }
    }

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(recentMemories) { memory in
                NavigationLink(destination: MemoryDetailView(memory: memory)) {
                    MemoryCardView(memory: memory, size: .medium)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DataManager.shared)
}
