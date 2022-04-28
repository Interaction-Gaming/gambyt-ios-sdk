//
//  PlayslipValidationContext.swift
//  mal-ios
//
//  Created by Aaron Rosenfeld (Work) on 4/23/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

class PlayslipValidationContext {
    
    var game: PlayslipGame? = nil
    
    func setGame(_ game: PlayslipGame) {
        self.game = game
    }
    
    func validate(playslip: Playslip) -> Bool {
        guard let game = game else { return false }
        
        let numberOfLinesIsValid = playslip.lines.count <= game.maxLines && playslip.lines.count > 0
        
        var wagerTypeIsValid = true
        var wagerValueIsValid = true
        let possibleWagers = playslip.game.possibleWagers.map { (possibleWager) -> PlayslipWagerType in
            possibleWager.wagerType
        }
        for wager in playslip.wagers {
            if !possibleWagers.contains(wager.wagerType) {
                wagerTypeIsValid = false
            } else {
                if let possibleWager = game.possibleWagers.first(where: { (wagerOption) -> Bool in
                    wagerOption.wagerType == wager.wagerType
                }), !possibleWager.possibleWagerValuesInCents.contains(wager.baseWagerValueInCents) {
                    wagerValueIsValid = false
                }
            }
        }
                
        let numberOfDrawsIsValid = playslip.drawCount >= game.multiDrawRange.min &&
                                   playslip.drawCount <= game.multiDrawRange.max
        
        let gameIdentifierIsValid = playslip.game.identifier != .none
        
        let multiplierStatusIsValid = !(playslip.multiplier && game.multiplier == nil)
        
        var linesAreValid = true
        for line in playslip.lines {
            let multiplierNumberCountExclusions = game.multiplier?.exclusions ?? []
            if !validatePlayslipLine(line: line, game: game, multiplierNumberCountExclusions: multiplierNumberCountExclusions, multiplier: playslip.multiplier) {
                linesAreValid = false
                break
            }
        }
        
        return numberOfLinesIsValid && wagerTypeIsValid && numberOfDrawsIsValid && gameIdentifierIsValid && multiplierStatusIsValid && linesAreValid && wagerValueIsValid
    }
    
    func validatePlayslipLine(line: PlayslipLine, game: PlayslipGame, multiplierNumberCountExclusions: [Int], multiplier: Bool) -> Bool {
        
        var numberOfSelectedNumbersIsValid: [Bool] = []
        var noRepeatedNumbersInAPoolIsValid: [Bool] = []
        var numbersAreValid: [Bool] = []
        var drawNumberCountExclusionsAreValid: [Bool] = []
        var failedToUnwrapLineOrNumberPool: [Bool] = []
        line.selectedNumbersByPool.keys.forEach { (key) in
            if let numbers = line.selectedNumbersByPool[key],
               let numberPool = game.numberPools.first(where: { (numberPool) -> Bool in
                numberPool.identifier == key
               }) {
                numberOfSelectedNumbersIsValid.append(numbers.count >= numberPool.selectableNumberCount.min &&
                                                        numbers.count <= numberPool.selectableNumberCount.max)
                
                noRepeatedNumbersInAPoolIsValid.append(
                    Array(Set(numbers.filter({ (i: Int) in numbers.filter({ $0 == i }).count > 1}))).isEmpty
                )
                
                var numbersForPoolAreValid = true
                for number in numbers {
                    if !(number >= numberPool.selectableNumberRange.min && number <= numberPool.selectableNumberRange.max) {
                        numbersForPoolAreValid = false
                    }
                }
                numbersAreValid.append(numbersForPoolAreValid)
                
                drawNumberCountExclusionsAreValid.append(!(multiplierNumberCountExclusions.contains(numbers.count) && multiplier))
            } else {
                failedToUnwrapLineOrNumberPool.append(true)
            }
        }
        
        return !numberOfSelectedNumbersIsValid.contains(false) &&
            !noRepeatedNumbersInAPoolIsValid.contains(false) &&
            !numbersAreValid.contains(false) &&
            !drawNumberCountExclusionsAreValid.contains(false) &&
            !failedToUnwrapLineOrNumberPool.contains(true)
    }
    
}
