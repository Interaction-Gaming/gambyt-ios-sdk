//
//  PowerballMegaMillionsEncodingStrategy.swift
//  mal-ios
//
//  Created by Noah Karman on 5/18/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

struct PowerballMegaMillionsEncodingStrategy: PlayslipEncodingStrategy {
    func encode(playslip: Playslip) throws -> Data? {
        let gameIdentifier = playslip.game.identifier == .powerball ? UInt8(5) : UInt8(6)
        let numberOfDraws = UInt8(playslip.drawCount)
        let numberOfLines = UInt8(playslip.lines.count)
        
        var lineBytes: [UInt8] = []
        
        for line in playslip.lines {
            if let pool = line.selectedNumbersByPool[playslip.game.numberPools[0].identifier],
               let bonusPool = line.selectedNumbersByPool[playslip.game.numberPools[1].identifier], pool.count >= 5, bonusPool.count == 1 {
                let n1 = UInt8(pool[0])
                let n2 = UInt8(pool[1])
                let n3 = UInt8(pool[2])
                let n4 = UInt8(pool[3])
                let n5 = UInt8(pool[4])
                let n6 = UInt8(pool[5])
                let b1 = UInt8(bonusPool[0])
                
                lineBytes.append(contentsOf: [n1, n2, n3, n4, n5, n6, b1])
            } else {
                let gameStr = playslip.game.identifier == .powerball ? "Powerball" : "Mega Millions"
                throw BinaryEncodingException.encodingException("Unable to encode \(gameStr) playslip, drawNumbers innacessible")
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
