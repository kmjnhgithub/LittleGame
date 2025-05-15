
/// 遊戲邏輯控制器
/// 負責操作 Player 資料與遊戲狀態
class GameController {
    var player: Player
    var state: GameState = .playing
    let winningScore = 10  // 遊戲勝利條件
    
    init(playerName: String) {
        self.player = Player(name: playerName)
    }
    
    /// 玩家得分邏輯
    func addPoint() {
        guard state == .playing else { return }
        player.score += 1
        if player.score >= winningScore {
            state = .won
        }
    }
    
    /// 重置遊戲
    func resetGame() {
        player.score = 0
        state = .playing
    }
}
