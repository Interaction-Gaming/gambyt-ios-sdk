//
//  PlayslipGame.swift
//  mal-ios
//
//  Created by Aaron Rosenfeld (Work) on 4/16/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

struct PlayslipGame: Decodable, Equatable {
    let maxLines: Int
    let multiDrawRange: PlayslipNumberRange
    let drawSequence: [PlayslipDrawSequence]
    let numberPools: [NumberPool]
    let possibleWagers: [PlayslipGameWagerOption]
    let name: String
    let identifier: DrawGameIdentifier
    let multiplier: PlayslipGameMultiplier?
    let gameBrandColor: String
    
    var hasWagerOptions: Bool {
        if possibleWagers.count == 1, let wagerOpt = possibleWagers.first, wagerOpt.possibleWagerValuesInCents.count == 1 {
            return false
        }
        return true
    }
}
