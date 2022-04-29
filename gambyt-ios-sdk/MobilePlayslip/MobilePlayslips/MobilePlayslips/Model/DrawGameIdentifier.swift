//
//  DrawGameIdentifier.swift
//  mal-ios
//
//  Created by Nick Peterson on 5/1/20.
//  Copyright © 2020 Nick Peterson. All rights reserved.
//

import Foundation
import UIKit

public enum DrawGameIdentifier: String, Codable, Equatable {
    case powerball = "powerball"
    case megabucksDoubler = "megabucks_doubler"
    case massCash = "mass_cash"
    case megaMillions = "mega_millions"
    case luckyForLife = "lucky_for_life"
    case theNumbersGame = "the_numbers_game"
    case allOrNothing = "all_or_nothing"
    case keno = "keno"
    case none

    func description() -> String {
        return self.rawValue
    }

    func displayName() -> String {
        switch self {
        case .powerball:
            return "Powerball"
        case .megabucksDoubler:
            return "Megabucks Doubler"
        case .massCash:
            return "Mass Cash"
        case .megaMillions:
            return "Mega Millions"
        case .luckyForLife:
            return "Lucky for Life"
        case .theNumbersGame:
            return "The Numbers Game"
        case .allOrNothing:
            return "All or Nothing"
        case .keno:
            return "Keno"
        case .none:
            return ""
        }
    }

    func headerColor() -> UIColor {
        switch self {
        case .powerball:
            return UIColor(displayP3Red: 235/255, green: 20/255, blue: 20/255, alpha: 1.0)
        case .megabucksDoubler:
            return UIColor(displayP3Red: 255/255, green: 143/255, blue: 0/255, alpha: 1.0)
        case .massCash:
            return UIColor(displayP3Red: 168/255, green: 175/255, blue: 255/255, alpha: 1.0)
        case .megaMillions:
            return UIColor(displayP3Red: 36/255, green: 64/255, blue: 143/255, alpha: 1.0)
        case .luckyForLife:
            return UIColor(displayP3Red: 4/255, green: 120/255, blue: 65/255, alpha: 1.0)
        case .theNumbersGame:
            return UIColor(displayP3Red: 118/255, green: 160/255, blue: 212/255, alpha: 1.0)
        case .allOrNothing:
            return UIColor(displayP3Red: 80/255, green: 151/255, blue: 49/255, alpha: 1.0)
        case .keno:
            return UIColor(displayP3Red: 255/255, green: 242/255, blue: 2/255, alpha: 1.0)
        case .none:
            return .clear
        }
    }

    func headerFontColor() -> UIColor {
        switch self {
        case .powerball, .megaMillions, .luckyForLife:
            return .white
        default:
            return UIColor(displayP3Red: 15/255, green: 24/255, blue: 33/255, alpha: 1.0)
        }
    }
}
