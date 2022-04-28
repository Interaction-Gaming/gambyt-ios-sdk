//
//  MegabucksDoublerEncodingStrategy.swift
//  mal-ios
//
//  Created by Noah Karman on 5/18/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

struct MegabucksDoublerEncodingStrategy: PlayslipEncodingStrategy {
    func encode(playslip: Playslip) throws -> Data? {
        let gameIdentifier = UInt8(2)
        let numberOfDraws = UInt8(playslip.drawCount)
        let numberOfLines = UInt8(playslip.lines.count)
        
        var lineBytes: [UInt8] = []
        
        for line in playslip.lines {
            if let pool = line.selectedNumbersByPool[playslip.game.numberPools[0].identifier], pool.count == 6 {
                let n1 = UInt8(pool[0])
                let n2 = UInt8(pool[1])
                let n3 = UInt8(pool[2])
                let n4 = UInt8(pool[3])
                let n5 = UInt8(pool[4])
                let n6 = UInt8(pool[5])
                
                lineBytes.append(contentsOf: [n1, n2, n3, n4, n5, n6])
            } else {
                throw BinaryEncodingException.encodingException("Unable to encode MegaBucksDoubler Playslip, drawNumbers innacessible")
            }
        }
        
        var playerIdBytes: [UInt8] = []
        
        if let id = playslip.metadata.userID {
            playerIdBytes = id.encoded
        }
        
        var dataBytes = playerIdBytes + [gameIdentifier, numberOfDraws, numberOfLines]
            dataBytes.append(contentsOf: lineBytes)
        
        return Data(dataBytes)
    }
}
