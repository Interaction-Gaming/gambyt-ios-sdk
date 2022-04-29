//
//  MPSNumberGridCollectionViewHeader.swift
//  mal-ios
//
//  Created by Noah Karman on 5/28/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import UIKit

protocol NumberGridHeaderDelegate: NSObject {
    func autoFill()
}

protocol NumberGridHeaderCounterDelegate: NSObject {
    func numbersSelected(count: Int)
}

@IBDesignable
class MPSNumberGridCollectionViewHeader: UICollectionReusableView, NumberGridHeaderCounterDelegate {
    
    @IBInspectable var autoFillEnabled: Bool = true
    @IBInspectable var instructionTextPrefix: String?
    
    weak var delegate: NumberGridHeaderDelegate?
    @IBOutlet weak var autoFillIcon: UIImageView?
    @IBOutlet weak var label: UILabel?
    @IBOutlet weak var autoFillButton: UIButton?
    @IBOutlet weak var numberCountLabel: UILabel?
    
    var numberOfSelections: Int? {
        didSet {
            if let number = numberOfSelections {
                let prefix = instructionTextPrefix ?? "Select"
                label?.text = "\(prefix) \(number) numbers"
            }
        }
    }
    
    func setup() {
        autoFillIcon?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(autoFillIconPressed)))
        autoFillIcon?.isUserInteractionEnabled = true
        
        autoFillButton?.isEnabled = autoFillEnabled
        autoFillButton?.isHidden = !autoFillEnabled
        autoFillIcon?.isHidden = !autoFillEnabled
        
        numberCountLabel?.isHidden = autoFillEnabled
    }
    
    @objc func autoFillIconPressed() {
        if autoFillEnabled {
            delegate?.autoFill()
        }
    }
    
    @IBAction func autoFill(_ sender: Any) {
        if autoFillEnabled {
            delegate?.autoFill()
        }
    }
    
    func numbersSelected(count: Int) {
        self.numberCountLabel?.text = "\(String(count)) selected"
    }
}
