#  專案架構流程

## 1. 專案目標與原則

- 練習 iOS App 基本開發，**全部使用 programmatic UIKit（純程式碼 UI，不用 Storyboard）**，遵循 MVC 架構與 UIKit 原則。
- 雙人同機競速點擊遊戲（倒數計時，分數比大小，輸家轉盤懲罰）設計兩位玩家。
- 以清晰、好維護為主，註解充足，程式結構基礎直觀。
- 參考wireframe.png設計layout。
- 透過AppTheme來統一管理所有元件的風格與顏色。
- 不引入第三方庫
- 嚴守 Auto Layout，UI 元件需支援樣式參數（bgColor, borderColor, borderWidth）
- 程式架構自我審查，包含 timer/動畫記憶體安全、平手判斷、主題管理
- 動畫優化作為獨立步驟，流程與微互動動畫集中在 View class
- 每個元件/功能單元盡量模組化，可重用/擴充
- UI/Model 分離，避免 fat controller


## 2. 架構設計

**📁 專案目錄結構**

- Model/
    - Player.swift
    - GameController.swift
    - GameState.swift
- View/
    - PlayerScoreView.swift ←（待完成）
    - GameBoardView.swift ←（待開發）
    - TimerView.swift ←（待開發）
    - PunishmentWheelView.swift（待開發）
- Theme/
    - AppTheme.swift (待開發)
- Controller/
    - GameViewController.swift
    - TestPlayerScoreViewController.swift（測試元件用）
    - TestGameBoardViewController.swift（測試元件用）
    - TestTimerViewController.swift（測試元件用）
- Assets/
    - wireframe.png

### (A) Model

- Player: id、name、score
- GameController: 管理 players, 遊戲狀態、倒數
- GameState: playing、ended、spinning、tie（預留）

### (B) View（元件化、可重用）

- PlayerScoreView（分數＋按鈕，樣式可自訂、Auto Layout）
- TimerView（倒數計時，動畫）
- GameBoardView（組合 PlayerScoreView & TimerView，支援 StackView）
- PunishmentWheelView（簡易轉盤，動畫）

### (C) Controller

- GameViewController: 控流程、狀態轉換、串連各 View

---

## 3. 分階段開發流程

1. PlayerScoreView
2. TimerView
3. AppTheme
4. GameBoardView
5. PunishmentWheelView
6. GameViewController 邏輯整合
7. 動畫與整體 UI 優化（包含：
- 流程動畫
- 分數動畫（如分數 Label 彈跳效果）
- 轉盤動畫
- 按鈕風格（含按壓動畫、圓角、陰影）
- 現代感主題色系（可主題切換）
- 整體 UI 設計需活潑有趣，適合聚會時遊玩
- 畫面需避免過度陽春，需有適度動畫、色彩、圖形點綴
- 聚會感、活潑感、派對氛圍為主軸，建議加入：
    - 表情 icon
    - 動態粒子（如勝利/懲罰時撒花/閃光等）
    - 色塊（趣味配色、漸層背景等）
    - 節奏音效（按鈕、勝負、轉盤等時機）
    - 其他動態互動元素，強化派對、歡樂氣氛

---

## 4. 進度紀錄

### ✅ 已完成

- **PlayerScoreView**
    - 支援自訂樣式，Auto Layout，touchesBegan 快速計分，程式註解清楚。
- **TestViewController**
    - 可獨立測試 PlayerScoreView 功能、驗證計分與動畫。
- **TimerView**（倒數計時元件，動畫）

### ⏳ 進行中/待辦
- **AppTheme**
    - 尚未完成
- **PlayerScoreView**
    - 雙人模式。
- **GameBoardView**（主遊戲組合 UI）
- **PunishmentWheelView**（轉盤動畫）
- **GameViewController**（整合多玩家/流程，邏輯重構）

---




