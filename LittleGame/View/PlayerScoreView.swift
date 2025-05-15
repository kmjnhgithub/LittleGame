import UIKit

/// PlayerScoreView：顯示玩家名稱、分數與加分按鈕
/// 完全純程式碼、Auto Layout 實作、支援樣式自訂
/// /// ⚠️ 本元件為競速/遊戲用途，為避免 UIButton 內建 debounce，
/// 直接使用 touchesBegan 快速觸發連打計分，確保極速手感。
/// 如日後需兼容輔助功能，建議改回 UIButton 事件機制。
class PlayerScoreView: UIView {
    
    // MARK: - 屬性（外部可設定樣式與回調）
    
    /// 玩家名稱
    var playerName: String {
        didSet { nameLabel.text = playerName }
    }
    /// 玩家分數
    var score: Int {
        didSet { scoreLabel.text = "\(score)" }
    }
    /// 加分按鈕點擊回調
    var onAddScore: (() -> Void)?
    
    // MARK: - UI 元件
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("＋", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 28
        button.layer.shadowOpacity = 0.15
        button.layer.shadowOffset = CGSize(width: 2, height: 4)
        button.isUserInteractionEnabled = false // 只做顯示，觸控交給父 View
        return button
    }()
    
    // MARK: - 初始化
    
    /// 樣式自訂初始化（可傳 bgColor、borderColor、borderWidth）
    init(
        playerName: String,
        score: Int = 0,
        bgColor: UIColor = .white,
        borderColor: UIColor = .systemGray3,
        borderWidth: CGFloat = 1
    ) {
        self.playerName = playerName
        self.score = score
        super.init(frame: .zero)
        backgroundColor = bgColor
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = 20
        layer.masksToBounds = false
        setupUI()
        // name/score 初始化
        nameLabel.text = playerName
        scoreLabel.text = "\(score)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI 配置
    
    private func setupUI() {
        // 子元件加入 View
        addSubview(nameLabel)
        addSubview(scoreLabel)
        addSubview(addButton)
        
        // Auto Layout（直式堆疊）
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            scoreLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            scoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            scoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            addButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 16),
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 56),
            addButton.heightAnchor.constraint(equalToConstant: 56),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - 觸控事件（核心改寫：任何觸控都能觸發計分）
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if addButton.frame.contains(location) {
            triggerAddScore()
        }
        // （如想整塊都能計分，把上面判斷移除）
    }
    
    private func triggerAddScore() {
        // 按鈕壓縮動畫
        UIView.animate(withDuration: 0.1, animations: {
            self.addButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.scoreLabel.transform = CGAffineTransform(scaleX: 1.14, y: 1.14)
        }) { _ in
            UIView.animate(withDuration: 0.13) {
                self.addButton.transform = .identity
                self.scoreLabel.transform = .identity
            }
        }
        onAddScore?()
    }

    
    // MARK: - 外部可呼叫的動畫
    
    /// 分數 Label 彈跳動畫（提供外部使用）
    func animateScoreBounce() {
        UIView.animate(withDuration: 0.13, animations: {
            self.scoreLabel.transform = CGAffineTransform(scaleX: 1.23, y: 1.23)
        }) { _ in
            UIView.animate(withDuration: 0.13) {
                self.scoreLabel.transform = .identity
            }
        }
    }
}
