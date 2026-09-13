//
//  TermListItem.swift
//  AIGlossaryApp
//
//  術語列表項（雜誌列表風格，無圓角卡片）
//

import SwiftUI

struct TermListItem: View {
    let term: Term
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .top) {
                    Text(term.term)
                        .font(.editorialTitle(16))
                        .foregroundColor(AppTheme.primaryText)
                    Spacer()
                    if let cat = GlossaryCategory(rawValue: term.category) {
                        Text(cat.displayName)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(AppTheme.secondaryText)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 2)
                            .overlay(
                                Rectangle()
                                    .stroke(AppTheme.secondaryText.opacity(0.4), lineWidth: 1)
                            )
                    }
                }
                Text(term.definition)
                    .font(.editorialBody(13))
                    .foregroundColor(AppTheme.secondaryText)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(AppTheme.borderLight),
            alignment: .bottom
        )
    }
}
