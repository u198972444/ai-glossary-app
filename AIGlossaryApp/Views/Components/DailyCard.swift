//
//  DailyCard.swift
//  AIGlossaryApp
//
//  每日一詞大卡片
//

import SwiftUI

struct DailyCard: View {
    let term: Term
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                Text("今日推薦")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(AppTheme.accent)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(AppTheme.accentLight.opacity(0.5))
                    .cornerRadius(4)
                    .padding(.bottom, 14)

                Text(term.term)
                    .font(.editorialTitle(26))
                    .foregroundColor(AppTheme.primaryText)
                    .padding(.bottom, 4)

                if !term.abbr.isEmpty {
                    Text("(\(term.abbr))")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.accent)
                        .padding(.bottom, 12)
                }

                Text(term.definition)
                    .font(.editorialBody(14))
                    .foregroundColor(AppTheme.secondaryText)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)

                Spacer(minLength: 12)

                HStack {
                    Text("點擊查看完整解釋")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppTheme.mutedText)
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(AppTheme.mutedText)
                }
                .padding(.top, 12)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(AppTheme.borderLight),
                    alignment: .top
                )
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.cardBackground)
            .cornerRadius(0)
            .overlay(
                Rectangle()
                    .stroke(AppTheme.border, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
