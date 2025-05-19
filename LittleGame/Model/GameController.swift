
/// 遊戲邏輯控制器
/// 負責操作 Player 資料與遊戲狀態


class GameController {
    private(set) var playerA: Player
    private(set) var playerB: Player
    private(set) var state: GameState = .idle
    
    // MARK: - 勝負判斷（回傳結果字串）
    func judgeWinner() -> String {
        if playerA.score > playerB.score {
            return "\(playerA.name) 勝利！"
        } else if playerB.score > playerA.score {
            return "\(playerB.name) 勝利！"
        } else {
            return "平手"
        }
    }
    
    // 事件回呼
    // 分數變動時呼叫
    var onScoreChanged: ((Player, Int) -> Void)?

    // 狀態改變時呼叫
    var onStateChanged: ((GameState) -> Void)?

    // 遊戲結束時呼叫
    var onGameEnd: ((String) -> Void)? // 勝者名稱
        
    init(playerAName: String, playerBName: String) {
        self.playerA = Player(name: playerAName, score: 0)
        self.playerB = Player(name: playerBName, score: 0)
    }
    
    func startGame() {
        resetScores()
        state = .playing
        onStateChanged?(state)
    }
    
    func endGame() {
        state = .ended
        onStateChanged?(state)
        let winner = judgeWinner()
        onGameEnd?(winner)
    }
    
    func resetGame() {
        resetScores()
        state = .idle
        onStateChanged?(state) //  呼叫 callback 通知 UI 切換狀態
    }
    
    func addScoreToPlayerA() {
        playerA.score += 1
        onScoreChanged?(playerA, playerA.score)
    }
    
    func addScoreToPlayerB() {
        playerB.score += 1
        onScoreChanged?(playerB, playerB.score)
    }
    
    // MARK: - 分數歸零（遊戲重設）
    func resetScores() {
        playerA.score = 0
        playerB.score = 0
    }
    

}
