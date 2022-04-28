//
//  MPSDrawGameAddOnViewController.swift
//  mal-ios
//
//  Created by Noah Karman on 7/16/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import UIKit

class MPSDrawGameAddOnViewController: MPSAddOnViewController {
    
    @IBOutlet weak var megabucksMultiplierView: UIView?
    
    override func configureMultiplierView() {
        guard let game = playslipBuilder.game else { return }
        
        // Megabucks Doubler has it's own, disabled Multiplier state.
        multiplierView?.isHidden = game.multiplier == nil || game.identifier == .megabucksDoubler
        megabucksMultiplierView?.isHidden = game.identifier != .megabucksDoubler
        
        if let multiplierName = game.multiplier?.multiplierName, let helpText = game.multiplier?.multiplierHelpText {
            multiplierTitleLabel?.text = multiplierName
            multiplierSubtitleLabel?.text = helpText
        }
    }
}
