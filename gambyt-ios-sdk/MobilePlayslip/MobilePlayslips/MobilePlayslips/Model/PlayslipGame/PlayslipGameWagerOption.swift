//
//  PlayslipGameWagerOption.swift
//  mal-ios
//
//  Created by Noah Karman on 5/3/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

struct PlayslipGameWagerOption: Decodable, Equatable {
    let wagerType: PlayslipWagerType
    let possibleWagerValuesInCents: [Int]
}
