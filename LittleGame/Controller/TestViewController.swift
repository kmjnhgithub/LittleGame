//
//  TestViewController.swift
//  LittleGame
//
//  Created by mike liu on 2025/5/15.
//

import UIKit

/// 測試 PlayerScoreView 畫面的專用 Controller
class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground  // 背景色較不刺眼，方便測試
        
        // 建立一個 PlayerScoreView 實例
        let playerScoreView = PlayerScoreView(
            playerName: "小明",
            score: 3,
            bgColor: .white,
            borderColor: .systemBlue,
            borderWidth: 2
        )
        playerScoreView.translatesAutoresizingMaskIntoConstraints = false
        
        // 加進主畫面
        view.addSubview(playerScoreView)
        
        // 用 Auto Layout 置中並設固定大小
        NSLayoutConstraint.activate([
            playerScoreView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playerScoreView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playerScoreView.widthAnchor.constraint(equalToConstant: 220),
            playerScoreView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        // 測試加分按鈕的回呼
        playerScoreView.onAddScore = { [weak playerScoreView] in
            guard let view = playerScoreView else { return }
            view.score += 1
            view.animateScoreBounce()  // 直接呼叫動畫方法，不碰 private
        }

    }
}
