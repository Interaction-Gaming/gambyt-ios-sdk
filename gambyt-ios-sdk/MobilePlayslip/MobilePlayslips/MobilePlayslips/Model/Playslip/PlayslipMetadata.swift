//
//  PlayslipMetadata.swift
//  mal-ios
//
//  Created by Aaron Rosenfeld (Work) on 4/16/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

enum EncodedUserIdType: UInt8, Equatable {
    case playerId = 0b00000000
    case deviceId = 0b00000001
}

struct PlayslipUserIdMetadata: Equatable {
    let type: EncodedUserIdType
    let id: String
    
    var encoded: [UInt8] {
        get {
            let encodedId = id.replacingOccurrences(of: "-", with: "").data(using: .ascii)
            
            if let encodedId = encodedId {
                let idBytes = [UInt8](encodedId)
                return [type.rawValue, UInt8(idBytes.count)] + idBytes
            }
            
            return []
        }
    }
}

struct PlayslipMetadata: Equatable {
    let createdAt: Date
    let userID: PlayslipUserIdMetadata?
    var scannedAt: Date?
}
