//
//  TodooApp.swift
//  Todoo
//
//  Created on 2025-12-30.
//

import SwiftUI

@main
struct TodooApp: App {
    @StateObject private var dataManager = DataManager.shared

    init() {
        // Request notification permissions
        NotificationManager.shared.requestAuthorization()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
                .preferredColorScheme(.dark)
                .onAppear {
                    // Uncomment to load sample data on first launch
                    // loadSampleDataIfNeeded()
                }
        }
    }

    private func loadSampleDataIfNeeded() {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if !hasLaunchedBefore {
            dataManager.loadSampleData()
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
    }
}
