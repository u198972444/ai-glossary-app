//
//  AIGlossaryWidget.swift
//  AIGlossaryWidget
//
//  Widget 入口 — 支援桌面與鎖屏 Widget
//

import WidgetKit
import SwiftUI

@main
struct AIGlossaryWidgetBundle: WidgetBundle {
    var body: some Widget {
        AIGlossaryWidget()
        AIGlossaryLockScreenWidget()
    }
}

// MARK: - Home Screen Widget

struct AIGlossaryWidget: Widget {
    let kind: String = "AIGlossaryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WidgetProvider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("AI 每日一詞")
        .description("每天顯示一個 AI 專有名詞與繁體中文解釋")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Lock Screen Widget

struct AIGlossaryLockScreenWidget: Widget {
    let kind: String = "AIGlossaryLockScreenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WidgetProvider()) { entry in
            LockScreenWidgetView(entry: entry)
        }
        .configurationDisplayName("AI 單詞鎖屏")
        .description("在鎖屏顯示今日 AI 術語")
        .supportedFamilies([.accessoryRectangular, .accessoryInline, .accessoryCircular])
    }
}
