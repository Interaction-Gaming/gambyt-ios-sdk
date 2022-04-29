//
//  UIColor+extension.swift
//  mal-ios
//
//  Created by Noah Karman on 6/7/19.
//  Copyright © 2019 Interaction Gaming. All rights reserved.
//

import Foundation
import UIColor_Hex_Swift

extension UIColor {
    func disabled() -> UIColor {
        return self.withAlphaComponent(0.5)
    }
    
    class var lotteryNavy: UIColor {
        get {
            return UIColor("#173E67")
        }
    }

    class var lotteryLightNavy: UIColor {
        get {
            return UIColor("#E8F0F9")
        }
    }

    class var lotteryLightTeal: UIColor {
        get {
            return UIColor("#E2FCFA")
        }
    }

    class var lotteryDarkerTeal: UIColor {
        get {
            return UIColor("#1E7E74")
        }
    }

    class var lotteryDarkTeal: UIColor {
        get {
            return UIColor("#58C2B7")
        }
    }
    
    class var lotteryMidTeal: UIColor {
        return UIColor("#a8f1eb")
    }
    
    class var lotteryLightGray: UIColor {
        return UIColor("#f2f2f6")
    }
    
    class var lotteryTableCellLight: UIColor {
        return UIColor("#d8eae8")
    }
    
    class var lotteryTableCellDark: UIColor {
        return UIColor("#a7ddd7")
    }
    
    class var lotteryTeal: UIColor {
        get {
            return UIColor("#7FCBC4")
        }
    }
    
    class var lotteryYellow: UIColor {
        get {
            return UIColor("#FFD97A")
        }
    }
    
    class var lotteryOrange: UIColor {
        get {
            return UIColor("#F16419")
        }
    }
    
    class var lotteryUnselectedPageIndicator: UIColor {
        get {
            return UIColor("#7fcbc4")
        }
    }
    
    class var playslipLightGray: UIColor {
        get {
            return UIColor("#d9dcdf")
        }
    }
    
    class var playslipDisabledText: UIColor {
        get {
            return UIColor("#bfbfbf")
        }
    }
    
    class var kenoBlack: UIColor {
        get {
            return UIColor(displayP3Red: 38/255, green: 38/255, blue: 38/255, alpha: 1.0)
        }
    }
    
    class var allOrNothingYellow: UIColor {
        get {
            return UIColor(displayP3Red: 255.0/255, green: 217.0/255, blue: 130.0/255, alpha: 1.0)
        }
    }
    
    class var kenoYellow: UIColor {
        get {
            return UIColor(displayP3Red: 248.0/255, green: 248.0/255, blue: 0.0, alpha: 1.0)
        }
    }
    
    class var darkPurple: UIColor {
        get {
            return UIColor(displayP3Red: 37.0/255, green: 19.0/255, blue: 37.0/255, alpha: 1.0)
        }
    }
    
    class var lotteryText: UIColor {
        get {
            return UIColor("#0f1821")
        }
    }

    class var dangerRed: UIColor {
        get {
            return UIColor("#E60017")
        }
    }


    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
}
