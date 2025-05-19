import UIKit

class GameViewController: UIViewController {
    // Player A/B
    var playerA = Player(name: "Player A", score: 0)
    var playerB = Player(name: "Player B", score: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppTheme.mainBackgroundColor

        // TimerView
        let timerView = TimerView(
            seconds: 15,
            normalColor: AppTheme.timerNormalColor,
            urgentColor: AppTheme.timerUrgentColor
        )
        timerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timerView)

        

        let playerAView = PlayerScoreView(
            player: playerA,
            bgColor: .clear,
            buttonColor: AppTheme.player1ButtonColor
        )
        let playerBView = PlayerScoreView(
            player: playerB,
            bgColor: .clear,
            buttonColor: AppTheme.player2ButtonColor
        )
        playerAView.translatesAutoresizingMaskIntoConstraints = false
        playerBView.translatesAutoresizingMaskIntoConstraints = false

        // 綁定加分邏輯
        playerAView.onScore = { [weak self] in
            guard let self = self else { return }
            self.playerA.score += 1
            playerAView.setPlayer(self.playerA)
        }
        playerBView.onScore = { [weak self] in
            guard let self = self else { return }
            self.playerB.score += 1
            playerBView.setPlayer(self.playerB)
        }

        // StackView 佈局
        let stackView = UIStackView(arrangedSubviews: [playerAView, playerBView])
        stackView.axis = .horizontal
        stackView.spacing = 32
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        // Auto Layout
        NSLayoutConstraint.activate([
            timerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            timerView.widthAnchor.constraint(equalToConstant: 220),
            timerView.heightAnchor.constraint(equalTo: timerView.widthAnchor),

//            stackView.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: 42),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 440), // 兩個 200 寬 + spacing
            stackView.heightAnchor.constraint(equalToConstant: 320),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])

        timerView.start()
        
        timerView.onTimerEnd = { [weak self] in
            self?.handleGameEnd(playerAView: playerAView, playerBView: playerBView, timerView: timerView)
        }
    }
    
    private func handleGameEnd(playerAView: PlayerScoreView, playerBView: PlayerScoreView, timerView: TimerView) {
        // 禁用兩位玩家按鈕
        playerAView.isUserInteractionEnabled = false
        playerBView.isUserInteractionEnabled = false

        // 判斷勝負
        let aScore = playerAView.player.score
        let bScore = playerBView.player.score
        let winnerName: String
        if aScore > bScore {
            winnerName = "\(playerAView.player.name) 勝利！"
        } else if bScore > aScore {
            winnerName = "\(playerBView.player.name) 勝利！"
        } else {
            winnerName = "平手"
        }

        // 彈出 Winner 視窗
        let popup = WinnerPopupView(winnerName: winnerName) { [weak self] in
            self?.resetGame(playerAView: playerAView, playerBView: playerBView, timerView: timerView)
        }
        popup.present(in: self.view)
    }
    
    private func resetGame(playerAView: PlayerScoreView, playerBView: PlayerScoreView, timerView: TimerView) {
        // 重設分數
        self.playerA.score = 0
        self.playerB.score = 0
        playerAView.setPlayer(self.playerA)
        playerBView.setPlayer(self.playerB)
        // 重新啟用按鈕
        playerAView.isUserInteractionEnabled = true
        playerBView.isUserInteractionEnabled = true
        // 重設 timer
        timerView.reset()
        timerView.start()
    }
}
