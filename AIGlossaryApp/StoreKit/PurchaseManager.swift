//
//  PurchaseManager.swift
//  AIGlossaryApp
//
//  StoreKit 2 內購管理 — NT$220 買斷 + 7 天試用邏輯
//

import Foundation
import StoreKit

final class PurchaseManager: ObservableObject {
    // 內購產品 ID — 需在 App Store Connect 中配置為 Non-Consumable
    static let productID = "com.aiglossary.fullunlock"

    @Published var isUnlocked = false
    @Published var isLoading = false
    @Published var showTrialExpired = false
    @Published var product: Product?
    @Published var errorMessage: String?

    private var updates: Task<Void, Never>?

    // MARK: - Trial Logic

    /// 試用開始日期（首次啟動 App 時設定）
    var trialStartDate: Date? {
        AppGroup.trialStartDate
    }

    /// 試用剩餘天數
    var trialDaysRemaining: Int {
        AppGroup.trialDaysRemaining
    }

    /// 試用是否仍有效（或已買斷）
    var isTrialActive: Bool {
        AppGroup.isTrialActive
    }

    // MARK: - Init

    init() {
        // 首次啟動：設定試用開始日期
        if AppGroup.trialStartDate == nil {
            AppGroup.trialStartDate = Date()
        }

        // 載入已解鎖狀態
        isUnlocked = AppGroup.isUnlocked

        // 監聽交易更新
        updates = observeTransactionUpdates()

        // 載入產品資訊
        Task { await loadProduct() }

        // 檢查試用是否過期
        checkTrialStatus()
    }

    deinit {
        updates?.cancel()
    }

    // MARK: - Product Loading

    func loadProduct() async {
        do {
            let products = try await Product.products(for: [Self.productID])
            product = products.first
        } catch {
            errorMessage = "載入產品資訊失敗：\(error.localizedDescription)"
        }
    }

    // MARK: - Purchase

    func purchase() async {
        guard let product = product else {
            errorMessage = "產品資訊尚未載入，請稍後重試"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                // 驗證交易
                if case .verified(let transaction) = verification {
                    await transaction.finish()
                    isUnlocked = true
                    AppGroup.isUnlocked = true
                    showTrialExpired = false
                }
            case .userCancelled:
                break
            case .pending:
                errorMessage = "交易待處理中"
            @unknown default:
                break
            }
        } catch {
            errorMessage = "購買失敗：\(error.localizedDescription)"
        }

        isLoading = false
    }

    // MARK: - Restore

    func restorePurchase() async {
        isLoading = true
        errorMessage = nil

        do {
            try await AppStore.sync()

            // 檢查是否有已購買的交易
            for await result in Transaction.currentEntitlements {
                if case .verified(let transaction) = result {
                    if transaction.productID == Self.productID {
                        isUnlocked = true
                        AppGroup.isUnlocked = true
                        showTrialExpired = false
                        break
                    }
                }
            }

            if !isUnlocked {
                errorMessage = "未找到已購買記錄"
            }
        } catch {
            errorMessage = "恢復購買失敗：\(error.localizedDescription)"
        }

        isLoading = false
    }

    // MARK: - Trial Check

    func checkTrialStatus() {
        guard !isUnlocked else { return }

        if trialDaysRemaining <= 0 {
            // 試用已過期，顯示購買頁（延遲一點讓 UI 先載入）
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.showTrialExpired = true
            }
        }
    }

    // MARK: - Transaction Observer

    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await verification in Transaction.updates {
                if case .verified(let transaction) = verification {
                    await transaction.finish()
                    if transaction.productID == Self.productID {
                        await MainActor.run {
                            self?.isUnlocked = true
                            AppGroup.isUnlocked = true
                            self?.showTrialExpired = false
                        }
                    }
                }
            }
        }
    }
}
