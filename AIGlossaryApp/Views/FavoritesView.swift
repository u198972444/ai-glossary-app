//
//  FavoritesView.swift
//  AIGlossaryApp
//
//  收藏頁
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var viewModel: GlossaryViewModel
    @Binding var selectedTerm: Term?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("收藏")
                            .font(.editorialTitle(28))
                            .foregroundColor(AppTheme.primaryText)
                        Text("我的收藏")
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.secondaryText)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 14)

                    if viewModel.favoriteTerms.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "star")
                                .font(.system(size: 36))
                                .foregroundColor(AppTheme.mutedText)
                            Text("還沒有收藏的術語")
                                .font(.system(size: 14))
                                .foregroundColor(AppTheme.mutedText)
                            Text("在術語詳情頁點擊收藏按鈕")
                                .font(.system(size: 12))
                                .foregroundColor(AppTheme.mutedText)
                        }
                        .padding(.top, 60)
                    } else {
                        ForEach(viewModel.favoriteTerms) { term in
                            TermListItem(term: term) {
                                selectedTerm = term
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
