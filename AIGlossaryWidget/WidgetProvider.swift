//
//  WidgetProvider.swift
//  AIGlossaryWidget
//
//  Widget Timeline Provider — 每日更新
//

import WidgetKit
import Foundation

struct WidgetEntry: TimelineEntry {
    let date: Date
    let term: Term
}

struct WidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date(), term: placeholderTerm())
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> Void) {
        let entry = WidgetEntry(date: Date(), term: currentTerm())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> Void) {
        let currentDate = Date()
        let term = currentTerm()

        // 每日 00:00 更新（或使用者設定的時間）
        let calendar = Calendar.current
        let nextUpdate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate) ?? currentDate.addingTimeInterval(86400)

        let entry = WidgetEntry(date: currentDate, term: term)
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    // MARK: - Helpers

    private func currentTerm() -> Term {
        // 從 App Group 共享的 UserDefaults 讀取使用者設定的每日更新時間
        // 預設使用當日日期對應的術語
        GlossaryData.shared.dailyTerm()
    }

    private func placeholderTerm() -> Term {
        Term(
            id: 0,
            term: "Artificial Intelligence",
            abbr: "AI",
            category: "foundations",
            definition: "人工智慧。讓電腦或機器模擬人類智慧行為的技術領域，包括機器學習、深度學習、自然語言處理、電腦視覺等。",
            example: "語音助理、自動駕駛、圖像辨識都是人工智慧的應用。",
            related: ["Machine Learning", "Deep Learning"]
        )
    }
}
