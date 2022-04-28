//
//  NumberPool.swift
//  mal-ios
//
//  Created by Aaron Rosenfeld (Work) on 4/16/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

struct NumberPool: Decodable, Equatable {
    let selectableNumberRange: PlayslipNumberRange
    let selectableNumberCount: PlayslipNumberRange
    let isBonus: Bool
    let identifier: String
}
