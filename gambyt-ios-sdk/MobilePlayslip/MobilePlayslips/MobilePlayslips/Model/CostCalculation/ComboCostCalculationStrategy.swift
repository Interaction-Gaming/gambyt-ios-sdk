//
//  ComboCostCalculationStrategy.swift
//  mal-ios
//
//  Created by Noah Karman on 4/20/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

struct ComboCostCalculationStrategy: CostCalculationStrategy {
    func calculateCost(playslip: Playslip, wager: PlayslipWager) -> Int? {
        
        guard playslip.lines.count == 1, let line = playslip.lines.first else { return nil }
        
        var numbers: [Int] = []
        for numberPool in line.selectedNumbersByPool {
            if numberPool.value.count == 1 {
                numbers.append(numberPool.value[0])
            }
        }
        guard numbers.count > 0 else { return nil }
        
        return uniquePermutationsCount(numbers: numbers) * wager.baseWagerValueInCents * playslip.drawCount
    }
    
     private func uniquePermutationsCount(numbers: [Int]) -> Int {
        var repeatedNumbers = [Int : Int]()
        for key in numbers {
            if let numberOfRepeats = repeatedNumbers[key] {
                repeatedNumbers[key] = numberOfRepeats + 1
            } else {
                repeatedNumbers[key] = 1
            }
        }
        var denominator = 1
        for repeatedNum in repeatedNumbers {
            denominator = denominator * factorial(of: repeatedNum.value)
        }
        return factorial(of: numbers.count)/denominator
    }
    
    private func factorial(of num: Int) -> Int {
        if num == 1 {
            return 1
        } else {
            return num * factorial(of:num - 1)
        }
    }
}
