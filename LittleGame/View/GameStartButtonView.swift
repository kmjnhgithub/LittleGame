//
//  GameStartButtonView.swift
//  LittleGame
//
//  Created by mike liu on 2025/5/19.
//

import UIKit

/// GameStartButtonView - 管理 Start/Restart 狀態與點擊事件
class GameStartButtonView: UIView {
    
    // MARK: - 狀態枚舉
    enum State {
        case start
        case restart
    }
    
    // MARK: - 屬性
    private let button = UIButton(type: .system)
    private(set) var state: State = .start {
        didSet { updateAppearance() }
    }
    var onTap: (() -> Void)?
    
    // MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - UI 初始化
    private func setupUI() {
        backgroundColor = .clear
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // 按鈕外觀
        button.backgroundColor = UIColor.systemYellow
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        button.layer.cornerRadius = 16
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.13
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 7
        button.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 64) // 高度建議 56~72
        ])
        updateAppearance()
    }
    
    // MARK: - 狀態切換
    func setState(_ state: State) {
        self.state = state
    }
    
    private func updateAppearance() {
        switch state {
        case .start:
            button.setTitle("Start", for: .normal)
            button.backgroundColor = UIColor.systemYellow
        case .restart:
            button.setTitle("Restart", for: .normal)
            button.backgroundColor = UIColor.systemOrange
        }
    }
    
    // MARK: - 互動動畫與事件
    @objc private func tapAction() {
        // 點擊縮放動畫
        UIView.animate(withDuration: 0.08, animations: {
            self.button.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
        }) { _ in
            UIView.animate(withDuration: 0.10, animations: {
                self.button.transform = .identity
            })
        }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        onTap?()
    }
}
