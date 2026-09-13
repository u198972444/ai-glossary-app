//
//  WidgetViews.swift
//  AIGlossaryWidget
//
//  Widget 視圖 — 小/中/大三種尺寸 + 鎖屏
//

import WidgetKit
import SwiftUI

// MARK: - Home Screen Widget View

struct WidgetEntryView: View {
    let entry: WidgetEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(term: entry.term)
        case .systemMedium:
            MediumWidgetView(term: entry.term)
        case .systemLarge:
            LargeWidgetView(term: entry.term)
        default:
            MediumWidgetView(term: entry.term)
        }
    }
}

// MARK: - Small Widget

struct SmallWidgetView: View {
    let term: Term

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let cat = GlossaryCategory(rawValue: term.category) {
                Text(cat.displayName)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(Color(red: 0.11, green: 0.23, blue: 0.36))
            }
            Text(term.term)
                .font(.system(size: 14, weight: .bold, design: .serif))
                .foregroundColor(Color(red: 0.17, green: 0.29, blue: 0.42))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(term.definition)
                .font(.system(size: 10))
                .foregroundColor(Color(red: 0.35, green: 0.48, blue: 0.58))
                .lineLimit(2)
            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(red: 0.96, green: 0.95, blue: 0.92))
        .widgetURL(URL(string: "aiglossary://term/\(term.id)")!)
    }
}

// MARK: - Medium Widget

struct MediumWidgetView: View {
    let term: Term

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                if let cat = GlossaryCategory(rawValue: term.category) {
                    Text(cat.displayName)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(red: 0.11, green: 0.23, blue: 0.36))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .overlay(
                            Rectangle().stroke(Color(red: 0.11, green: 0.23, blue: 0.36).opacity(0.3), lineWidth: 1)
                        )
                }
                Spacer()
                Text("每日一詞")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(Color(red: 0.56, green: 0.64, blue: 0.71))
            }

            Text(term.term)
                .font(.system(size: 20, weight: .bold, design: .serif))
                .foregroundColor(Color(red: 0.17, green: 0.29, blue: 0.42))
                .lineLimit(1)

            if !term.abbr.isEmpty {
                Text("(\(term.abbr))")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(red: 0.11, green: 0.23, blue: 0.36))
            }

            Text(term.definition)
                .font(.system(size: 12))
                .foregroundColor(Color(red: 0.35, green: 0.48, blue: 0.58))
                .lineLimit(3)

            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(red: 0.96, green: 0.95, blue: 0.92))
        .widgetURL(URL(string: "aiglossary://term/\(term.id)")!)
    }
}

// MARK: - Large Widget

struct LargeWidgetView: View {
    let term: Term

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let cat = GlossaryCategory(rawValue: term.category) {
                    Text(cat.displayName)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(red: 0.11, green: 0.23, blue: 0.36))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .overlay(
                            Rectangle().stroke(Color(red: 0.11, green: 0.23, blue: 0.36).opacity(0.3), lineWidth: 1)
                        )
                }
                Spacer()
                Text("每日一詞")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(Color(red: 0.56, green: 0.64, blue: 0.71))
            }

            Text(term.term)
                .font(.system(size: 24, weight: .bold, design: .serif))
                .foregroundColor(Color(red: 0.17, green: 0.29, blue: 0.42))
                .lineLimit(1)

            if !term.abbr.isEmpty {
                Text("(\(term.abbr))")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(red: 0.11, green: 0.23, blue: 0.36))
            }

            Text(term.definition)
                .font(.system(size: 13))
                .foregroundColor(Color(red: 0.35, green: 0.48, blue: 0.58))
                .lineLimit(5)
                .lineSpacing(3)

            // Example
            VStack(alignment: .leading, spacing: 4) {
                Text("實例")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color(red: 0.56, green: 0.64, blue: 0.71))
                Text(term.example)
                    .font(.system(size: 11))
                    .foregroundColor(Color(red: 0.17, green: 0.29, blue: 0.42))
                    .lineLimit(3)
                    .padding(8)
                    .background(Color(red: 0.85, green: 0.88, blue: 0.91).opacity(0.3))
            }

            Spacer(minLength: 0)

            Text("點擊查看完整解釋 →")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(Color(red: 0.56, green: 0.64, blue: 0.71))
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(red: 0.96, green: 0.95, blue: 0.92))
        .widgetURL(URL(string: "aiglossary://term/\(term.id)")!)
    }
}

// MARK: - Lock Screen Widget View

struct LockScreenWidgetView: View {
    let entry: WidgetEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        switch family {
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.term.term)
                    .font(.system(size: 13, weight: .bold))
                    .lineLimit(1)
                Text(entry.term.definition)
                    .font(.system(size: 10))
                    .lineLimit(2)
            }
            .widgetURL(URL(string: "aiglossary://term/\(entry.term.id)")!)

        case .accessoryInline:
            Text("\(entry.term.term) — \(entry.term.definition.prefix(20))...")
                .font(.system(size: 11))
                .widgetURL(URL(string: "aiglossary://term/\(entry.term.id)")!)

        case .accessoryCircular:
            VStack(spacing: 2) {
                Image(systemName: "book")
                    .font(.system(size: 12))
                Text("AI")
                    .font(.system(size: 10, weight: .bold))
            }
            .widgetURL(URL(string: "aiglossary://term/\(entry.term.id)")!)

        default:
            Text(entry.term.term)
                .font(.system(size: 12, weight: .bold))
        }
    }
}
