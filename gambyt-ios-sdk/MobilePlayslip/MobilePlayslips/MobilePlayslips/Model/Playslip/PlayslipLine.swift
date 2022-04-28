//
//  PlayslipLine.swift
//  mal-ios
//
//  Created by Aaron Rosenfeld (Work) on 4/16/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

typealias NumberPoolSelections = [String : [Int]]

struct PlayslipLine: Equatable {
    var selectedNumbersByPool: NumberPoolSelections
}
