//
//  AllOrNothingMPSNumberGridCollectionViewController.swift
//  mal-ios
//
//  Created by Noah Karman on 7/12/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import UIKit

class MPSAllOrNothingNumberGridCollectionViewController: MPSNumberGridCollectionViewController {
    override var cellSize: CGSize {
        get {
            let sizeClass = self.traitCollection.horizontalSizeClass
            
            switch sizeClass {
            case .compact:
                
                if self.view.frame.width <= 375 {
                    return CGSize(width: 50, height: 50)
                }
                
                if self.view.frame.width > 400.0 {
                    return CGSize(width: 66, height: 66)
                }
                
                return CGSize(width: 50, height: 50)
            case .regular:
                return CGSize(width: 100, height: 100)
            default:
                return CGSize(width: 36, height: 36)
            }
        }
    }
}


