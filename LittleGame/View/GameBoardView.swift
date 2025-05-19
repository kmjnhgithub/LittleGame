import UIKit

class GameBoardView: UIView {
    let timerView: TimerView
    let startButtonView: GameStartButtonView
    let playerAView: PlayerScoreView
    let playerBView: PlayerScoreView

    init(playerA: Player, playerB: Player) {
        self.timerView = TimerView(
            seconds: 15,
            normalColor: AppTheme.timerNormalColor,
            urgentColor: AppTheme.timerUrgentColor
        )
        self.startButtonView = GameStartButtonView()
        self.playerAView = PlayerScoreView(
            player: playerA,
            bgColor: .clear,
            buttonColor: AppTheme.player1ButtonColor
        )
        self.playerBView = PlayerScoreView(
            player: playerB,
            bgColor: .clear,
            buttonColor: AppTheme.player2ButtonColor
        )
        super.init(frame: .zero)
        setupUI()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        backgroundColor = AppTheme.mainBackgroundColor

        addSubview(timerView)
        addSubview(startButtonView)
        addSubview(playerAView)
        addSubview(playerBView)

        timerView.translatesAutoresizingMaskIntoConstraints = false
        startButtonView.translatesAutoresizingMaskIntoConstraints = false
        playerAView.translatesAutoresizingMaskIntoConstraints = false
        playerBView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // TimerView 置中
            timerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            timerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 48),
            timerView.widthAnchor.constraint(equalToConstant: 220),
            timerView.heightAnchor.constraint(equalTo: timerView.widthAnchor),

            // StartButton 置中、timer 下方
            startButtonView.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: 28),
            startButtonView.centerXAnchor.constraint(equalTo: centerXAnchor),
            startButtonView.widthAnchor.constraint(equalToConstant: 200),
            startButtonView.heightAnchor.constraint(equalToConstant: 62),

            // PlayerA 左側
            playerAView.topAnchor.constraint(equalTo: startButtonView.bottomAnchor, constant: 32),
            playerAView.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -16),
            playerAView.widthAnchor.constraint(equalToConstant: 200),
            playerAView.heightAnchor.constraint(equalToConstant: 320),

            // PlayerB 右側
            playerBView.topAnchor.constraint(equalTo: startButtonView.bottomAnchor, constant: 32),
            playerBView.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 16),
            playerBView.widthAnchor.constraint(equalToConstant: 200),
            playerBView.heightAnchor.constraint(equalToConstant: 320),

            // 玩家分數區底部距離
            playerAView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -80),
            playerBView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
    }
}
