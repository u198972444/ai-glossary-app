//
//  TermDetailSheet.swift
//  AIGlossaryApp
//
//  術語詳情彈窗（Sheet）
//

import SwiftUI

struct TermDetailSheet: View {
    let term: Term
    @EnvironmentObject var viewModel: GlossaryViewModel
    @EnvironmentObject var purchaseManager: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Handle
                    RoundedRectangle(cornerRadius: 2)
                        .fill(AppTheme.border)
                        .frame(width: 36, height: 4)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                        .padding(.bottom, 8)

                    // Header
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(term.term)
                                .font(.editorialTitle(24))
                                .foregroundColor(AppTheme.primaryText)
                            HStack(spacing: 8) {
                                if !term.abbr.isEmpty {
                                    Text("(\(term.abbr))")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(AppTheme.accent)
                                }
                                if let cat = GlossaryCategory(rawValue: term.category) {
                                    Text(cat.displayName)
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(AppTheme.secondaryText)
                                        .padding(.horizontal, 7)
                                        .padding(.vertical, 2)
                                        .overlay(Rectangle().stroke(AppTheme.secondaryText.opacity(0.4), lineWidth: 1))
                                }
                            }
                        }
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(AppTheme.secondaryText)
                                .frame(width: 28, height: 28)
                                .background(AppTheme.cardBackground)
                                .overlay(Rectangle().stroke(AppTheme.border, lineWidth: 1))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 14)
                    .overlay(
                        Rectangle().frame(height: 1).foregroundColor(AppTheme.borderLight),
                        alignment: .bottom
                    )

                    // Definition
                    VStack(alignment: .leading, spacing: 8) {
                        Text("繁體中文解釋")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(AppTheme.mutedText)
                        Text(term.definition)
                            .font(.editorialBody(14))
                            .foregroundColor(AppTheme.secondaryText)
                            .lineSpacing(4)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)

                    // Example
                    VStack(alignment: .leading, spacing: 8) {
                        Text("實例")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(AppTheme.mutedText)
                        Text(term.example)
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.primaryText)
                            .lineSpacing(3)
                            .padding(12)
                            .background(AppTheme.accentLight.opacity(0.3))
                            .overlay(
                                Rectangle().fill(AppTheme.accent).frame(width: 3),
                                alignment: .leading
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)

                    // Related Terms
                    if !term.related.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("相關術語")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(AppTheme.mutedText)
                            WrapHStack(items: term.related) { related in
                                // 增強匹配：先精確匹配 term 名，再匹配縮寫，再模糊匹配
                                if let relatedTerm = findRelatedTerm(related) {
                                    Button(action: {
                                        dismiss()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            NotificationCenter.default.post(
                                                name: .showTerm, object: relatedTerm
                                            )
                                        }
                                    }) {
                                        Text(related)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(AppTheme.secondaryText)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 5)
                                            .background(AppTheme.cardBackground)
                                            .overlay(Rectangle().stroke(AppTheme.border, lineWidth: 1))
                                    }
                                } else {
                                    Text(related)
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(AppTheme.mutedText)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 5)
                                        .background(AppTheme.cardBackground)
                                        .overlay(Rectangle().stroke(AppTheme.border, lineWidth: 1))
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)
                    }

                    // Actions
                    HStack(spacing: 10) {
                        Button(action: { viewModel.toggleFavorite(term) }) {
                            HStack(spacing: 4) {
                                Image(systemName: viewModel.isFavorite(term) ? "star.fill" : "star")
                                    .font(.system(size: 14))
                                Text(viewModel.isFavorite(term) ? "已收藏" : "收藏")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(viewModel.isFavorite(term) ? AppTheme.accent : AppTheme.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(viewModel.isFavorite(term) ? AppTheme.accentLight.opacity(0.3) : AppTheme.cardBackground)
                            .overlay(Rectangle().stroke(viewModel.isFavorite(term) ? AppTheme.accent : AppTheme.border, lineWidth: 1))
                        }

                        Button(action: {
                            viewModel.markLearned(term)
                            dismiss()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                Text("標記已學習")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(AppTheme.accent)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// Helper: WrapHStack for tag layout
struct WrapHStack<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    let items: Data
    @ViewBuilder let content: (Data.Element) -> Content

    var body: some View {
        FlexibleView(data: items, spacing: 6, alignment: .leading) { item in
            content(item)
        }
    }
}

struct FlexibleView<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    @ViewBuilder let content: (Data.Element) -> Content

    @State private var totalHeight = CGFloat.zero

    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(Array(data), id: \.self) { item in
                content(item)
                    .padding(.trailing, spacing)
                    .padding(.bottom, spacing)
                    .alignmentGuide(.leading, computeValue: { dimension in
                        if abs(width - dimension.width) > geometry.size.width {
                            width = 0
                            height -= dimension.height
                        }
                        let result = width
                        if item == data.last {
                            width = 0
                        } else {
                            width -= dimension.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if item == data.last {
                            height = 0
                        }
                        return result
                    })
            }
        }
        .background(viewHeightReader($totalHeight))
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geometry -> Color in
            DispatchQueue.main.async {
                binding.wrappedValue = geometry.size.height
            }
            return Color.clear
        }
    }
}

// MARK: - Related Term Matching Helper

/// 查找相關術語：精確匹配 term 名 → 精確匹配縮寫 → 包含匹配
func findRelatedTerm(_ name: String) -> Term? {
    let lower = name.lowercased()
    let allTerms = GlossaryData.shared.terms

    // 1. 精確匹配 term 名
    if let exact = allTerms.first(where: { $0.term.lowercased() == lower }) {
        return exact
    }
    // 2. 精確匹配縮寫
    if let abbrMatch = allTerms.first(where: { $0.abbr.lowercased() == lower && !$0.abbr.isEmpty }) {
        return abbrMatch
    }
    // 3. term 名包含匹配（name 是 term 的子串）
    if let containsMatch = allTerms.first(where: { $0.term.lowercased().contains(lower) }) {
        return containsMatch
    }
    return nil
}

extension Notification.Name {
    static let showTerm = Notification.Name("showTerm")
}
