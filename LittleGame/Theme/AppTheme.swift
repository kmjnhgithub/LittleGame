import UIKit

/// AppTheme：統一管理全局顏色、字型、按鈕樣式等設計規範
struct AppTheme {
    // 主背景色
    static let mainBackgroundColor: UIColor =  .systemFill

    // Timer 顏色設定（完全參考 TimerView.swift）
    static let timerNormalColor: UIColor = .systemBlue    // 普通狀態
    static let timerUrgentColor: UIColor = .systemRed  // 緊張/最後10秒
    static let timerInnerColor: UIColor = .white          // 圓底色（如需用到）

    // 玩家名稱、分數字體顏色
    static let playerNameTextColor: UIColor = .white
    static let scoreTextColor: UIColor = .white

    // 按鈕顏色
    static let player1ButtonColor: UIColor = .systemBlue   // A 玩家
    static let player2ButtonColor: UIColor = .systemRed    // B 玩家
    static let buttonTextColor: UIColor = .white

    // 按鈕外觀
    static let buttonCornerRadius: CGFloat = 48
    static let buttonFont: UIFont = .boldSystemFont(ofSize: 28)
    static let buttonShadowColor: UIColor = UIColor.black.withAlphaComponent(0.2)
    static let buttonShadowOpacity: Float = 0.22
    static let buttonShadowRadius: CGFloat = 6

    // 玩家名稱與分數字型
    static let playerNameFont: UIFont = .boldSystemFont(ofSize: 20)
    static let scoreFont: UIFont = .boldSystemFont(ofSize: 48)

    // Timer 字型
    static let timerFont: UIFont = .boldSystemFont(ofSize: 54)
}
