//
//  AIGlossaryApp.swift
//  AIGlossaryApp
//
//  App 入口
//

import SwiftUI

@main
struct AIGlossaryApp: App {
    @StateObject private var purchaseManager = PurchaseManager()
    @StateObject private var viewModel = GlossaryViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(purchaseManager)
                .environmentObject(viewModel)
                .preferredColorScheme(.light)
                .onAppear {
                    GlossaryData.shared.load()
                }
        }
    }
}
