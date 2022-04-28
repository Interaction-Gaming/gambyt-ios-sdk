//
//  PlayslipGameMultiplier.swift
//  mal-ios
//
//  Created by Aaron Rosenfeld (Work) on 4/16/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

struct PlayslipGameMultiplier: Decodable, Equatable {
    let exclusions: [Int]
    let multiplierName: String?
    let multiplierHelpText: String?
}
