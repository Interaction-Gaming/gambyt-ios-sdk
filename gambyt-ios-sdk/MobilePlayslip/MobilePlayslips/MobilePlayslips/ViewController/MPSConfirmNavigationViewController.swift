//
//  MobilePlayslipsConfirmNavigationViewController.swift
//  mal-ios
//
//  Created by Noah Karman on 6/22/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation
import UIKit

protocol ConfirmNavigationDelegate: UIViewController {
    func confirm()
}

class MPSConfirmNavigationViewController: UIViewController {
    
    weak var delegate: ConfirmNavigationDelegate?
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func leave(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.confirm()
        }
    }
}
