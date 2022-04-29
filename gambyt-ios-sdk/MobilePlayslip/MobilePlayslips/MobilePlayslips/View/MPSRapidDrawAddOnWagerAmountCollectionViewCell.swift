//
//  MPSRapidDrawAddOnWagerAmountCollectionViewCell.swift
//  mal-ios
//
//  Created by Noah Karman on 7/26/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import UIKit

class MPSRapidDrawAddOnWagerAmountCollectionViewCell: UICollectionViewCell {
    var wagerAmount: Int? {
        didSet {
            if let amount = wagerAmount {
                let costInCents = Double(amount) / 100.0
                amountLabel?.text = costInCents.formatDollarsString(fractionDigits: 0)
            }
        }
    }
    
    var isActiveWager: Bool = false {
        didSet {
            self.backgroundColor = isActiveWager ? .lightGray : .white
        }
    }
    
    @IBOutlet weak var amountLabel: UILabel?
}
