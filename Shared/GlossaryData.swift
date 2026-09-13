//
//  GlossaryData.swift
//  Shared
//
//  術語數據加載與查詢 — App 與 Widget 共用
//

import Foundation

public final class GlossaryData {
    public static let shared = GlossaryData()

    public private(set) var terms: [Term] = []

    private init() {
        load()
    }

    public func load() {
        guard let url = Bundle.main.url(forResource: "glossary", withExtension: "json"),
              let data = try? Data(contentsOf: url)
        else {
            // Fallback: try shared bundle
            if let sharedURL = Bundle(for: GlossaryData.self).url(forResource: "glossary", withExtension: "json"),
               let sharedData = try? Data(contentsOf: sharedURL) {
                parse(sharedData)
            }
            return
        }
        parse(data)
    }

    private func parse(_ data: Data) {
        struct GlossaryResponse: Codable {
            let terms: [Term]
        }
        if let decoded = try? JSONDecoder().decode(GlossaryResponse.self, from: data) {
            terms = decoded.terms
        }
    }

    // MARK: - Queries

    public func term(withID id: Int) -> Term? {
        terms.first { $0.id == id }
    }

    public func terms(forCategory category: String) -> [Term] {
        terms.filter { $0.category == category }
    }

    public func search(_ query: String) -> [Term] {
        let q = query.lowercased().trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else { return [] }
        
        let matches = terms.filter { term in
            term.term.lowercased().contains(q) ||
            term.abbr.lowercased().contains(q) ||
            term.definition.lowercased().contains(q) ||
            term.example.lowercased().contains(q)
        }
        
        // 修復：搜索結果排序，術語名精確匹配 > 術語名包含 > 縮寫匹配 > 定義/實例包含
        return matches.sorted { a, b in
            let scoreA = searchScore(a, query: q)
            let scoreB = searchScore(b, query: q)
            if scoreA != scoreB {
                return scoreA > scoreB
            }
            // 同分時按 ID 排序
            return a.id < b.id
        }
    }

    /// 計算搜索匹配分數（越高越相關）
    private func searchScore(_ term: Term, query: String) -> Int {
        var score = 0
        let termLower = term.term.lowercased()
        let abbrLower = term.abbr.lowercased()

        // 術語名精確匹配（最高分）
        if termLower == query {
            score += 100
        }
        // 縮寫精確匹配
        else if abbrLower == query && !abbrLower.isEmpty {
            score += 90
        }
        // 術語名以查詢開頭
        if termLower.hasPrefix(query) {
            score += 50
        }
        // 術語名包含查詢
        if termLower.contains(query) {
            score += 30
        }
        // 縮寫包含查詢
        if abbrLower.contains(query) && !abbrLower.isEmpty {
            score += 20
        }
        // 定義包含查詢（最低分）
        if term.definition.lowercased().contains(query) {
            score += 5
        }
        return score
    }

    public func dailyTerm(for date: Date = Date()) -> Term {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let index = (dayOfYear - 1) % max(terms.count, 1)
        return terms.indices.contains(index) ? terms[index] : terms.first ?? Term(
            id: 0, term: "Artificial Intelligence", abbr: "AI", category: "foundations",
            definition: "人工智慧。", example: "", related: [])
    }

    public func randomTerms(count: Int) -> [Term] {
        Array(terms.shuffled().prefix(count))
    }

    public func categoryCounts() -> [(String, Int)] {
        GlossaryCategory.allCases.compactMap { cat in
            let count = terms.filter { $0.category == cat.rawValue }.count
            return count > 0 ? (cat.rawValue, count) : nil
        }
    }
}
