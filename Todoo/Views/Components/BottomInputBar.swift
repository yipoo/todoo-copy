//
//  BottomInputBar.swift
//  Todoo
//
//  Created on 2025-12-30.
//

import SwiftUI

struct BottomInputBar: View {
    @Binding var showingCreateSheet: Bool
    @State private var inputText = ""

    var body: some View {
        HStack(spacing: 12) {
            // Text input field
            TextField("Tap to type, hold to talk", text: $inputText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(25)
                .submitLabel(.done)
                .onSubmit {
                    if !inputText.isEmpty {
                        createMemoryFromText(inputText)
                        inputText = ""
                    }
                }

            // Attachment button
            Button(action: {
                showingCreateSheet = true
            }) {
                Image(systemName: "paperclip")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }

            // Voice input button
            Button(action: {
                showingCreateSheet = true
            }) {
                Image(systemName: "mic.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.red)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.95))
    }

    private func createMemoryFromText(_ text: String) {
        let aiManager = AIManager.shared
        let dataManager = DataManager.shared

        let parsed = aiManager.parseMemoryContent(text)
        let title = aiManager.generateSmartTitle(from: parsed.title, time: parsed.time)

        let memory = Memory(
            title: title,
            content: text,
            category: parsed.category,
            color: parsed.color
        )

        dataManager.addMemory(memory)

        // Create reminder if time was extracted
        if let time = parsed.time {
            let reminder = Reminder(
                memoryID: memory.id,
                title: parsed.category.isEmpty ? parsed.title : parsed.category,
                remindTime: time
            )
            dataManager.addReminder(reminder)
        }
    }
}
