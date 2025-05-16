import UIKit

/// PlayerScoreView：顯示玩家名稱、分數與加分按鈕
/// 完全純程式碼、Auto Layout 實作、支援樣式自訂
/// /// ⚠️ 本元件為競速/遊戲用途，為避免 UIButton 內建 debounce，
/// 直接使用 touchesBegan 快速觸發連打計分，確保極速手感。
/// 如日後需兼容輔助功能，建議改回 UIButton 事件機制。
/// 雙人分數顯示元件
/// 依 wireframe 左右各一玩家，顯示分數與名稱
class PlayerScoreView: UIView {
    
    // MARK: - 公開方法：分數更新
    func updateScore(player1: Int, player2: Int) {
        player1ScoreLabel.text = "\(player1)"
        player2ScoreLabel.text = "\(player2)"
    }
    
    func updateNames(player1: String, player2: String) {
        player1NameLabel.text = player1
        player2NameLabel.text = player2
    }
    
    // MARK: - 私有 UI 元件
    private let player1ScoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.textColor = AppTheme.player1Color
        label.textAlignment = .center
        label.text = "0"
        return label
    }()
    private let player2ScoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.textColor = AppTheme.player2Color
        label.textAlignment = .center
        label.text = "0"
        return label
    }()
    private let player1NameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppTheme.player1Color
        label.textAlignment = .center
        label.text = "玩家1"
        return label
    }()
    private let player2NameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppTheme.player2Color
        label.textAlignment = .center
        label.text = "玩家2"
        return label
    }()
    
    // 左右分隔線（加強視覺對稱，非必要可拿掉）
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = AppTheme.separatorColor.withAlphaComponent(0.2)
        return view
    }()
    
    // MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI 組裝
    private func setupUI() {
        backgroundColor = .clear
        
        // Player1 垂直 stack
        let player1Stack = UIStackView(arrangedSubviews: [player1ScoreLabel, player1NameLabel])
        player1Stack.axis = .vertical
        player1Stack.alignment = .center
        player1Stack.spacing = 4
        
        // Player2 垂直 stack
        let player2Stack = UIStackView(arrangedSubviews: [player2ScoreLabel, player2NameLabel])
        player2Stack.axis = .vertical
        player2Stack.alignment = .center
        player2Stack.spacing = 4
        
        // 主要水平 stack
        let mainStack = UIStackView(arrangedSubviews: [player1Stack, separatorView, player2Stack])
        mainStack.axis = .horizontal
        mainStack.distribution = .fillEqually
        mainStack.alignment = .center
        mainStack.spacing = 8
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStack)
        
        // 分隔線寬度
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.widthAnchor.constraint(equalToConstant: 1),
            separatorView.heightAnchor.constraint(equalTo: mainStack.heightAnchor, multiplier: 0.7),
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
