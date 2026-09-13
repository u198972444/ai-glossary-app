//
//  CategoryCard.swift
//  AIGlossaryApp
//
//  分類卡片
//

import SwiftUI

struct CategoryCard: View {
    let category: GlossaryCategory
    let count: Int
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 6) {
                Image(systemName: category.icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppTheme.primaryText)
                Text(category.displayName)
                    .font(.editorialTitle(14))
                    .foregroundColor(AppTheme.primaryText)
                Text("\(count) 個術語")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppTheme.mutedText)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.cardBackground)
            .overlay(
                Rectangle()
                    .stroke(AppTheme.border, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
