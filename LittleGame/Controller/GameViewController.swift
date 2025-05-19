import UIKit

class GameViewController: UIViewController {
    private var gameBoardView: GameBoardView!
    
    private var gameController = GameController(playerAName: "Player A", playerBName: "Player B")

    private var isPlaying = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppTheme.mainBackgroundColor

        // UI 組裝
        gameBoardView = GameBoardView(
            playerA: gameController.playerA,
            playerB: gameController.playerB
        )
        gameBoardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameBoardView)

        NSLayoutConstraint.activate([
            gameBoardView.topAnchor.constraint(equalTo: view.topAnchor),
            gameBoardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gameBoardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gameBoardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // 綁定 Player A/B 計分按鈕事件，僅呼叫 GameController 方法
        gameBoardView.playerAView.onScore = { [weak self] in
            guard let self = self, self.isPlaying else { return }
            self.gameController.addScoreToPlayerA()
            self.gameBoardView.playerAView.setPlayer(self.gameController.playerA)
        }
        gameBoardView.playerBView.onScore = { [weak self] in
            guard let self = self, self.isPlaying else { return }
            self.gameController.addScoreToPlayerB()
            self.gameBoardView.playerBView.setPlayer(self.gameController.playerB)
        }

        // 綁定開始/重啟按鈕事件
        gameBoardView.startButtonView.onTap = { [weak self] in
            self?.handleStartOrRestart()
        }
        gameBoardView.startButtonView.setState(.start)
        showOrHideScoreButtons(enabled: false)

        // 綁定 Timer 結束事件，呼叫 GameController 結束遊戲
        gameBoardView.timerView.onTimerEnd = { [weak self] in
            self?.gameController.endGame()
        }
        
        // 監聽 GameController 狀態與分數變化自動更新 UI
        gameController.onScoreChanged = { [weak self] player, newScore in
            guard let self = self else { return }
            if player.name == self.gameController.playerA.name {
                self.gameBoardView.playerAView.setPlayer(player)
            } else {
                self.gameBoardView.playerBView.setPlayer(player)
            }
        }
        
        // 監聽狀態改變，自動切換 UI 狀態
        gameController.onStateChanged = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .playing:
                self.showOrHideScoreButtons(enabled: true)
                self.gameBoardView.startButtonView.setState(.restart)
            case .idle:
                self.showOrHideScoreButtons(enabled: false)
                self.gameBoardView.startButtonView.setState(.start)
            case .ended:
                self.showOrHideScoreButtons(enabled: false)
            }
        }
        
        // 監聽遊戲結束，自動顯示 Winner 彈窗
        gameController.onGameEnd = { [weak self] winner in
            guard let self = self else { return }
            let popup = WinnerPopupView(winnerName: winner) { [weak self] in
                self?.resetGameAfterPopup()
            }
            popup.present(in: self.view)
        }
        // ======== End callback ========

        // 預設啟動為 idle 狀態
        gameController.resetGame()
    }

    private func handleStartOrRestart() {
        isPlaying = true
        gameController.startGame()
        gameBoardView.playerAView.setPlayer(gameController.playerA)
        gameBoardView.playerBView.setPlayer(gameController.playerB)
        showOrHideScoreButtons(enabled: true)
        gameBoardView.timerView.reset()
        gameBoardView.timerView.start()
    }
    
    // Winner 彈窗 callback，結束後回 idle 狀態
    private func resetGameAfterPopup() {
        // 彈窗 callback：讓按鈕回到 Start 狀態，玩家不能按
        isPlaying = false
        gameController.resetGame()
        gameBoardView.playerAView.setPlayer(gameController.playerA)
        gameBoardView.playerBView.setPlayer(gameController.playerB)
        gameBoardView.timerView.reset()
    }



    // 切換分數區互動狀態（只能在 playing 狀態可點）
    private func showOrHideScoreButtons(enabled: Bool) {
        gameBoardView.playerAView.isUserInteractionEnabled = enabled
        gameBoardView.playerBView.isUserInteractionEnabled = enabled
    }
}
