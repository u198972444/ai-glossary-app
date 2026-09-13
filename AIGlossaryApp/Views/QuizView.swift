//
//  QuizView.swift
//  AIGlossaryApp
//
//  測驗模式
//

import SwiftUI

struct QuizView: View {
    @EnvironmentObject var viewModel: GlossaryViewModel
    @StateObject private var quizVM = QuizViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppTheme.secondaryText)
                    }
                    Spacer()
                    Text("測驗")
                        .font(.editorialTitle(18))
                        .foregroundColor(AppTheme.primaryText)
                    Spacer()
                    Color.clear.frame(width: 20)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)

                if quizVM.questions.isEmpty {
                    startView
                } else if quizVM.isFinished {
                    resultView
                } else if let question = quizVM.currentQuestion {
                    questionView(question)
                }
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var startView: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "questionmark.circle")
                .font(.system(size: 48))
                .foregroundColor(AppTheme.accent)
            Text("AI 術語測驗")
                .font(.editorialTitle(24))
                .foregroundColor(AppTheme.primaryText)
            Text("隨機抽取 10 個術語\n驗證你的學習成果")
                .font(.system(size: 14))
                .foregroundColor(AppTheme.secondaryText)
                .multilineTextAlignment(.center)
            Button(action: { quizVM.startQuiz() }) {
                Text("開始測驗")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppTheme.accent)
            }
            .padding(.horizontal, 40)
            Spacer()
        }
    }

    private func questionView(_ question: QuizViewModel.QuizQuestion) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Progress
                HStack(spacing: 8) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .foregroundColor(AppTheme.border)
                                .frame(height: 3)
                            Rectangle()
                                .foregroundColor(AppTheme.accent)
                                .frame(width: geo.size.width * CGFloat(quizVM.progress), height: 3)
                        }
                    }
                    .frame(height: 3)
                    Text("\(quizVM.currentIndex + 1)/\(quizVM.questions.count)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(AppTheme.mutedText)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)

                // Question
                Text("「\(question.term.term)」的正確解釋是？")
                    .font(.editorialTitle(18))
                    .foregroundColor(AppTheme.primaryText)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 4)

                if !question.term.abbr.isEmpty {
                    Text("縮寫: \(question.term.abbr)")
                        .font(.system(size: 13))
                        .foregroundColor(AppTheme.mutedText)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)
                } else {
                    Color.clear.frame(height: 16)
                }

                // Options
                VStack(spacing: 0) {
                    ForEach(question.options) { option in
                        Button(action: { quizVM.selectOption(option.id) }) {
                            HStack {
                                Text(option.definition)
                                    .font(.system(size: 13))
                                    .foregroundColor(optionColor(option.id))
                                    .lineLimit(3)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(optionBackground(option.id))
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(quizVM.selectedOptionID != nil)
                        .overlay(
                            Rectangle().frame(height: 1).foregroundColor(AppTheme.borderLight),
                            alignment: .bottom
                        )
                    }
                }
                .background(AppTheme.cardBackground)
                .overlay(Rectangle().stroke(AppTheme.border, lineWidth: 1))
                .padding(.horizontal, 16)

                // Next Button
                if quizVM.selectedOptionID != nil {
                    Button(action: { quizVM.nextQuestion() }) {
                        Text(quizVM.currentIndex + 1 >= quizVM.questions.count ? "查看結果" : "下一題")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(AppTheme.accent)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
            .padding(.bottom, 20)
        }
    }

    private func optionColor(_ id: Int) -> Color {
        guard quizVM.selectedOptionID != nil else { return AppTheme.secondaryText }
        if quizVM.isCorrect(id) { return AppTheme.primaryText }
        if quizVM.isWrongSelection(id) { return AppTheme.mutedText }
        return AppTheme.mutedText
    }

    private func optionBackground(_ id: Int) -> Color {
        guard quizVM.selectedOptionID != nil else { return .clear }
        if quizVM.isCorrect(id) { return AppTheme.accentLight.opacity(0.3) }
        return .clear
    }

    private var resultView: some View {
        VStack(spacing: 16) {
            Spacer()
            Text("\(quizVM.score)/\(quizVM.questions.count)")
                .font(.editorialTitle(48))
                .foregroundColor(AppTheme.accent)
            Text("正確率 \(Int(Double(quizVM.score) / Double(quizVM.questions.count) * 100))%")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppTheme.mutedText)
            Button(action: { quizVM.startQuiz() }) {
                Text("再測一次")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AppTheme.accent)
            }
            .padding(.horizontal, 40)
            Button(action: { dismiss() }) {
                Text("關閉")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.secondaryText)
            }
            Spacer()
        }
    }
}
