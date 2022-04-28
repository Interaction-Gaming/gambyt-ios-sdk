//
//  MutliLineMultiDrawMultiplierCostCalculationStrategy.swift
//  mal-ios
//
//  Created by Noah Karman on 4/20/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

struct StandardWithMultiplierCostCalculationStrategy: CostCalculationStrategy {
    func calculateCost(playslip: Playslip, wager: PlayslipWager) -> Int? {
        guard playslip.lines.count > 0 else { return nil }
        return (wager.baseWagerValueInCents * playslip.lines.count * playslip.drawCount) + ((playslip.multiplier ? 100 : 0) * playslip.lines.count * playslip.drawCount)
    }
}
