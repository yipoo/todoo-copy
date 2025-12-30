//
//  AllMemoriesView.swift
//  Todoo
//
//  Created on 2025-12-30.
//

import SwiftUI

struct AllMemoriesView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @State private var searchText = ""
    @State private var showBookmarkedOnly = false

    var filteredMemories: [Memory] {
        var memories = dataManager.activeMemories

        if showBookmarkedOnly {
            memories = memories.filter { $0.isPinned }
        }

        if !searchText.isEmpty {
            memories = memories.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText)
            }
        }

        return memories.sorted { $0.createdAt > $1.createdAt }
    }

    var groupedMemories: [(String, [Memory])] {
        let calendar = Calendar.current
        let now = Date()

        var todayMemories: [Memory] = []
        var past30DaysMemories: [Memory] = []
        var novemberMemories: [Memory] = []
        var olderMemories: [Memory] = []

        for memory in filteredMemories {
            if calendar.isDateInToday(memory.createdAt) || calendar.isDateInYesterday(memory.createdAt) {
                todayMemories.append(memory)
            } else if let daysAgo = calendar.dateComponents([.day], from: memory.createdAt, to: now).day, daysAgo <= 30 {
                past30DaysMemories.append(memory)
            } else {
                let components = calendar.dateComponents([.month, .year], from: memory.createdAt)
                if components.month == 11 && components.year == 2025 {
                    novemberMemories.append(memory)
                } else {
                    olderMemories.append(memory)
                }
            }
        }

        var groups: [(String, [Memory])] = []

        if !todayMemories.isEmpty {
            groups.append(("今 days", todayMemories))
        }
        if !past30DaysMemories.isEmpty {
            groups.append(("Past 30 Days", past30DaysMemories))
        }
        if !novemberMemories.isEmpty {
            groups.append(("November", novemberMemories))
        }
        if !olderMemories.isEmpty {
            groups.append(("Earlier", olderMemories))
        }

        return groups
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
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

                        Text("All Memories")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)

                        Spacer()

                        Button(action: {}) {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Color.gray.opacity(0.3))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.top, 50)

                    // Filter buttons
                    HStack(spacing: 12) {
                        FilterButton(title: "All", icon: "square.grid.2x2.fill", isSelected: !showBookmarkedOnly)
                            .onTapGesture { showBookmarkedOnly = false }

                        FilterButton(title: "", icon: "bookmark.fill", isSelected: showBookmarkedOnly)
                            .onTapGesture { showBookmarkedOnly = true }

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

                    // Grouped memories
                    ForEach(groupedMemories, id: \.0) { group in
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(group.0)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)

                                Text("\(group.1.count) memor\(group.1.count == 1 ? "y" : "ies")")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .padding(.leading, 4)
                            }

                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(group.1) { memory in
                                    NavigationLink(destination: MemoryDetailView(memory: memory)) {
                                        MemoryCardView(memory: memory, size: .medium)
                                    }
                                }
                            }
                        }
                    }

                    Spacer(minLength: 100)
                }
                .padding(.horizontal)
            }
            .background(Color.black)

            // Search bar at bottom
            SearchBarView(searchText: $searchText)
        }
        .navigationBarHidden(true)
    }
}

struct SearchBarView: View {
    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.system(size: 20))

            TextField("Search Memories", text: $searchText)
                .foregroundColor(.white)
                .accentColor(.blue)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color.gray.opacity(0.3))
        .cornerRadius(30)
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}

#Preview {
    AllMemoriesView()
        .environmentObject(DataManager.shared)
}
