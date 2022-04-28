//
//  WinningNumbersStackView.swift
//  mal-ios
//
//  Created by Noah Karman on 5/7/20.
//  Copyright © 2020 Interaction Gaming. All rights reserved.
//

import UIKit

class WinningNumbersStackView: UIStackView {
    
    var animationView = LotteryAnimationView()

    var resultsPending = true {
        didSet {
            if resultsPending {
                showResultsPending()
            } else {
                showWinningNumbers()
            }
        }
    }
    
    var fetching = false {
        didSet {
            if fetching {
                showLoading()
            } else {
                showWinningNumbers()
            }
        }
    }
    
    private var areSubviewsHidden: Bool = false {
        didSet {
            self.arrangedSubviews.forEach { (view) in
                view.isHidden = self.areSubviewsHidden
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        addSubViewAndFillParent(animationView)
        
        animationView.loopMode = .loop
        animationView.isHidden = true
    }
    
    private func loopAnimation(_ animation: LotteryAnimation) {
        
        self.arrangedSubviews.forEach { (view) in
            view.isHidden = true
        }
        
        self.animationView.animation = animation
        
        self.areSubviewsHidden = true
        self.animationView.isHidden = false
        self.animationView.play(completion: nil)
    }

    private func showResultsPending() {
        loopAnimation(.resultsPending)
    }
    
    private func showLoading() {
        loopAnimation(.loading)
    }
    
    private func showWinningNumbers() {
        self.animationView.isHidden = true
        self.areSubviewsHidden = false
        self.animationView.stop()
    }
}
