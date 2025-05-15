import UIKit

/// Controller：處理遊戲邏輯與 View 的連結
class GameViewController: UIViewController {
    
    // MARK: - 屬性
    
    private let gameController = GameController(playerName: "玩家1") // 遊戲邏輯
    private let gameView = GameView()                               // 自訂 View
    
    // MARK: - 生命週期
    
    /// 指定 View 為自訂 GameView
    override func loadView() {
        view = gameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 綁定按鈕事件
        gameView.actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        updateUI()
    }
    
    // MARK: - 按鈕動作
    
    /// 點擊「得分！」按鈕
    @objc private func buttonTapped() {
        gameController.addPoint()
        updateUI()
    }
    
    /// 點擊「重玩」按鈕
    @objc private func restartGame() {
        gameController.resetGame()
        gameView.actionButton.removeTarget(self, action: #selector(restartGame), for: .touchUpInside)
        gameView.actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        updateUI()
    }
    
    // MARK: - 更新畫面
    
    /// 根據遊戲狀態更新 UI
    private func updateUI() {
        switch gameController.state {
        case .playing:
            gameView.scoreLabel.text = "分數：\(gameController.player.score)"
            gameView.actionButton.setTitle("得分！", for: .normal)
        case .won:
            gameView.scoreLabel.text = "🎉 You Win! 🎉"
            gameView.actionButton.setTitle("重玩", for: .normal)
            gameView.actionButton.removeTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            gameView.actionButton.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        }
    }
}
