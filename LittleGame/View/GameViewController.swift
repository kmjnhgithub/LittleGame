//import UIKit
//
//// MARK: - 玩家資料模型 (使用 struct)
///// 玩家資料：名稱與分數
//struct Player {
//    var name: String
//    var score: Int = 0
//}
//
//// MARK: - 遊戲狀態 (使用 enum)
///// 遊戲目前的狀態
//enum GameState {
//    case playing    // 遊戲進行中
//    case won        // 玩家獲勝
//}
//
//// MARK: - 遊戲邏輯控制器 (使用 class)
///// 遊戲邏輯：負責處理分數與狀態
//class GameController {
//    var player: Player
//    var state: GameState = .playing
//    let winningScore = 10  // 遊戲勝利條件
//    
//    init(playerName: String) {
//        self.player = Player(name: playerName)
//    }
//    
//    /// 玩家得分
//    func addPoint() {
//        guard state == .playing else { return } // 如果已經結束就不處理
//        player.score += 1
//        
//        // 如果分數達到目標，改變遊戲狀態
//        if player.score >= winningScore {
//            state = .won
//        }
//    }
//}
//
//// MARK: - 遊戲畫面 (UIKit UIViewController)
///// 遊戲主要畫面控制器
//class GameViewController: UIViewController {
//    
//    // 遊戲邏輯控制器
//    private let gameController = GameController(playerName: "玩家1")
//    
//    // 顯示分數的 Label
//    private let scoreLabel = UILabel()
//    
//    // 玩家互動的按鈕
//    private let actionButton = UIButton(type: .system)
//    
//    // 畫面載入時呼叫
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupUI()       // 初始化畫面
//        updateUI()      // 更新初始顯示
//    }
//    
//    /// 設定畫面元素
//    private func setupUI() {
//        // 設定分數 Label
//        scoreLabel.textAlignment = .center
//        scoreLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
//        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(scoreLabel)
//        
//        // 設定按鈕
//        actionButton.setTitle("得分！", for: .normal)
//        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
//        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//        actionButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(actionButton)
//        
//        // AutoLayout 版面配置
//        NSLayoutConstraint.activate([
//            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            scoreLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
//            
//            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            actionButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 40)
//        ])
//    }
//    
//    /// 玩家按下按鈕時
//    @objc private func buttonTapped() {
//        gameController.addPoint()   // 增加分數
//        updateUI()                  // 更新畫面
//    }
//    
//    /// 根據遊戲狀態更新畫面
//    private func updateUI() {
//        switch gameController.state {
//        case .playing:
//            // 遊戲進行中，顯示分數
//            scoreLabel.text = "分數：\(gameController.player.score)"
//            actionButton.setTitle("得分！", for: .normal)
//        case .won:
//            // 遊戲結束，顯示勝利
//            scoreLabel.text = "🎉 You Win! 🎉"
//            actionButton.setTitle("重玩", for: .normal)
//            
//            // 更換按鈕功能為重啟遊戲
//            actionButton.removeTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//            actionButton.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
//        }
//    }
//    
//    /// 重啟遊戲
//    @objc private func restartGame() {
//        // 重置玩家分數與遊戲狀態
//        gameController.player.score = 0
//        gameController.state = .playing
//        
//        // 恢復按鈕功能
//        actionButton.removeTarget(self, action: #selector(restartGame), for: .touchUpInside)
//        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//        
//        updateUI()  // 更新畫面
//    }
//}
