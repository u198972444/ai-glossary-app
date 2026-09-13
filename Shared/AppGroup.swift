//
//  AppGroup.swift
//  Shared
//
//  App Group 與 UserDefaults 共享配置
//

import Foundation

public enum AppGroup {
    /// App Group ID — 需在 Xcode Signing & Capabilities 中配置
    public static let groupID = "group.com.aiglossary.app"

    /// UserDefaults 共享實例
    public static var defaults: UserDefaults {
        UserDefaults(suiteName: groupID) ?? .standard
    }

    // MARK: - Keys

    public enum Key {
        public static let favorites = "aig_favorites"
        public static let learned = "aig_learned"
        public static let trialStartDate = "aig_trial_start"
        public static let isUnlocked = "aig_unlocked"
        public static let dailyUpdateHour = "aig_daily_hour"
    }

    // MARK: - Helpers

    public static var favorites: [Int] {
        get { defaults.array(forKey: Key.favorites) as? [Int] ?? [] }
        set { defaults.set(newValue, forKey: Key.favorites) }
    }

    public static var learned: [Int] {
        get { defaults.array(forKey: Key.learned) as? [Int] ?? [] }
        set { defaults.set(newValue, forKey: Key.learned) }
    }

    public static var isUnlocked: Bool {
        get { defaults.bool(forKey: Key.isUnlocked) }
        set { defaults.set(newValue, forKey: Key.isUnlocked) }
    }

    public static var trialStartDate: Date? {
        get { defaults.object(forKey: Key.trialStartDate) as? Date }
        set { defaults.set(newValue, forKey: Key.trialStartDate) }
    }

    /// 試用期總秒數（7 天）
    public static let trialDuration: TimeInterval = 7 * 24 * 60 * 60

    /// 試用期剩餘天數（按實際秒數計算，未開始試用返回 7）
    /// 修復：之前用日曆天計算，晚上安裝的用戶第二天就少一天
    public static var trialDaysRemaining: Int {
        guard let start = trialStartDate else { return 7 }
        let elapsed = Date().timeIntervalSince(start)
        let remaining = trialDuration - elapsed
        return max(0, Int(ceil(remaining / (24 * 60 * 60))))
    }

    /// 試用期剩餘小時數（用於更精確的顯示）
    public static var trialHoursRemaining: Int {
        guard let start = trialStartDate else { return 7 * 24 }
        let elapsed = Date().timeIntervalSince(start)
        let remaining = trialDuration - elapsed
        return max(0, Int(ceil(remaining / 3600)))
    }

    /// 試用是否仍有效
    public static var isTrialActive: Bool {
        if isUnlocked { return true }
        return trialDaysRemaining > 0
    }
}
