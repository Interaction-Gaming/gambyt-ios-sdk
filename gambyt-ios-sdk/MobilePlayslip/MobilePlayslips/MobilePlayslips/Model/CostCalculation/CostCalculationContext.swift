//
//  CostCalculationContext.swift
//  mal-ios
//
//  Created by Noah Karman on 4/22/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

class CostCalculationContext {
    var strategy: CostCalculationStrategy? = nil
    
    func setStrategy(for game: PlayslipGame, wagerType: PlayslipWagerType) {
        switch game.identifier {
        case .theNumbersGame:
            switch wagerType {
            case .standard, .box, .straight:
                strategy = StandardCostCalculationStrategy()
            case .combo:
                strategy = ComboCostCalculationStrategy()
            }
        case .powerball:
            strategy = StandardWithMultiplierCostCalculationStrategy()
        case .megabucksDoubler:
            strategy = StandardWithMultiplierCostCalculationStrategy()
        case .massCash:
            strategy = StandardCostCalculationStrategy()
        case .megaMillions:
            strategy = StandardWithMultiplierCostCalculationStrategy()
        case .luckyForLife:
            strategy = StandardCostCalculationStrategy()
        case .allOrNothing:
            strategy = RapidDrawCostCalculationStrategy()
        case .keno:
            strategy = RapidDrawCostCalculationStrategy()
        case .none:
            strategy = nil
        }
    }
    
    func calculateCost(playslip: Playslip, wager: PlayslipWager) -> Int? {
        return strategy?.calculateCost(playslip: playslip, wager: wager)
    }
}
