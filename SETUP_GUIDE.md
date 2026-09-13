# Xcode 項目配置指南

本指南說明如何在 Xcode 中從零創建項目、配置 Target、App Group、StoreKit 內購，並成功編譯運行。

---

## 前置要求

- macOS 14.0+（Sonoma）
- Xcode 15.0+
- Apple Developer 帳號（個人或公司）
- 實體 iPhone（iOS 17+，用於測試 Widget）

---

## 方式一：使用 XcodeGen（推薦，5 分鐘完成）

### 1. 安裝 XcodeGen

```bash
brew install xcodegen
```

### 2. 生成項目

```bash
cd AIGlossaryApp
xcodegen generate
```

這會自動生成 `AIGlossaryApp.xcodeproj`，包含兩個 Target：
- `AIGlossaryApp`（主 App）
- `AIGlossaryWidget`（Widget Extension）

### 3. 配置開發團隊

1. 打開 `AIGlossaryApp.xcodeproj`
2. 選擇左側項目導航器中的 `AIGlossaryApp` 項目
3. 選擇 `AIGlossaryApp` Target → `Signing & Capabilities`
4. 在 `Team` 下拉菜單選擇你的 Apple Developer 團隊
5. 同樣為 `AIGlossaryWidget` Target 配置 Team

### 4. 驗證 App Group

1. 在 `AIGlossaryApp` Target → `Signing & Capabilities` 中，確認已添加 `App Groups` 能力
2. 確認 App Group ID 為 `group.com.aiglossary.app`
3. 在 `AIGlossaryWidget` Target 中同樣確認 App Group 已配置且 ID 一致

### 5. 編譯運行

1. 選擇頂部方案為 `AIGlossaryApp`
2. 選擇模擬器或實體 iPhone
3. 按 `⌘R` 編譯運行

---

## 方式二：手動創建 Xcode 項目（30 分鐘）

如果不想使用 XcodeGen，可以手動創建項目。

### 步驟 1：創建主 App 項目

1. 打開 Xcode → `File` → `New` → `Project...`
2. 選擇 `iOS` → `App`
3. 填寫：
   - Product Name: `AIGlossaryApp`
   - Team: 選擇你的開發團隊
   - Organization Identifier: `com.aiglossary`
   - Interface: `SwiftUI`
   - Language: `Swift`
   - 取消勾選 `Use Core Data`、`Include Tests`
4. 選擇保存位置，創建項目

### 步驟 2：添加共享代碼

1. 在項目導航器右鍵點擊項目根目錄 → `New Group`
2. 命名為 `Shared`
3. 將 `Shared/` 目錄下的三個文件（`Term.swift`、`GlossaryData.swift`、`AppGroup.swift`）拖入 `Shared` 組
4. 在彈出的對話框中，確保 `AIGlossaryApp` Target 被勾選

### 步驟 3：添加主 App 源代碼

1. 將 `AIGlossaryApp/` 目錄下的所有文件和文件夾拖入 Xcode 項目的 `AIGlossaryApp` 組中
2. 確保以下文件的 Target Membership 包含 `AIGlossaryApp`：
   - `AIGlossaryApp.swift`
   - `Models/Theme.swift`
   - `Views/` 下所有 Swift 文件
   - `ViewModels/` 下所有 Swift 文件
   - `StoreKit/PurchaseManager.swift`
   - `Data/glossary.json`（確保在 `Copy Bundle Resources` 中）
   - `Assets.xcassets/`
3. 刪除 Xcode 自動生成的 `ContentView.swift`（如果存在）

### 步驟 4：添加 Widget Extension

1. `File` → `New` → `Target...`
2. 選擇 `iOS` → `Widget Extension`
3. Product Name: `AIGlossaryWidget`
4. 取消勾選 `Include Configuration App Intent`
5. 點擊 `Finish`，在彈出的對話框中點擊 `Activate`

### 步驟 5：配置 Widget 源代碼

1. 刪除 Xcode 自動生成的 `AIGlossaryWidget.swift`（或覆蓋它）
2. 將 `AIGlossaryWidget/` 目錄下的所有文件拖入 Xcode 的 `AIGlossaryWidget` 組
3. 確保 `Shared/` 組中的三個 Swift 文件的 Target Membership **同時包含** `AIGlossaryWidget`
4. 確保 `AIGlossaryWidget/Info.plist` 的 `NSExtensionPointIdentifier` 為 `com.apple.widgetkit-extension`

### 步驟 6：配置 App Group

1. 選擇 `AIGlossaryApp` Target → `Signing & Capabilities`
2. 點擊 `+ Capability` → 搜索 `App Groups` → 添加
3. 點擊 `+` 添加 App Group ID：`group.com.aiglossary.app`
4. 同樣為 `AIGlossaryWidget` Target 添加相同的 App Group

### 步驟 7：配置 Entitlements

1. 為 `AIGlossaryApp` Target 創建 `AIGlossaryApp.entitlements` 文件
2. 內容：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.application-groups</key>
    <array>
        <string>group.com.aiglossary.app</string>
    </array>
</dict>
</plist>
```
3. 在 Target → `Build Settings` → `Code Signing Entitlements` 中設置為 `AIGlossaryApp/AIGlossaryApp.entitlements`
4. 同樣為 Widget Target 配置 entitlements

### 步驟 8：配置 Info.plist

確保 `AIGlossaryApp/Info.plist` 包含：
- `CFBundleDisplayName`: `AI 單詞`
- `UIUserInterfaceStyle`: `Light`
- 最低部署目標：iOS 17.0

### 步驟 9：配置 StoreKit 內購（本地測試）

1. `File` → `New` → `File...` → 搜索 `StoreKit Configuration File`
2. 命名為 `AIGlossary.storekit`
3. 在文件中右鍵 → `New Product` → `Non-Consumable`
4. 填寫：
   - Reference Name: `完整解鎖`
   - Product ID: `com.aiglossary.fullunlock`
   - Price: `$6.99`（對應 NT$220）
   - Display Name: `完整解鎖 — 全部 AI 術語終身使用`
   - Description: `一次買斷，解鎖全部 354 個術語和所有未來更新，零廣告。`
5. 在 `AIGlossaryApp` Target → `Edit Scheme` → `Run` → `Options` → `StoreKit Configuration` 選擇 `AIGlossary.storekit`
6. 這樣在模擬器中可以測試內購流程，不需要真實的 App Store Connect 配置

### 步驟 10：編譯運行

1. 選擇方案 `AIGlossaryApp`
2. 選擇 iPhone 模擬器（建議 iPhone 15 Pro）
3. 按 `⌘R` 編譯運行
4. 測試 Widget：在模擬器主屏幕長按 → 添加 Widget → 搜索 `AI 單詞`

---

## 常見問題

### Q: 編譯報錯 `Cannot find 'GlossaryData' in scope`

A: 確保 `Shared/GlossaryData.swift` 的 Target Membership 同時包含 App 和 Widget Target。點擊文件 → 右側 File Inspector → 勾選 Target Membership。

### Q: Widget 不顯示數據

A: 確保：
1. App Group ID 在兩個 Target 的 entitlements 中一致
2. `glossary.json` 在 App Target 的 `Copy Bundle Resources` 中
3. Widget 的 `GlossaryData.shared.load()` 能正確讀取 JSON

### Q: 內購按鈕點擊無反應

A: 確保已配置 StoreKit Configuration File，並在 Scheme 中選擇了它。或者在真實設備上測試（需要 App Store Connect 中配置內購產品）。

### Q: 試用期邏輯如何重置

A: 刪除 App 重新安裝，或在設置中清除 App 數據。試用開始日期存儲在 App Group UserDefaults 中。

### Q: 如何修改配色

A: 編輯 `AIGlossaryApp/Models/Theme.swift`，修改 `AppTheme` 枚舉中的顏色值。Widget 的顏色在 `AIGlossaryWidget/Views/WidgetViews.swift` 中硬編碼，需要同步修改。

---

## 下一步

項目成功編譯運行後，參考 [APP_STORE_CHECKLIST.md](APP_STORE_CHECKLIST.md) 進行 App Store 上架準備。
