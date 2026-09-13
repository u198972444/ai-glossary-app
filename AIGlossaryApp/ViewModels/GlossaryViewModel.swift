//
//  GlossaryViewModel.swift
//  AIGlossaryApp
//
//  術語視圖模型 — 管理收藏、已學習、搜尋
//

import Foundation
import Combine

final class GlossaryViewModel: ObservableObject {
    @Published var favorites: [Int] = []
    @Published var learned: [Int] = []
    @Published var searchQuery: String = ""
    @Published var searchResults: [Term] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        loadFromAppGroup()

        $searchQuery
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.searchResults = GlossaryData.shared.search(query)
            }
            .store(in: &cancellables)
    }

    // MARK: - Persistence

    private func loadFromAppGroup() {
        favorites = AppGroup.favorites
        learned = AppGroup.learned
    }

    private func save() {
        AppGroup.favorites = favorites
        AppGroup.learned = learned
    }

    // MARK: - Favorites

    func isFavorite(_ term: Term) -> Bool {
        favorites.contains(term.id)
    }

    func toggleFavorite(_ term: Term) {
        if let index = favorites.firstIndex(of: term.id) {
            favorites.remove(at: index)
        } else {
            favorites.append(term.id)
        }
        save()
    }

    var favoriteTerms: [Term] {
        favorites.compactMap { GlossaryData.shared.term(withID: $0) }
    }

    // MARK: - Learned

    func isLearned(_ term: Term) -> Bool {
        learned.contains(term.id)
    }

    func markLearned(_ term: Term) {
        if !learned.contains(term.id) {
            learned.append(term.id)
            save()
        }
    }

    // MARK: - Daily

    var dailyTerm: Term {
        GlossaryData.shared.dailyTerm()
    }

    // MARK: - Browse

    func browseTerms(after term: Term, count: Int = 8) -> [Term] {
        let terms = GlossaryData.shared.terms
        guard let startIndex = terms.firstIndex(where: { $0.id == term.id }) else {
            return Array(terms.prefix(count))
        }
        var result: [Term] = []
        for i in 1...count {
            let index = (startIndex + i) % terms.count
            result.append(terms[index])
        }
        return result
    }
}
