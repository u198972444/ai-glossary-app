//
//  QuizViewModel.swift
//  AIGlossaryApp
//
//  測驗模式視圖模型
//

import Foundation
import SwiftUI

final class QuizViewModel: ObservableObject {
    struct QuizQuestion: Identifiable {
        let id = UUID()
        let term: Term
        let options: [Term]
        let correctID: Int
    }

    @Published var questions: [QuizQuestion] = []
    @Published var currentIndex: Int = 0
    @Published var score: Int = 0
    @Published var selectedOptionID: Int?
    @Published var isFinished: Bool = false

    var currentQuestion: QuizQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    var progress: Double {
        guard !questions.isEmpty else { return 0 }
        // 修復：答完第10題時 currentIndex=9，之前顯示90%，現在顯示100%
        return Double(currentIndex + 1) / Double(questions.count)
    }

    func startQuiz(questionCount: Int = 10) {
        let allTerms = GlossaryData.shared.terms
        let shuffled = allTerms.shuffled()
        questions = shuffled.prefix(questionCount).map { term in
            // 修復：錯誤選項優先從同分類中選取，若同分類不足3個再從其他分類補充
            // 這樣可以避免考"Transformer"時錯誤選項是"Robotics"這種太容易排除的情況
            let sameCategory = allTerms.filter { $0.category == term.category && $0.id != term.id }
            var wrongs: [Term] = []
            if sameCategory.count >= 3 {
                wrongs = Array(sameCategory.shuffled().prefix(3))
            } else {
                wrongs = sameCategory.shuffled()
                let otherCategories = allTerms.filter { $0.category != term.category && $0.id != term.id }
                let needed = 3 - wrongs.count
                wrongs.append(contentsOf: otherCategories.shuffled().prefix(needed))
            }
            let options = ([term] + wrongs).shuffled()
            return QuizQuestion(term: term, options: options, correctID: term.id)
        }
        currentIndex = 0
        score = 0
        selectedOptionID = nil
        isFinished = false
    }

    func selectOption(_ optionID: Int) {
        guard selectedOptionID == nil, let question = currentQuestion else { return }
        selectedOptionID = optionID
        if optionID == question.correctID {
            score += 1
        }
    }

    func nextQuestion() {
        if currentIndex + 1 >= questions.count {
            isFinished = true
        } else {
            currentIndex += 1
            selectedOptionID = nil
        }
    }

    func isCorrect(_ optionID: Int) -> Bool {
        optionID == currentQuestion?.correctID
    }

    func isWrongSelection(_ optionID: Int) -> Bool {
        selectedOptionID == optionID && optionID != currentQuestion?.correctID
    }
}
