# AI 單詞 — AI 術語鎖屏學習 App

> 每天解鎖手機，學一個 AI 專有名詞。

面向台灣市場的 iOS App，利用 iPhone 鎖屏和桌面 Widget，每天顯示一個 AI 專有名詞（含繁體中文解釋與實例）。純本地運行，零伺服器成本，NT$220 一次買斷含所有未來更新。

## 功能特性

- **每日一詞**：根據日期自動切換，每天學一個新術語
- **鎖屏 Widget**：在鎖屏直接查看今日術語（支援 accessoryRectangular / Inline / Circular）
- **桌面 Widget**：三種尺寸（小 / 中 / 大），可放在主屏幕
- **354 個專業術語**：覆蓋 17 個分類，從基礎到前沿
- **卡片式瀏覽**：上下滑動瀏覽所有術語
- **分類搜尋**：17 個分類 + 關鍵字即時搜尋
- **收藏與學習進度**：收藏重要術語，標記已學習
- **測驗模式**：10 題隨機測驗，驗證學習成果
- **7 天免費試用**：首次啟動自動開始，期滿 NT$220 買斷
- **零廣告**：純淨學習體驗
- **純本地運行**：不需要伺服器、不需要帳號、零維護成本

## 技術架構

| 層級 | 技術 |
|------|------|
| 開發語言 | Swift 5.9 |
| UI 框架 | SwiftUI（iOS 17+） |
| Widget | WidgetKit |
| 內購 | StoreKit 2 |
| 數據存儲 | JSON 內置 + App Group UserDefaults |
| 最低系統 | iOS 17.0 |

## 項目結構

```
AIGlossaryApp/
├── Shared/                          # App 與 Widget 共用代碼
│   ├── Term.swift                   # 術語數據模型
│   ├── GlossaryData.swift           # 數據加載與查詢
│   └── AppGroup.swift               # App Group 與 UserDefaults 共享
├── AIGlossaryApp/                   # 主 App Target
│   ├── AIGlossaryApp.swift          # App 入口
│   ├── Models/
│   │   └── Theme.swift              # 配色主題（暖米白底 + 霧霾藍字）
│   ├── Views/
│   │   ├── ContentView.swift        # 主容器（TabView）
│   │   ├── HomeView.swift           # 首頁（每日一詞）
│   │   ├── CategoryView.swift       # 分類頁
│   │   ├── CategoryDetailView.swift # 分類詳情
│   │   ├── SearchView.swift         # 搜尋頁
│   │   ├── FavoritesView.swift      # 收藏頁
│   │   ├── MineView.swift           # 我的頁
│   │   ├── QuizView.swift           # 測驗模式
│   │   ├── WidgetPreviewView.swift  # Widget 預覽
│   │   ├── PurchaseView.swift       # 購買頁
│   │   ├── TermDetailSheet.swift    # 術語詳情彈窗
│   │   └── Components/
│   │       ├── DailyCard.swift      # 每日一詞大卡片
│   │       ├── TermListItem.swift   # 術語列表項
│   │       └── CategoryCard.swift   # 分類卡片
│   ├── ViewModels/
│   │   ├── GlossaryViewModel.swift  # 術語視圖模型
│   │   └── QuizViewModel.swift      # 測驗視圖模型
│   ├── StoreKit/
│   │   └── PurchaseManager.swift    # StoreKit 2 內購管理
│   ├── Data/
│   │   └── glossary.json            # 354 個術語數據
│   ├── Assets.xcassets/             # 資源（App Icon、AccentColor）
│   ├── Info.plist
│   └── AIGlossaryApp.entitlements   # App Group 配置
├── AIGlossaryWidget/                # Widget Extension Target
│   ├── AIGlossaryWidget.swift       # Widget 入口（桌面+鎖屏）
│   ├── WidgetProvider.swift         # Timeline Provider
│   ├── Views/
│   │   └── WidgetViews.swift        # 三種尺寸 Widget 視圖
│   ├── Assets.xcassets/
│   ├── Info.plist
│   └── AIGlossaryWidget.entitlements
├── project.yml                      # XcodeGen 項目配置（備選）
├── SETUP_GUIDE.md                   # Xcode 項目配置詳細指南
├── APP_STORE_CHECKLIST.md           # App Store 上架檢查清單
└── README.md
```

## 快速開始

### 方式一：使用 XcodeGen（推薦）

```bash
# 1. 安裝 XcodeGen
brew install xcodegen

# 2. 在項目目錄生成 Xcode 項目
cd AIGlossaryApp
xcodegen generate

# 3. 打開項目
open AIGlossaryApp.xcodeproj
```

### 方式二：手動創建 Xcode 項目

詳見 [SETUP_GUIDE.md](SETUP_GUIDE.md)。

## 定價與變現

| 項目 | 內容 |
|------|------|
| 定價模式 | 一次買斷（Non-Consumable IAP） |
| 價格 | NT$220（US$6.99 等級，Tier 7） |
| 試用 | 7 天免費完整試用（App 內計時，非 Apple 官方試用） |
| 廣告 | 無廣告 |
| 包含 | 全部 354 個術語 + 所有未來 AI 新技術更新 |

## 配色主題

暖米白底（#F0EBE3）+ 霧霾藍字（#2C4A6B）+ 深藍強調（#1B3A5C），編輯雜誌風格，襯線字體標題。

## 授權

本項目為商業項目，未經授權不得轉售或公開分發。
