#  專案架構流程

## 1. 專案目標與原則

- 練習 iOS App 基本開發，**全部使用 programmatic UIKit（純程式碼 UI，不用 Storyboard）**，遵循 MVC 架構與 UIKit 原則。
- 以雙人同機競速點擊為主軸，包含倒數計時、分數比較、獲勝判斷與懲罰設計。
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
LittleGame/
├── Model/
│   ├── Player.swift
│   ├── GameState.swift
│   └── GameController.swift            # 專門負責「業務邏輯」層（邏輯處理、狀態管理、分數增減、勝負判斷等）。
│
├── View/
│   ├── TimerView.swift
│   ├── PlayerScoreView.swift
│   ├── WinnerPopupView.swift
│   ├── GameBoardView.swift             # UI組裝，只組合元件，不實作元件邏輯
│   ├── GameStartButtonView.swift       # ⬅️ Start/Restart 按鈕獨立（主題色/動畫/自訂行為）
│   └── PunishmentWheelView.swift       <!-- 待開發 -->
│ 
├── Theme/
│   └── AppTheme.swift
│
├── Controller/
│   └── GameViewController.swift       # 負責 UI 串接與事件監聽，不碰任何遊戲規則邏輯
│
├── Assets/
│   └── wireframe.png
│
└── README.md

## 2.1 架構設計

- **GameStartButtonView.swift**
    - 負責顯示並控制「開始／重新開始」按鈕。
    - 管理按鈕狀態（Start/Restart）、主題樣式、互動動畫。
    - 對外暴露 action callback，方便 Controller 掌握流程切換。
- **GameBoardView.swift**
    - 純負責組裝主遊戲畫面區塊（TimerView、GameStartButtonView、PlayerScoreView…），不處理邏輯與細節。
    - 便於 UI 排列調整、日後擴充。
- **PlayerScoreView.swift**
    - 呈現單一玩家名稱、分數與極速連點計分按鈕，並支援動畫效果。
- **TimerView.swift**
    - 倒數計時圓環、緊張動畫與結束回呼。
- **WinnerPopupView.swift**
    - 遊戲結束時顯示獲勝玩家彈窗（含動畫）。
- **GameController.swift**
    - 處理遊戲狀態流、分數計算、資料同步，後續可補全完整流程。
- **GameViewController.swift**
    - 主流程管理者，組裝 GameBoardView、注入/監聽 GameStartButtonView 事件，處理狀態與流程轉換。
- **AppTheme.swift**
    - 統一所有元件顏色、字型、圓角等主題設計，維持一致風格。
- **PunishmentWheelView.swift**
    - 預留懲罰輪盤 UI 與動畫，後續可擴充。
    
### 2.2 互動流程示意

- **初始化（尚未開始）**
    - 分數歸零，Timer 顯示預設秒數，GameStartButton 顯示「Start」。
- **按下 Start**
    - Controller 觸發遊戲開始，分數歸零，Timer 開始倒數，按鈕切換為「Restart」。
    - 玩家可極速連點計分按鈕。
- **倒數結束**
    - 停止計分，彈出 WinnerPopupView，主按鈕變回「Start」或進入重設流程。
- **Restart**
    - 任意時刻可按 Restart，強制重設分數、Timer，流程重啟。

---


## 3. AppTheme主題設計
- 主色調：優先選用 iOS 內建顏色（如 .systemBlue, .systemPink, .systemYellow），再依 wireframe 配色微調透明度、深淺等，避免自定義顏色過多。

- 分數區塊：每位玩家一個 PlayerScoreView，背景色根據 wireframe 選用不同系統顏色（如 Player1: .systemBlue，Player2: .systemPink），並加強對比。

- 計分按鈕：每位玩家一個計分按鈕，按鈕顏色需明顯區隔兩方（建議參考 wireframe，例如一藍一紅），按鈕文字皆為白色（.white）。

- 玩家名稱：採用系統標準色（建議 .label 或搭配分數區塊的明亮背景色），確保文字易讀。

- 計時器區塊：背景可設置為 .systemBackground 或 wireframe 亮色調，數字採大字粗體。

- 按壓動畫：所有可互動按鈕皆需有縮放回彈或陰影特效，對應 wireframe 活潑風格。

- 整體背景：主畫面背景色建議為 .systemBackground，適當加入漸層或色塊裝飾，強化派對感。

- 輔助裝飾：可加入表情 icon、動態粒子、勝負/懲罰動畫，符合 wireframe 所營造的派對氣氛。

---

## 4. 進度紀錄

### ✅ 已完成
- **TimerView**
    - 倒數計時元件，支援動畫、緊張狀態顏色切換、倒數結束回呼、記憶體安全設計。
- **AppTheme**
    - 統一管理主題色彩、字型、按鈕與元件樣式，便於全域風格維護。
- **PlayerScoreView**
    - 呈現玩家名稱、分數、極速連點自訂按鈕，支援動畫、Auto Layout、主題樣式參數，程式結構與註解完整。
- **WinnerPopupView**
    - 遊戲結束彈窗顯示勝利者（或平手），動畫為左進中顯、點擊右滑消失，callback 控制遊戲重設。
- **雙人模式**
    - Player 與 PlayerScoreView 已支援雙玩家分數獨立、極速競賽互動。
- **GameBoardView**
    - 主遊戲 UI 組裝區，負責 TimerView、GameStartButtonView、PlayerScoreView 的組合與排列，完全不含邏輯、支援 Auto Layout。
- **GameStartButtonView**
    - Start/Restart 按鈕元件，支援狀態切換、動畫、主題樣式，對外提供 callback 事件。
- **GameViewController**
    - 精簡 Controller，完全只負責流程管理、事件串接與狀態同步，不直接組 UI 元件、不碰細節邏輯。
    - 串接 Timer 結束彈窗、popup callback 重設流程、按鈕狀態/流程切換。
- **完整流程**
    - 遊戲尚未開始顯示 Start，開始遊戲後按鈕變 Restart，倒數結束正確顯示 WinnerPopup，點擊後遊戲歸零可再開始。

---

### 🔄 進行中 / 待辦
- **GameController（業務邏輯層）**
    - 抽離 Controller 中的分數、狀態計算邏輯，未來讓 Controller 只做 UI 流程，利於維護及擴充。
- **PunishmentWheelView**
    - 懲罰轉盤動畫區塊（UI/流程預留，尚未開始）
- **遊戲規則與擴充**
    - 遊戲懲罰、多人模式、主題特效等（可依後續需求規劃）

---

### 🚩 下一步
- 開發 GameController，完成業務邏輯抽離（推薦先行）。
- 規劃 PunishmentWheelView 或其它互動/動畫元件。
- 定期補充 README 進度與技術筆記，方便檢討。
