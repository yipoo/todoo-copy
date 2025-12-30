//
//  CreateMemoryView.swift
//  Todoo
//
//  Created on 2025-12-30.
//

import SwiftUI
import PhotosUI

enum InputMode {
    case text
    case voice
    case image
}

struct CreateMemoryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager

    @State private var inputMode: InputMode = .text
    @State private var inputText = ""
    @State private var selectedImage: UIImage?
    @State private var isRecording = false
    @State private var showImagePicker = false
    @State private var showReminderPicker = false
    @State private var reminderDate = Date()

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(.white)

                        Spacer()

                        Text("Create Memory")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)

                        Spacer()

                        Button("Done") {
                            createMemory()
                        }
                        .foregroundColor(.blue)
                        .disabled(inputText.isEmpty && selectedImage == nil)
                    }
                    .padding()

                    // Input mode selector
                    HStack(spacing: 20) {
                        InputModeButton(
                            icon: "text.alignleft",
                            title: "Text",
                            isSelected: inputMode == .text
                        ) {
                            inputMode = .text
                        }

                        InputModeButton(
                            icon: "mic.fill",
                            title: "Voice",
                            isSelected: inputMode == .voice
                        ) {
                            inputMode = .voice
                        }

                        InputModeButton(
                            icon: "photo",
                            title: "Image",
                            isSelected: inputMode == .image
                        ) {
                            inputMode = .image
                            showImagePicker = true
                        }
                    }
                    .padding(.horizontal)

                    // Main input area
                    ScrollView {
                        VStack(spacing: 16) {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 300)
                                    .cornerRadius(12)
                                    .overlay(
                                        Button(action: { selectedImage = nil }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.system(size: 24))
                                                .foregroundColor(.white)
                                                .background(Color.black.opacity(0.6))
                                                .clipShape(Circle())
                                        }
                                        .padding(8),
                                        alignment: .topTrailing
                                    )
                            }

                            if inputMode == .text || selectedImage != nil {
                                TextEditor(text: $inputText)
                                    .frame(minHeight: 200)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(12)
                                    .foregroundColor(.white)
                                    .scrollContentBackground(.hidden)
                            }

                            if inputMode == .voice {
                                VoiceRecorderView(
                                    isRecording: $isRecording,
                                    transcribedText: $inputText
                                )
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Add reminder button
                    Button(action: { showReminderPicker = true }) {
                        HStack {
                            Image(systemName: "bell")
                            Text("Add Reminder")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage, inputText: $inputText)
        }
        .sheet(isPresented: $showReminderPicker) {
            ReminderPickerView(selectedDate: $reminderDate, isPresented: $showReminderPicker)
        }
    }

    private func createMemory() {
        let aiManager = AIManager.shared

        // Process image if available
        if let image = selectedImage {
            aiManager.extractText(from: image) { extractedText in
                if let text = extractedText, !text.isEmpty {
                    inputText = inputText.isEmpty ? text : "\(inputText)\n\(text)"
                }
                finalizeMemoryCreation()
            }
        } else {
            finalizeMemoryCreation()
        }
    }

    private func finalizeMemoryCreation() {
        let aiManager = AIManager.shared
        let parsed = aiManager.parseMemoryContent(inputText)
        let title = aiManager.generateSmartTitle(from: parsed.title, time: parsed.time)

        var imageData: Data?
        if let image = selectedImage {
            imageData = image.jpegData(compressionQuality: 0.8)
        }

        let memory = Memory(
            title: title,
            content: inputText,
            category: parsed.category,
            imageData: imageData,
            color: parsed.color
        )

        dataManager.addMemory(memory)

        // Create reminder if time was extracted or manually set
        let reminderTime = parsed.time ?? (showReminderPicker ? reminderDate : nil)
        if let time = reminderTime {
            let reminder = Reminder(
                memoryID: memory.id,
                title: parsed.category.isEmpty ? parsed.title : parsed.category,
                remindTime: time
            )
            dataManager.addReminder(reminder)
        }

        dismiss()
    }
}

struct InputModeButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(title)
                    .font(.system(size: 14))
            }
            .foregroundColor(isSelected ? .blue : .gray)
            .padding()
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
            .cornerRadius(12)
        }
    }
}

struct VoiceRecorderView: View {
    @Binding var isRecording: Bool
    @Binding var transcribedText: String

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(isRecording ? Color.red.opacity(0.3) : Color.gray.opacity(0.2))
                    .frame(width: 120, height: 120)

                Button(action: {
                    isRecording.toggle()
                    if !isRecording {
                        // Simulate transcription
                        transcribedText = "Transcribed voice input will appear here..."
                    }
                }) {
                    Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(isRecording ? .red : .white)
                }
            }

            if isRecording {
                Text("Recording...")
                    .foregroundColor(.red)
                    .font(.system(size: 16))
            } else {
                Text("Tap to record")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
            }
        }
        .padding(.vertical, 40)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var inputText: String
    @Environment(\.dismiss) var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image

                // Extract text from image
                AIManager.shared.extractText(from: image) { text in
                    if let extractedText = text {
                        DispatchQueue.main.async {
                            parent.inputText = extractedText
                        }
                    }
                }
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

struct ReminderPickerView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Remind me at",
                    selection: $selectedDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical)
                .colorScheme(.dark)
                .padding()

                Button("Done") {
                    isPresented = false
                }
                .foregroundColor(.blue)
                .padding()
            }
            .background(Color.black)
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CreateMemoryView()
        .environmentObject(DataManager.shared)
}
