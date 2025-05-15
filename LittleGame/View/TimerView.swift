import UIKit

class TimerView: UIView {
    // MARK: - 公開屬性
    var totalSeconds: Int
    private(set) var secondsLeft: Int
    var onTimerEnd: (() -> Void)?

    // 可調主色與緊張色
    var normalColor: UIColor = .systemBlue
    var urgentColor: UIColor = .systemOrange
    
    // MARK: - 私有 UI
    private let bgLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 54, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var timer: Timer?
    private var isRunning = false
    
    private let ringWidth: CGFloat = 14

    // MARK: - 初始化
    init(seconds: Int = 30) {
        self.totalSeconds = seconds
        self.secondsLeft = seconds
        super.init(frame: .zero)
        backgroundColor = UIColor(red: 16/255, green: 22/255, blue: 44/255, alpha: 1)
        setupLayers()
        setupUI()
        updateDisplay()
    }
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - UI 佈局
    private func setupLayers() {
        // 背景圓環
        bgLayer.strokeColor = UIColor.white.withAlphaComponent(0.14).cgColor
        bgLayer.lineWidth = ringWidth
        bgLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(bgLayer)
        // 主進度圓環
        progressLayer.strokeColor = normalColor.cgColor
        progressLayer.lineWidth = ringWidth
        progressLayer.lineCap = .round
        progressLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(progressLayer)
    }
    private func setupUI() {
        addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - ringWidth/2 - 2
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: -.pi/2, endAngle: .pi*1.5, clockwise: true)
        bgLayer.path = path.cgPath
        progressLayer.path = path.cgPath
    }

    // MARK: - 計時邏輯
    func start() {
        guard !isRunning, secondsLeft > 0 else { return }
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    func pause() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
    func reset() {
        pause()
        secondsLeft = totalSeconds
        updateDisplay()
    }
    private func tick() {
        guard secondsLeft > 0 else { return }
        secondsLeft -= 1
        updateDisplay()
        if secondsLeft <= 10 && secondsLeft > 0 {
            urgentEffect()
        }
        if secondsLeft == 0 {
            pause()
            finishEffect()
            onTimerEnd?()
        }
    }

    // MARK: - 畫面更新與動畫
    private func updateDisplay() {
        timeLabel.text = "\(secondsLeft)"
        let percent = CGFloat(secondsLeft) / CGFloat(totalSeconds)
        progressLayer.strokeEnd = percent
        progressLayer.strokeColor = (secondsLeft <= 10 ? urgentColor : normalColor).cgColor
    }
    private func urgentEffect() {
        UIView.animate(withDuration: 0.13, animations: {
            self.timeLabel.transform = CGAffineTransform(scaleX: 1.75, y: 1.75)
            self.progressLayer.lineWidth = self.ringWidth + 4
        }) { _ in
            UIView.animate(withDuration: 0.12) {
                self.timeLabel.transform = .identity
                self.progressLayer.lineWidth = self.ringWidth
            }
        }
        // 震動
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
    private func finishEffect() {
        UIView.animate(withDuration: 0.2, animations: {
            self.timeLabel.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
            self.timeLabel.alpha = 0
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.timeLabel.transform = .identity
                self.timeLabel.alpha = 1
            }
        }
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
    }
}
