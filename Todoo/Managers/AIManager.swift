//
//  AIManager.swift
//  Todoo
//
//  Created on 2025-12-30.
//

import Foundation
import Vision
import UIKit
import NaturalLanguage

class AIManager {
    static let shared = AIManager()

    private init() {}

    // MARK: - OCR Text Extraction

    func extractText(from image: UIImage, completion: @escaping (String?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }

        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                completion(nil)
                return
            }

            let recognizedStrings = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }

            let fullText = recognizedStrings.joined(separator: "\n")
            completion(fullText.isEmpty ? nil : fullText)
        }

        request.recognitionLanguages = ["zh-Hans", "zh-Hant", "en-US"]
        request.recognitionLevel = .accurate

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }

    // MARK: - Natural Language Processing

    func parseMemoryContent(_ text: String) -> (title: String, category: String, time: Date?, color: MemoryColor) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)

        // Extract time information
        let extractedTime = extractTime(from: trimmedText)

        // Extract category/title
        let (title, category) = extractTitleAndCategory(from: trimmedText)

        // Determine color based on category
        let color = determineColor(for: category)

        return (title, category, extractedTime, color)
    }

    private func extractTime(from text: String) -> Date? {
        let calendar = Calendar.current
        let now = Date()

        // 今天/今晚 + 时间
        if let match = text.range(of: #"今[天晚].*?(\d{1,2})[::：点](\d{0,2})"#, options: .regularExpression) {
            let timeString = String(text[match])
            if let hour = extractHour(from: timeString) {
                var components = calendar.dateComponents([.year, .month, .day], from: now)
                components.hour = hour
                components.minute = extractMinute(from: timeString) ?? 0
                return calendar.date(from: components)
            }
        }

        // 明天 + 时间
        if let match = text.range(of: #"明天.*?(\d{1,2})[::：点](\d{0,2})"#, options: .regularExpression) {
            let timeString = String(text[match])
            if let hour = extractHour(from: timeString) {
                var components = calendar.dateComponents([.year, .month, .day], from: now)
                components.day = (components.day ?? 0) + 1
                components.hour = hour
                components.minute = extractMinute(from: timeString) ?? 0
                return calendar.date(from: components)
            }
        }

        // 下午/晚上
        if text.contains("下午") || text.contains("晚上") {
            if let hour = extractHour(from: text) {
                var components = calendar.dateComponents([.year, .month, .day], from: now)
                components.hour = hour >= 12 ? hour : hour + 12
                components.minute = extractMinute(from: text) ?? 0
                return calendar.date(from: components)
            }
        }

        // Today/Tomorrow in English
        if text.lowercased().contains("today") || text.lowercased().contains("tonight") {
            if let hour = extractHourEnglish(from: text) {
                var components = calendar.dateComponents([.year, .month, .day], from: now)
                components.hour = hour
                components.minute = extractMinuteEnglish(from: text) ?? 0
                return calendar.date(from: components)
            }
        }

        return nil
    }

    private func extractHour(from text: String) -> Int? {
        if let match = text.range(of: #"(\d{1,2})[::：点]"#, options: .regularExpression) {
            let numberString = text[match].replacingOccurrences(of: "[::：点]", with: "", options: .regularExpression)
            return Int(numberString)
        }
        return nil
    }

    private func extractMinute(from text: String) -> Int? {
        if let match = text.range(of: #"[::：点](\d{2})"#, options: .regularExpression) {
            let numberString = String(text[match].dropFirst())
            return Int(numberString)
        }
        return nil
    }

    private func extractHourEnglish(from text: String) -> Int? {
        if let match = text.range(of: #"\b(\d{1,2}):(\d{2})\b"#, options: .regularExpression) {
            let timeString = String(text[match])
            let components = timeString.split(separator: ":")
            if let hour = Int(components[0]) {
                return hour
            }
        }
        return nil
    }

    private func extractMinuteEnglish(from text: String) -> Int? {
        if let match = text.range(of: #"\b(\d{1,2}):(\d{2})\b"#, options: .regularExpression) {
            let timeString = String(text[match])
            let components = timeString.split(separator: ":")
            if components.count > 1, let minute = Int(components[1]) {
                return minute
            }
        }
        return nil
    }

    private func extractTitleAndCategory(from text: String) -> (String, String) {
        // Common categories
        let categories = ["睡觉", "跑步", "写代码", "去北京", "买菜", "开会", "锻炼", "学习", "工作"]

        for category in categories {
            if text.contains(category) {
                return (text, category)
            }
        }

        // Default: use first line or first few words as title
        let lines = text.components(separatedBy: .newlines)
        let title = lines.first ?? text
        let shortTitle = String(title.prefix(20))

        return (shortTitle, "")
    }

    private func determineColor(for category: String) -> MemoryColor {
        switch category {
        case "睡觉", "休息":
            return .brown
        case "写代码", "编程", "工作":
            return .purple
        case "跑步", "锻炼", "运动":
            return .green
        case let cat where cat.contains("去") || cat.contains("北京"):
            return .pink
        case "学习", "阅读":
            return .blue
        default:
            return .brown
        }
    }

    // MARK: - Smart Title Generation

    func generateSmartTitle(from text: String, time: Date?) -> String {
        if let time = time {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "zh_CN")
            formatter.dateFormat = "a h:mm"

            let timeString = formatter.string(from: time)
            let content = text.components(separatedBy: .newlines).first ?? text

            if Calendar.current.isDateInToday(time) {
                return "今天\(timeString) \(content)"
            } else if Calendar.current.isDateInTomorrow(time) {
                return "明天\(timeString) \(content)"
            }
        }

        return text
    }
}
