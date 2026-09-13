//
//  CategoryDetailView.swift
//  AIGlossaryApp
//
//  分類詳情頁 — 該分類下的術語列表
//

import SwiftUI

struct CategoryDetailView: View {
    let category: GlossaryCategory
    @Binding var selectedTerm: Term?
    @Environment(\.dismiss) private var dismiss

    private var terms: [Term] {
        GlossaryData.shared.terms(forCategory: category.rawValue)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 10) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(AppTheme.accent)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(category.displayName)
                            .font(.editorialTitle(20))
                            .foregroundColor(AppTheme.primaryText)
                        Text("\(terms.count) 個術語")
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.secondaryText)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 14)

                ForEach(terms) { term in
                    TermListItem(term: term) {
                        selectedTerm = term
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.bottom, 20)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}
