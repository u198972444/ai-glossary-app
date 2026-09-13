//
//  HomeView.swift
//  AIGlossaryApp
//
//  首頁 — 每日一詞 + 繼續瀏覽
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: GlossaryViewModel
    @Binding var selectedTerm: Term?

    private var daily: Term { viewModel.dailyTerm }
    private var browseTerms: [Term] { viewModel.browseTerms(after: daily) }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 2) {
                        Text("每日一詞")
                            .font(.editorialTitle(28))
                            .foregroundColor(AppTheme.primaryText)
                        Text("每天學一個 AI 專有名詞")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(AppTheme.secondaryText)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 14)
                    .overlay(
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(AppTheme.primaryText),
                        alignment: .bottom
                    )
                    .padding(.bottom, 16)

                    // Daily Card
                    DailyCard(term: daily) {
                        selectedTerm = daily
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)

                    // Browse Section
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("繼續瀏覽")
                                .font(.editorialTitle(16))
                                .foregroundColor(AppTheme.primaryText)
                            Spacer()
                            Text("共 \(GlossaryData.shared.terms.count) 個")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(AppTheme.mutedText)
                        }
                        .padding(.bottom, 8)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(AppTheme.border),
                            alignment: .bottom
                        )
                        .padding(.bottom, 4)

                        ForEach(browseTerms) { term in
                            TermListItem(term: term) {
                                selectedTerm = term
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 20)
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
