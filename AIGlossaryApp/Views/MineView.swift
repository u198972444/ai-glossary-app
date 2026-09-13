//
//  MineView.swift
//  AIGlossaryApp
//
//  我的頁 — 學習統計、試用狀態、設定
//

import SwiftUI

struct MineView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var viewModel: GlossaryViewModel
    @Binding var showPurchase: Bool
    @State private var showQuiz = false
    @State private var showWidgetPreview = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 2) {
                        Text("我的")
                            .font(.editorialTitle(28))
                            .foregroundColor(AppTheme.primaryText)
                        Text("學習進度")
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.secondaryText)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 14)

                    // Stats
                    HStack(spacing: 0) {
                        statItem(number: viewModel.learned.count, label: "已學習")
                        Rectangle().frame(width: 1).foregroundColor(AppTheme.border)
                        statItem(number: viewModel.favorites.count, label: "已收藏")
                        Rectangle().frame(width: 1).foregroundColor(AppTheme.border)
                        statItem(number: GlossaryData.shared.terms.count, label: "總術語")
                    }
                    .background(AppTheme.cardBackground)
                    .overlay(Rectangle().stroke(AppTheme.border, lineWidth: 1))
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)

                    // Trial Card
                    trialCard
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)

                    // Settings Groups
                    settingsGroup(title: nil) {
                        settingsRow(icon: "square.grid.2x2", title: "Widget 預覽") {
                            showWidgetPreview = true
                        }
                        settingsRow(icon: "questionmark.circle", title: "測驗模式") {
                            showQuiz = true
                        }
                        settingsRow(icon: "lock.open", title: "買斷解鎖", value: "NT$220") {
                            showPurchase = true
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)

                    settingsGroup(title: nil) {
                        settingsRow(icon: "clock", title: "每日更新時間", value: "00:00") {}
                        settingsRow(icon: "sun.max", title: "外觀模式", value: "淺色") {}
                        settingsRow(icon: "textformat", title: "字體大小", value: "標準") {}
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)

                    settingsGroup(title: nil) {
                        settingsRow(icon: "info.circle", title: "關於", value: "v1.0") {}
                        settingsRow(icon: "lock.shield", title: "隱私政策") {}
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
            .sheet(isPresented: $showQuiz) {
                QuizView()
                    .environmentObject(viewModel)
            }
            .sheet(isPresented: $showWidgetPreview) {
                WidgetPreviewView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func statItem(number: Int, label: String) -> some View {
        VStack(spacing: 4) {
            Text("\(number)")
                .font(.editorialTitle(22))
                .foregroundColor(AppTheme.accent)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(AppTheme.mutedText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
    }

    private var trialCard: some View {
        Button(action: { showPurchase = true }) {
            VStack(spacing: 6) {
                Image(systemName: "timer")
                    .font(.system(size: 28))
                    .foregroundColor(AppTheme.accent)
                Text(purchaseManager.isUnlocked ? "已解鎖" : "免費試用中")
                    .font(.editorialTitle(18))
                    .foregroundColor(AppTheme.primaryText)
                if !purchaseManager.isUnlocked {
                    Text("\(purchaseManager.trialDaysRemaining)")
                        .font(.editorialTitle(40))
                        .foregroundColor(AppTheme.accent)
                    Text("試用期內所有功能完全解鎖\n期滿後 NT$220 一次買斷")
                        .font(.system(size: 13))
                        .foregroundColor(AppTheme.secondaryText)
                        .multilineTextAlignment(.center)
                } else {
                    Text("感謝購買！所有功能與未來更新均已解鎖")
                        .font(.system(size: 13))
                        .foregroundColor(AppTheme.secondaryText)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(AppTheme.cardBackground)
            .overlay(Rectangle().stroke(AppTheme.accent, lineWidth: 2))
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func settingsGroup<Content: View>(title: String?, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            content()
        }
        .background(AppTheme.cardBackground)
        .overlay(Rectangle().stroke(AppTheme.border, lineWidth: 1))
    }

    private func settingsRow(icon: String, title: String, value: String? = nil, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.primaryText)
                    .frame(width: 20)
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.primaryText)
                Spacer()
                if let value = value {
                    Text(value)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(AppTheme.mutedText)
                }
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(AppTheme.mutedText)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 13)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .overlay(
            Rectangle().frame(height: 1).foregroundColor(AppTheme.borderLight),
            alignment: .bottom
        )
    }
}
