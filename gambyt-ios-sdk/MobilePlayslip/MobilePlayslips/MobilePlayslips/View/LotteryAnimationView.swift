//
//  LotteryAnimationView.swift
//  mal-ios
//
//  Created by Noah Karman on 5/7/20.
//  Copyright © 2020 Interaction Gaming. All rights reserved.
//

import UIKit
import Lottie

enum LotteryAnimation: String {
    case numbersFadeInLight = "number_ball_white_outline"
    case numbersFadeInDark = "number_ball_black_outline"
    case numberBallBlackFill = "number_ball_black_fill"
    case numberBallWhiteFill = "number_ball_white_fill"
    case numberRectableLoad = "number_rectangle_loading"
    case loading = "number_ball_loading"
    case resultsPending = "results_pending"
    case claimApproved = "claim_approved"
    case EI_Arrow_Entrance = "ei_arrow_entrance"
    case EI_Arrow_Idle = "ei_arrow_idle"
    case EI_Part_1 = "ei_part_1"
    case EI_Part_2_Entrance = "ei_part_2_entrance"
    case EI_Part_2_Idle = "ei_part_2_idle"
    case EI_Part_3_Entrance = "ei_part_3_entrance"
    case EI_Part_3_Idle = "ei_part_3_idle"
    case EI_Part_4_Entrance = "ei_part_4_entrance"
    case EI_Part_4_Idle = "ei_part_4_idle"
    case EI_Part_5_Entrance = "ei_part_5_entrance"
    case EI_Part_5_Idle = "ei_part_5_idle"
    case documentSending = "document_sending"
    case documentSuccess = "document_success"
    case documentFailed = "document_failed"
    case instantGamesLeftSparkle = "instant_games_left_sparkle"
    case instantGamesRightSparkle = "instant_games_right_sparkle"
}

class LotteryAnimationView: UIView {
    let animationView: AnimationView
    var hidesAfterAnimating = true
    
    var animation: LotteryAnimation? {
        didSet {
            if let animation = self.animation {
                self.animationView.animation = Animation.named(animation.rawValue)
            }
        }
    }
    
    var loopMode: LottieLoopMode {
        set {
            animationView.loopMode = newValue
        }
        
        get {
            return animationView.loopMode
        }
    }
    
    init(animationName: LotteryAnimation) {
        self.animationView = AnimationView(name: animationName.rawValue)
        super.init(frame: .zero)
        addSubViewAndFillParent(animationView)
    }
    
    init() {
        self.animationView = AnimationView()
        super.init(frame: .zero)
        addSubViewAndFillParent(animationView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stop() {
        guard animationView.isAnimationPlaying else { return }
        animationView.stop()
    }
    
    func play(completion: LottieCompletionBlock?) {
        guard !animationView.isAnimationPlaying else { return }
        animationView.play(completion: completion)
    }
    
    func play(toFrame frame: CGFloat, completion: LottieCompletionBlock?) {
        guard !animationView.isAnimationPlaying else { return }
        animationView.play(fromFrame: 0.0, toFrame: frame, loopMode: .playOnce, completion: completion)
    }
    
    func setColor(_ color: UIColor) {
        let rgba = color.rgba
        let lottieColor = Color(r: Double(rgba.red), g: Double(rgba.green), b: Double(rgba.blue), a: Double(rgba.alpha))
        
        let fillKeypath = AnimationKeypath(keypath: "**.Fill 1.Color")
        let redValueProvider = ColorValueProvider(lottieColor)
        animationView.setValueProvider(redValueProvider, keypath: fillKeypath)
    }
}
