//
//  CostCalculationStrategy.swift
//  mal-ios
//
//  Created by Noah Karman on 4/20/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

protocol CostCalculationStrategy {
    func calculateCost(playslip: Playslip, wager: PlayslipWager) -> Int?
}

