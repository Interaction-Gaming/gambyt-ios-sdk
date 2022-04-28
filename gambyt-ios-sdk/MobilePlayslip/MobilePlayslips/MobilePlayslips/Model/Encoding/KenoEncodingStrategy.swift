//
//  KenoEncodingStrategy.swift
//  mal-ios
//
//  Created by Noah Karman on 5/19/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

struct KenoEncodingStrategy: PlayslipEncodingStrategy {
    func encode(playslip: Playslip) throws -> Data? {
        let gameIdentifier = UInt8(7)
        let numberOfDraws = UInt8(playslip.drawCount)
        let multiplier = playslip.multiplier ? UInt8(1) : UInt8(0)
        
        var lineBytes: [UInt8] = []
        var drawNumberSelectionCount: UInt8? = nil
        var wagerValueIndex: UInt8? = nil
        
        guard let line = playslip.lines.first else {
            throw BinaryEncodingException.encodingException("Unable to encode Keno playslip, playslip line innacessible")
        }
        
        if let wager = playslip.wagers.first, let wagerType = playslip.game.possibleWagers.first { $0.wagerType == wager.wagerType},
           let typeIndex = playslip.game.possibleWagers.firstIndex(of: wagerType),
           let valueIndex = playslip.game.possibleWagers[typeIndex].possibleWagerValuesInCents.firstIndex(of: wager.baseWagerValueInCents) {
                wagerValueIndex = UInt8(valueIndex + 1)
        }
        
        if let pool = line.selectedNumbersByPool[playslip.game.numberPools[0].identifier], pool.count >= 1 {
            lineBytes = pool.map({ (num) -> UInt8 in
                return UInt8(num)
            })
            drawNumberSelectionCount = UInt8(pool.count)
        } else {
            throw BinaryEncodingException.encodingException("Unable to encode Keno playslip, drawNumbers innacessible")
        }
        
        guard let drawNumberCount = drawNumberSelectionCount, let wagerIndex = wagerValueIndex else {
            throw BinaryEncodingException.encodingException("Unable to encode Keno playslip, Wager info innacessible")
        }
        
        var playerIdBytes: [UInt8] = []
        
        if let id = playslip.metadata.userID {
            playerIdBytes = id.encoded
        }
        
        var dataBytes = playerIdBytes + [gameIdentifier, numberOfDraws, multiplier, wagerIndex, drawNumberCount]
        dataBytes.append(contentsOf: lineBytes)
        
        return Data(dataBytes)
    }
}
