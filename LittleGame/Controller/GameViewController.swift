import UIKit

class GameViewController: UIViewController {
    var playerA = Player(name: "Player A", score: 0)
    var playerB = Player(name: "Player B", score: 0)
    private var gameBoardView: GameBoardView!

    private var isPlaying = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppTheme.mainBackgroundColor

        gameBoardView = GameBoardView(playerA: playerA, playerB: playerB)
        gameBoardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameBoardView)

        NSLayoutConstraint.activate([
            gameBoardView.topAnchor.constraint(equalTo: view.topAnchor),
            gameBoardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gameBoardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gameBoardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // 綁定分數事件
        gameBoardView.playerAView.onScore = { [weak self] in
            guard let self = self, self.isPlaying else { return }
            self.playerA.score += 1
            self.gameBoardView.playerAView.setPlayer(self.playerA)
        }
        gameBoardView.playerBView.onScore = { [weak self] in
            guard let self = self, self.isPlaying else { return }
            self.playerB.score += 1
            self.gameBoardView.playerBView.setPlayer(self.playerB)
        }

        // 按鈕事件
        gameBoardView.startButtonView.onTap = { [weak self] in
            self?.handleStartOrRestart()
        }
        gameBoardView.startButtonView.setState(.start)
        showOrHideScoreButtons(enabled: false)

        // Timer 結束
        gameBoardView.timerView.onTimerEnd = { [weak self] in
            self?.handleGameEnd()
        }
    }

    private func handleStartOrRestart() {
        // Start or Restart 都做完全 reset + start
        isPlaying = true
        playerA.score = 0
        playerB.score = 0
        gameBoardView.playerAView.setPlayer(playerA)
        gameBoardView.playerBView.setPlayer(playerB)
        showOrHideScoreButtons(enabled: true)
        gameBoardView.timerView.reset()
        gameBoardView.timerView.start()
        gameBoardView.startButtonView.setState(.restart)
    }

    private func handleGameEnd() {
        isPlaying = false
        gameBoardView.playerAView.isUserInteractionEnabled = false
        gameBoardView.playerBView.isUserInteractionEnabled = false

        // 判斷勝負
        let aScore = playerA.score
        let bScore = playerB.score
        let winnerName: String
        if aScore > bScore {
            winnerName = "\(playerA.name) 勝利！"
        } else if bScore > aScore {
            winnerName = "\(playerB.name) 勝利！"
        } else {
            winnerName = "平手"
        }

        // 彈窗：從左滑入，點擊滑出，callback 重設遊戲
        let popup = WinnerPopupView(winnerName: winnerName) { [weak self] in
            self?.resetGameAfterPopup()
        }
        popup.present(in: self.view)
    }
    

    
    private func resetGameAfterPopup() {
        // 彈窗 callback：讓按鈕回到 Start 狀態，玩家不能按
        isPlaying = false
        playerA.score = 0
        playerB.score = 0
        gameBoardView.playerAView.setPlayer(playerA)
        gameBoardView.playerBView.setPlayer(playerB)
        showOrHideScoreButtons(enabled: false)
        gameBoardView.timerView.reset()
        gameBoardView.startButtonView.setState(.start)
    }


    private func showOrHideScoreButtons(enabled: Bool) {
        gameBoardView.playerAView.isUserInteractionEnabled = enabled
        gameBoardView.playerBView.isUserInteractionEnabled = enabled
    }
}
