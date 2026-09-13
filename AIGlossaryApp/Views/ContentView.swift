//
//  ContentView.swift
//  AIGlossaryApp
//
//  主容器 — TabView + 全局 sheet
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var viewModel: GlossaryViewModel
    @State private var selectedTab = 0
    @State private var selectedTerm: Term?
    @State private var showPurchase = false

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTerm: $selectedTerm)
                .tabItem { Label("首頁", systemImage: "house") }
                .tag(0)

            CategoryView(selectedTerm: $selectedTerm)
                .tabItem { Label("分類", systemImage: "square.grid.2x2") }
                .tag(1)

            SearchView(selectedTerm: $selectedTerm)
                .tabItem { Label("搜尋", systemImage: "magnifyingglass") }
                .tag(2)

            FavoritesView(selectedTerm: $selectedTerm)
                .tabItem { Label("收藏", systemImage: "star") }
                .tag(3)

            MineView(showPurchase: $showPurchase)
                .tabItem { Label("我的", systemImage: "person") }
                .tag(4)
        }
        .tint(AppTheme.accent)
        .background(AppTheme.background.ignoresSafeArea())
        .sheet(item: $selectedTerm) { term in
            TermDetailSheet(term: term)
                .environmentObject(viewModel)
                .environmentObject(purchaseManager)
        }
        .sheet(isPresented: $showPurchase) {
            PurchaseView()
                .environmentObject(purchaseManager)
        }
        .onReceive(purchaseManager.$showTrialExpired) { show in
            if show { showPurchase = true }
        }
    }
}
