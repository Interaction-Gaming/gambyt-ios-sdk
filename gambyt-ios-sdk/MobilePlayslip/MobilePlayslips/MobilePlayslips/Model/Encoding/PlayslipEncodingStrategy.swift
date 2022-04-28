//
//  PlayslipEncodingStrategy.swift
//  mal-ios
//
//  Created by Noah Karman on 5/10/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

protocol PlayslipEncodingStrategy {
    func encode(playslip: Playslip) throws -> Data?
}
