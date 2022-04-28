//
//  TheNumbersGameEncodingStrategy.swift
//  mal-ios
//
//  Created by Noah Karman on 5/10/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

enum BinaryEncodingException: Error {
    case encodingException(String)
}

struct TheNumbersGameEncodingStrategy: PlayslipEncodingStrategy {
    
    let ENCODED_NULL = 255
    
    func encode(playslip: Playslip) throws -> Data? {
        
        let gameIdentifier = UInt8(1)
        let numberOfDraws = UInt8(Float(playslip.drawCount))
        var sequence: UInt8?
        
        switch playslip.drawSequence {
        case .mid:
            sequence = UInt8(1)
        case .eve:
            sequence = UInt8(2)
        case .both:
            sequence = UInt8(3)
        case .standard:
            sequence = nil
        }
        
        var nums: [Int] = []
        
        guard let singleLine = playslip.lines.first else {
            throw BinaryEncodingException.encodingException("Unable to encode The Numbers Game playslip, Playslip Line info innacessible")
        }
        
        playslip.game.numberPools.forEach { (numberPool) in
            let playslipSelection = singleLine.selectedNumbersByPool[numberPool.identifier]
            if let playslipSelection = playslipSelection, playslipSelection.count > 0 {
                nums.append(playslipSelection[0])
            } else {
                nums.append(ENCODED_NULL)
            }
        }
        
        if let sequence = sequence {
            let numOfWagers = UInt8(playslip.wagers.count)
            let wagers: [(valueIndex: UInt8, typeIndex: UInt8)] = try playslip.wagers.map { (wager) -> (valueIndex: UInt8, typeIndex: UInt8)? in
                if let wagerValue = playslip.game.possibleWagers.first { $0.possibleWagerValuesInCents.contains(wager.baseWagerValueInCents) },
                   let wagerType = playslip.game.possibleWagers.first { $0.wagerType == wager.wagerType},
                   let typeIndex = playslip.game.possibleWagers.firstIndex(of: wagerType),
                   let valueIndex = playslip.game.possibleWagers[typeIndex].possibleWagerValuesInCents.firstIndex(of: wager.baseWagerValueInCents) {
                    return (valueIndex: UInt8(valueIndex + 1), typeIndex: UInt8(typeIndex + 1))
                } else {
                    throw BinaryEncodingException.encodingException("Unable to encode The Numbers Game playslip, unable to decode all wager values")
                }
            }.compactMap { $0 }
            
            var playerIdBytes: [UInt8] = []
            
            if let id = playslip.metadata.userID {
                playerIdBytes = id.encoded
            }
            
            var data: [UInt8] = playerIdBytes + [gameIdentifier, numberOfDraws, sequence, UInt8(nums[0]), UInt8(nums[1]), UInt8(nums[2]), UInt8(nums[3]), numOfWagers]
            
            wagers.forEach { (w) in
                data.append(contentsOf: [w.valueIndex, w.typeIndex])
            }
            
            return Data(data)
            
        }
        throw BinaryEncodingException.encodingException("Unable to encode The Numbers Game Playslip, DrawSequence unavailable")
    }
}

