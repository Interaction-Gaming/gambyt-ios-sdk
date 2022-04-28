//
//  PlayslipWager.swift
//  mal-ios
//
//  Created by Noah Karman on 5/3/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

struct PlayslipWager: Decodable, Equatable {
    let wagerType: PlayslipWagerType
    let baseWagerValueInCents: Int
}
