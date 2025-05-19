import UIKit

/// 單一玩家分數區：名稱、分數、極速連點自訂按鈕
class PlayerScoreView: UIView {
    // MARK: - UI 元件
    private let bgView = UIView()
    private let nameLabel = UILabel()
    private let scoreLabel = UILabel()
    private let scoreButton = ScoreButtonView() // 自訂 UIView，支援極速連點與動畫

    // MARK: - 狀態
    private(set) var player: Player
    var onScore: (() -> Void)? // Controller 注入的計分回呼

    // MARK: - 初始化，注入玩家、主題色
    init(player: Player, bgColor: UIColor, buttonColor: UIColor) {
        self.player = player
        super.init(frame: .zero)
        setupUI(bgColor: bgColor, buttonColor: buttonColor)
        updateDisplay()
    }
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - UI 組裝
    private func setupUI(bgColor: UIColor, buttonColor: UIColor) {
        // 背景區塊
        bgView.backgroundColor = bgColor
        bgView.layer.cornerRadius = 32
        bgView.layer.masksToBounds = false
        bgView.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        bgView.layer.shadowOpacity = 0.12
        bgView.layer.shadowOffset = CGSize(width: 0, height: 2)
        bgView.layer.shadowRadius = 10

        addSubview(bgView)
        bgView.translatesAutoresizingMaskIntoConstraints = false

        // 玩家名稱
        nameLabel.font = AppTheme.playerNameFont
        nameLabel.textColor = AppTheme.playerNameTextColor
        nameLabel.textAlignment = .center
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        // 分數
        scoreLabel.font = AppTheme.scoreFont
        scoreLabel.textColor = AppTheme.scoreTextColor
        scoreLabel.textAlignment = .center
        addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false

        // 自訂按鈕
        scoreButton.setTitle("+1", font: AppTheme.buttonFont, color: AppTheme.buttonTextColor)
        scoreButton.buttonColor = buttonColor
        scoreButton.layer.cornerRadius = AppTheme.buttonCornerRadius
        scoreButton.layer.shadowColor = AppTheme.buttonShadowColor.cgColor
        scoreButton.layer.shadowOpacity = AppTheme.buttonShadowOpacity
        scoreButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        scoreButton.layer.shadowRadius = AppTheme.buttonShadowRadius
        addSubview(scoreButton)
        scoreButton.translatesAutoresizingMaskIntoConstraints = false

        // 極速連點回呼
        scoreButton.onTapped = { [weak self] in
            guard let self = self else { return }
            self.onScore?()           // Controller 綁定分數加一
            self.playScoreAnimation() // 分數跳動
        }

        // Auto Layout
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            bgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            bgView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),

            nameLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -12),

            scoreLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24),
            scoreLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 12),
            scoreLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -12),

            scoreButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 32),
            scoreButton.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            scoreButton.widthAnchor.constraint(equalToConstant: 96),
            scoreButton.heightAnchor.constraint(equalToConstant: 96),
            scoreButton.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -18)
        ])
    }

    // MARK: - 外部更新分數/名稱
    func setPlayer(_ player: Player) {
        self.player = player
        updateDisplay()
    }

    private func updateDisplay() {
        nameLabel.text = player.name
        scoreLabel.text = "\(player.score)"
    }

    // 分數 Label 動畫（點擊跳動）
    private func playScoreAnimation() {
        UIView.animate(withDuration: 0.12, animations: {
            self.scoreLabel.transform = CGAffineTransform(scaleX: 1.22, y: 1.22)
        }) { _ in
            UIView.animate(withDuration: 0.11) {
                self.scoreLabel.transform = .identity
            }
        }
    }
}

/// 自訂 UIView 按鈕，完全極速連點，動畫不卡
class ScoreButtonView: UIView {
    var onTapped: (() -> Void)?
    var buttonColor: UIColor = .systemBlue {
        didSet { backgroundColor = buttonColor }
    }
    private let titleLabel = UILabel()
    private var currentAnimator: UIViewPropertyAnimator?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        backgroundColor = buttonColor
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = AppTheme.buttonFont
        titleLabel.textColor = AppTheme.buttonTextColor

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        isUserInteractionEnabled = true
    }

    func setTitle(_ text: String, font: UIFont, color: UIColor) {
        titleLabel.text = text
        titleLabel.font = font
        titleLabel.textColor = color
    }

    // MARK: - 觸控事件處理（極速連點動畫不卡）
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateScale(down: true)
        onTapped?()
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animateScale(down: false)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animateScale(down: false)
    }
    private func animateScale(down: Bool) {
        // 立即中止現有動畫，確保新動畫流暢執行
        currentAnimator?.stopAnimation(true)
        currentAnimator = nil
        let target: CGFloat = down ? 0.87 : 1.0
        let duration: TimeInterval = down ? 0.08 : 0.13
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            self.transform = CGAffineTransform(scaleX: target, y: target)
        }
        animator.startAnimation()
        currentAnimator = animator
    }
}
