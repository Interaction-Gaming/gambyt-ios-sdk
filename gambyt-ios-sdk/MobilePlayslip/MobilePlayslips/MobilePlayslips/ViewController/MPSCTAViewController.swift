//
//  MobilePlaySlipsCTAViewController.swift
//  mal-ios
//
//  Created by Noah Karman on 5/24/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import UIKit

protocol MobilePlayslipCTADelegate: UIViewController {
    func buildPlayslipPressed()
}

class MPSCTAViewController: UIViewController {
    
    var delegate: MobilePlayslipCTADelegate?
    
    @IBAction func buildPlayslipButton(_ sender: Any) {
        delegate?.buildPlayslipPressed()
    }
}
