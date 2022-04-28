//
//  Playslip.swift
//  mal-ios
//
//  Created by Aaron Rosenfeld (Work) on 4/16/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

struct Playslip: Equatable {
    let game: PlayslipGame
    var lines: [PlayslipLine]
    var drawCount: Int
    var multiplier: Bool
    let drawSequence: PlayslipDrawSequence
    let wagers: [PlayslipWager]
    let metadata: PlayslipMetadata
    
    var cost: Int? {
        get {
            let ctx = CostCalculationContext()
            var cost: Int = 0
            
            for wager in wagers {
                ctx.setStrategy(for: game, wagerType: wager.wagerType)
                if let c = ctx.calculateCost(playslip: self, wager: wager) {
                    cost += c
                }
            }
            
            return cost
        }
    }
    
    var isValid: Bool {
        get {
            let ctx = PlayslipValidationContext()
            ctx.setGame(self.game)
            return ctx.validate(playslip: self)
        }
    }
    
    public func encoded() throws -> Data? {
        var ctx = PlayslipEncodingContext()
        
        ctx.setStrategy(for: self.game)
        
        if let data = ctx.encode(playslip: self) {
            return data
        }
        
        return nil
    }
}
