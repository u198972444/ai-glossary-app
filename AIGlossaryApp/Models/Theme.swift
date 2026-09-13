//
//  Theme.swift
//  AIGlossaryApp
//
//  配色主題 — 暖米白底 + 霧霾藍字（編輯雜誌風）
//

import SwiftUI

enum AppTheme {
    // 背景
    static let background = Color(red: 0.94, green: 0.92, blue: 0.89)      // #F0EBE3
    static let cardBackground = Color(red: 0.96, green: 0.95, blue: 0.92)    // #F5F1EA
    static let secondaryBackground = Color(red: 0.91, green: 0.89, blue: 0.85)

    // 文字
    static let primaryText = Color(red: 0.17, green: 0.29, blue: 0.42)       // #2C4A6B
    static let secondaryText = Color(red: 0.35, green: 0.48, blue: 0.58)     // #5A7A94
    static let mutedText = Color(red: 0.56, green: 0.64, blue: 0.71)         // #8FA3B5

    // 強調
    static let accent = Color(red: 0.11, green: 0.23, blue: 0.36)            // #1B3A5C
    static let accentLight = Color(red: 0.85, green: 0.88, blue: 0.91)       // #C8D3DC

    // 邊框
    static let border = Color(red: 0.78, green: 0.83, blue: 0.86)             // #C8D3DC
    static let borderLight = Color(red: 0.88, green: 0.90, blue: 0.92)       // #E0E6EB

    // 分類標籤底色（低飽和）
    static func categoryColor(_ category: String) -> Color {
        switch category {
        case "foundations", "computer_learning": return Color(red: 0.85, green: 0.88, blue: 0.93)
        case "machine_learning": return Color(red: 0.85, green: 0.92, blue: 0.87)
        case "deep_learning": return Color(red: 0.89, green: 0.86, blue: 0.93)
        case "nlp_llm": return Color(red: 0.93, green: 0.86, blue: 0.90)
        case "computer_vision": return Color(red: 0.85, green: 0.92, blue: 0.93)
        case "generative_ai": return Color(red: 0.95, green: 0.89, blue: 0.82)
        case "reinforcement_learning": return Color(red: 0.95, green: 0.93, blue: 0.82)
        case "ai_agents", "robotics": return Color(red: 0.93, green: 0.85, blue: 0.85)
        case "ai_engineering": return Color(red: 0.87, green: 0.92, blue: 0.86)
        case "data_training": return Color(red: 0.88, green: 0.88, blue: 0.93)
        case "ai_ethics_safety": return Color(red: 0.93, green: 0.85, blue: 0.86)
        case "hardware_compute": return Color(red: 0.90, green: 0.93, blue: 0.82)
        case "multimodal": return Color(red: 0.93, green: 0.85, blue: 0.92)
        case "math_stats": return Color(red: 0.85, green: 0.92, blue: 0.91)
        case "products_tools": return Color(red: 0.90, green: 0.91, blue: 0.92)
        default: return Color(red: 0.88, green: 0.90, blue: 0.92)
        }
    }
}

// 字體擴展
extension Font {
    static func editorialTitle(_ size: CGFloat) -> Font {
        .system(size: size, weight: .bold, design: .serif)
    }
    static func editorialBody(_ size: CGFloat = 15) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }
}
