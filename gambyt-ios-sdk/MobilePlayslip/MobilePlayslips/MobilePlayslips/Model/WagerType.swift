//
//  WagerType.swift
//  mal-ios
//
//  Created by Aaron Rosenfeld (Work) on 4/16/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

enum WagerType: String, Decodable, Equatable {
    case standard
    case straight
    case box
    case combo
}
