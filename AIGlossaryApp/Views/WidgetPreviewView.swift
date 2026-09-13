//
//  WidgetPreviewView.swift
//  AIGlossaryApp
//
//  Widget 預覽頁 — 模擬鎖屏與桌面 Widget 效果
//

import SwiftUI

struct WidgetPreviewView: View {
    @Environment(\.dismiss) private var dismiss
    private let sampleTerms = Array(GlossaryData.shared.terms.prefix(4))

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(AppTheme.secondaryText)
                        }
                        Spacer()
                        Text("Widget 預覽")
                            .font(.editorialTitle(18))
                            .foregroundColor(AppTheme.primaryText)
                        Spacer()
                        Color.clear.frame(width: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)

                    // Lock Screen Widget
                    VStack(spacing: 8) {
                        phoneFrame(title: "鎖屏畫面") {
                            if let term = sampleTerms.first {
                                widgetCard(term: term, size: .medium)
                            }
                        }
                        Text("中尺寸鎖屏 Widget")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(AppTheme.mutedText)
                    }
                    .padding(.bottom, 20)

                    // Home Screen Widgets
                    VStack(spacing: 8) {
                        phoneFrame(title: "桌面畫面") {
                            HStack(spacing: 8) {
                                if sampleTerms.indices.contains(1) {
                                    widgetCard(term: sampleTerms[1], size: .small)
                                }
                                if sampleTerms.indices.contains(2) {
                                    widgetCard(term: sampleTerms[2], size: .medium)
                                }
                            }
                            if sampleTerms.indices.contains(3) {
                                widgetCard(term: sampleTerms[3], size: .large)
                                    .padding(.top, 8)
                            }
                        }
                        Text("小 / 中 / 大 三種尺寸")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(AppTheme.mutedText)
                    }
                    .padding(.bottom, 20)

                    Text("實際 Widget 將在每日 00:00 自動更新為新術語\n長按 Widget 可編輯顯示的分類")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.mutedText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 20)
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func phoneFrame<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(AppTheme.mutedText)
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.91, green: 0.92, blue: 0.94),
                                Color(red: 0.87, green: 0.89, blue: 0.92)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                VStack { content() }
                    .padding(14)
            }
            .frame(height: 200)
            .padding(.horizontal, 16)
        }
    }

    private enum WidgetSize { case small, medium, large }

    private func widgetCard(term: Term, size: WidgetSize) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if let cat = GlossaryCategory(rawValue: term.category) {
                Text(cat.displayName)
                    .font(.system(size: size == .small ? 8 : 9, weight: .bold))
                    .foregroundColor(AppTheme.accent)
            }
            Text(term.term)
                .font(.editorialTitle(size == .small ? 12 : 14))
                .foregroundColor(AppTheme.primaryText)
                .lineLimit(1)
            Text(term.definition)
                .font(.system(size: size == .small ? 9 : 11))
                .foregroundColor(AppTheme.secondaryText)
                .lineLimit(size == .small ? 1 : size == .medium ? 2 : 3)
        }
        .padding(size == .small ? 10 : 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.95))
        .cornerRadius(0)
        .overlay(Rectangle().stroke(AppTheme.border, lineWidth: 1))
    }
}
