import UIKit

/// 遊戲畫面 View
/// 純粹負責 UI，不涉及邏輯
class GameView: UIView {
    
    // MARK: - UI 元件
    
    /// 顯示分數的 Label
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// 玩家互動的按鈕
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("得分！", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - 初始化
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - 建立 UI 與 Auto Layout
    
    private func setupUI() {
        backgroundColor = .white
        
        // 加入元件
        addSubview(scoreLabel)
        addSubview(actionButton)
        
        // 使用 safeAreaLayoutGuide + Auto Layout
        NSLayoutConstraint.activate([
            scoreLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: -50),
            
            actionButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            actionButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 40)
        ])
    }
}
