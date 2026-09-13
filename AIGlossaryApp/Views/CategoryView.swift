//
//  CategoryView.swift
//  AIGlossaryApp
//
//  分類頁 — 17 個分類網格
//

import SwiftUI

struct CategoryView: View {
    @Binding var selectedTerm: Term?
    @State private var selectedCategory: GlossaryCategory?

    private var categoryCounts: [(GlossaryCategory, Int)] {
        GlossaryCategory.allCases.compactMap { cat in
            let count = GlossaryData.shared.terms(forCategory: cat.rawValue).count
            return count > 0 ? (cat, count) : nil
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("分類")
                            .font(.editorialTitle(28))
                            .foregroundColor(AppTheme.primaryText)
                        Text("17 個分類，從基礎到前沿")
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.secondaryText)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 14)

                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10)
                    ], spacing: 10) {
                        ForEach(categoryCounts, id: \.0) { cat, count in
                            CategoryCard(category: cat, count: count) {
                                selectedCategory = cat
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 20)
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
            .background(
                NavigationLink(
                    destination: CategoryDetailView(
                        category: selectedCategory ?? .foundations,
                        selectedTerm: $selectedTerm
                    ),
                    isActive: Binding(
                        get: { selectedCategory != nil },
                        set: { if !$0 { selectedCategory = nil } }
                    )
                ) { EmptyView() }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
