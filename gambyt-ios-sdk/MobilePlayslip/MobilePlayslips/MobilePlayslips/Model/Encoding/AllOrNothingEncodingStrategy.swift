//
//  AllOrNothingEncodingStrategy.swift
//  mal-ios
//
//  Created by Noah Karman on 5/19/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

struct AllOrNothingEncodingStrategy: PlayslipEncodingStrategy {
    func encode(playslip: Playslip) throws -> Data? {
        let gameIdentifier = UInt8(8)
        let numberOfDraws = UInt8(playslip.drawCount)
        let multiplier = playslip.multiplier ? UInt8(1) : UInt8(0)
        
        var lineBytes: [UInt8] = []
        var wagerValueIndex: UInt8? = nil
        
        guard let line = playslip.lines.first else {
            throw BinaryEncodingException.encodingException("Unable to encode All Or Nothing playslip, playslip line innacessible")
        }
        
        if let wager = playslip.wagers.first, let wagerType = playslip.game.possibleWagers.first { $0.wagerType == wager.wagerType},
           let wagerTypeIndex = playslip.game.possibleWagers.firstIndex(of: wagerType),
           let valueIndex = playslip.game.possibleWagers[wagerTypeIndex].possibleWagerValuesInCents.firstIndex(of: wager.baseWagerValueInCents) {
            wagerValueIndex = UInt8(valueIndex + 1)
        }
        
        if let pool = line.selectedNumbersByPool[playslip.game.numberPools[0].identifier], pool.count == 12 {
            lineBytes = pool.map({ (num) -> UInt8 in
                return UInt8(num)
            })
        } else {
            throw BinaryEncodingException.encodingException("Unable to encode All Or Nothing playslip, drawNumbers innacessible")
        }
        
        guard let wagerValueindex = wagerValueIndex else {
            throw BinaryEncodingException.encodingException("Unable to encode All Or Nothing playslip, Wager info innacessible")
        }
        
        var playerIdBytes: [UInt8] = []
        
        if let id = playslip.metadata.userID {
            playerIdBytes = id.encoded
        }
        
        var dataBytes = playerIdBytes + [gameIdentifier, numberOfDraws, multiplier, wagerValueindex]
            dataBytes.append(contentsOf: lineBytes)
        
        return Data(dataBytes)
    }
}
