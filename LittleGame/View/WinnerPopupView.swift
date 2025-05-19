//
//  WinnerPopupView.swift
//  LittleGame
//
//  Created by mike liu on 2025/5/16.
//

import UIKit

/// MVP: 遊戲結束時彈窗顯示 Winner 名稱，從左滑入中間，點擊任一處右滑消失，callback 後重設遊戲
class WinnerPopupView: UIView {
    private let popupView = UIView()
    private let nameLabel = UILabel()
    private var dismissCompletion: (() -> Void)?

    init(winnerName: String, onDismiss: @escaping () -> Void) {
        super.init(frame: .zero)
        self.dismissCompletion = onDismiss
        backgroundColor = UIColor.black.withAlphaComponent(0.38)
        setupPopup(winnerName: winnerName)
        setupGesture()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupPopup(winnerName: String) {
        popupView.backgroundColor = .white
        popupView.layer.cornerRadius = 18
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 0.16
        popupView.layer.shadowRadius = 8
        popupView.layer.shadowOffset = CGSize(width: 0, height: 4)
        addSubview(popupView)
        popupView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.text = winnerName
        nameLabel.font = UIFont.boldSystemFont(ofSize: 32)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .black
        popupView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            popupView.centerYAnchor.constraint(equalTo: centerYAnchor),
            popupView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            popupView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            popupView.heightAnchor.constraint(equalToConstant: 120),
            // popupView 最初位置由動畫決定，初始左側
            nameLabel.centerYAnchor.constraint(equalTo: popupView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -16)
        ])
    }

    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
        popupView.isUserInteractionEnabled = true
    }

    // 外部呼叫，將 popup 從左滑入到中間
    func present(in container: UIView) {
        frame = container.bounds
        container.addSubview(self)
        layoutIfNeeded()
        // 初始於左側畫面外
        let startX = -UIScreen.main.bounds.width
        popupView.transform = CGAffineTransform(translationX: startX, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
            self.popupView.transform = .identity
        }, completion: nil)
    }

    @objc private func handleTap() {
        // 點擊時，彈窗向右滑出
        let endX = UIScreen.main.bounds.width
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
            self.popupView.transform = CGAffineTransform(translationX: endX, y: 0)
            self.alpha = 0.0
        }, completion: { _ in
            self.removeFromSuperview()
            self.dismissCompletion?()
        })
    }
}
