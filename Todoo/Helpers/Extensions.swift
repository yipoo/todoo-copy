//
//  Extensions.swift
//  Todoo
//
//  Created on 2025-12-30.
//

import Foundation
import SwiftUI

// MARK: - Date Extensions

extension Date {
    func formatChinese() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "今天 HH:mm"

        let calendar = Calendar.current

        if calendar.isDateInToday(self) {
            formatter.dateFormat = "'今天' HH:mm"
        } else if calendar.isDateInYesterday(self) {
            formatter.dateFormat = "'昨天' HH:mm"
        } else if calendar.isDateInTomorrow(self) {
            formatter.dateFormat = "'明天' HH:mm"
        } else {
            let components = calendar.dateComponents([.day], from: Date(), to: self)
            if let days = components.day, days < 30, days > 0 {
                formatter.dateFormat = "M'月'd'日' HH:mm"
            } else {
                formatter.dateFormat = "M'月'd'日' HH:mm"
            }
        }

        return formatter.string(from: self)
    }

    func formatEnglish() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")

        let calendar = Calendar.current

        if calendar.isDateInToday(self) {
            formatter.dateFormat = "'Today' HH:mm"
        } else if calendar.isDateInYesterday(self) {
            formatter.dateFormat = "'Yesterday' HH:mm"
        } else if calendar.isDateInTomorrow(self) {
            formatter.dateFormat = "'Tomorrow' HH:mm"
        } else {
            formatter.dateFormat = "MMM d HH:mm"
        }

        return formatter.string(from: self)
    }

    func timeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }

    func isToday() -> Bool {
        Calendar.current.isDateInToday(self)
    }

    func isTomorrow() -> Bool {
        Calendar.current.isDateInTomorrow(self)
    }
}

// MARK: - Color Extensions

extension Color {
    static let todooBackground = Color.black
    static let todooCard = Color.gray.opacity(0.2)
    static let todooText = Color.white
    static let todooSecondaryText = Color.gray
}

// MARK: - View Extensions

extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(Color.todooCard)
            .cornerRadius(12)
    }

    func primaryButton() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
    }
}
