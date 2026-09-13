//
//  SearchView.swift
//  AIGlossaryApp
//
//  搜尋頁
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: GlossaryViewModel
    @Binding var selectedTerm: Term?

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("搜尋")
                        .font(.editorialTitle(28))
                        .foregroundColor(AppTheme.primaryText)
                    Text("\(GlossaryData.shared.terms.count) 個術語")
                        .font(.system(size: 13))
                        .foregroundColor(AppTheme.secondaryText)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 14)

                // Search Box
                HStack {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 15))
                        .foregroundColor(AppTheme.mutedText)
                    TextField("輸入英文、縮寫或中文關鍵字", text: $viewModel.searchQuery)
                        .font(.system(size: 15))
                        .foregroundColor(AppTheme.primaryText)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(AppTheme.cardBackground)
                .overlay(
                    Rectangle().stroke(AppTheme.border, lineWidth: 1)
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 14)

                // Results
                ScrollView {
                    LazyVStack(spacing: 0) {
                        if viewModel.searchQuery.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 36))
                                    .foregroundColor(AppTheme.mutedText)
                                Text("輸入關鍵字開始搜尋")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppTheme.mutedText)
                            }
                            .padding(.top, 60)
                        } else if viewModel.searchResults.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "exclamationmark.circle")
                                    .font(.system(size: 36))
                                    .foregroundColor(AppTheme.mutedText)
                                Text("找不到符合「\(viewModel.searchQuery)」的術語")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppTheme.mutedText)
                            }
                            .padding(.top, 60)
                        } else {
                            Text("找到 \(viewModel.searchResults.count) 個結果")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(AppTheme.mutedText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 8)

                            ForEach(viewModel.searchResults) { term in
                                TermListItem(term: term) {
                                    selectedTerm = term
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
