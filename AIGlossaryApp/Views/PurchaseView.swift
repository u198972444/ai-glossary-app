//
//  PurchaseView.swift
//  AIGlossaryApp
//
//  購買頁 — 7 天試用說明 + NT$220 買斷
//

import SwiftUI

struct PurchaseView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppTheme.accent)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("完整解鎖")
                                .font(.editorialTitle(20))
                                .foregroundColor(AppTheme.primaryText)
                            Text("一次買斷")
                                .font(.system(size: 13))
                                .foregroundColor(AppTheme.secondaryText)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 16)

                    // Trial Card
                    VStack(spacing: 6) {
                        Image(systemName: "target")
                            .font(.system(size: 28))
                            .foregroundColor(AppTheme.accent)
                        Text(purchaseManager.isUnlocked ? "已解鎖" : "7 天免費試用")
                            .font(.editorialTitle(18))
                            .foregroundColor(AppTheme.primaryText)
                        if !purchaseManager.isUnlocked {
                            Text("\(purchaseManager.trialDaysRemaining)")
                                .font(.editorialTitle(40))
                                .foregroundColor(AppTheme.accent)
                            Text("試用期內所有功能完全解鎖\n期滿買斷即可繼續使用")
                                .font(.system(size: 13))
                                .foregroundColor(AppTheme.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(AppTheme.accentLight.opacity(0.3))
                    .overlay(Rectangle().stroke(AppTheme.accent, lineWidth: 1))
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)

                    // Feature List
                    VStack(alignment: .leading, spacing: 0) {
                        featureItem(title: "全部 354 個 AI 術語", subtitle: "覆蓋 17 個分類")
                        featureItem(title: "鎖屏 + 桌面 Widget", subtitle: "三種尺寸自由選擇")
                        featureItem(title: "所有未來更新免費", subtitle: "AI 新技術持續加入")
                        featureItem(title: "零廣告", subtitle: "純淨學習體驗")
                        featureItem(title: "收藏與學習進度", subtitle: "追蹤你的學習軌跡")
                        featureItem(title: "測驗模式", subtitle: "驗證學習成果", isLast: true)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)

                    // Purchase Button
                    if purchaseManager.isUnlocked {
                        Text("✓ 已解鎖所有功能")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppTheme.accent)
                            .padding(.horizontal, 16)
                    } else {
                        Button(action: {
                            Task { await purchaseManager.purchase() }
                        }) {
                            VStack(spacing: 2) {
                                Text("NT$220 一次買斷")
                                    .font(.system(size: 17, weight: .bold))
                                Text("含所有未來更新 · 無訂閱 · 零廣告")
                                    .font(.system(size: 11, weight: .regular))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppTheme.accent)
                        }
                        .disabled(purchaseManager.isLoading)
                        .padding(.horizontal, 16)

                        Button(action: {
                            Task { await purchaseManager.restorePurchase() }
                        }) {
                            Text("恢復購買")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(AppTheme.secondaryText)
                        }
                        .padding(.top, 10)
                    }

                    Text("Demo 預覽：實際上架後透過 Apple App Store 內購完成交易\n買斷制無訂閱，一次付費終身使用")
                        .font(.system(size: 11))
                        .foregroundColor(AppTheme.mutedText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 20)
                }
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func featureItem(title: String, subtitle: String, isLast: Bool = false) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Rectangle()
                .fill(AppTheme.accent)
                .frame(width: 5, height: 5)
                .padding(.top, 7)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppTheme.primaryText)
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.secondaryText)
            }
            Spacer()
        }
        .padding(.vertical, 10)
        .overlay(
            Group {
                if !isLast {
                    Rectangle().frame(height: 1).foregroundColor(AppTheme.borderLight)
                }
            },
            alignment: .bottom
        )
    }
}
