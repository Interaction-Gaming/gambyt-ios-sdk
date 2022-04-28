//
//  PlayslipEncodingContext.swift
//  mal-ios
//
//  Created by Noah Karman on 5/10/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation
import LottoLog

struct PlayslipEncodingContext {
    var strategy: PlayslipEncodingStrategy? = nil
    
    mutating func setStrategy(for game: PlayslipGame) {
        switch game.identifier {
        case .theNumbersGame:
            strategy = TheNumbersGameEncodingStrategy()
        case .megabucksDoubler:
            strategy = MegabucksDoublerEncodingStrategy()
        case .massCash:
            strategy = MassCashEncodingStrategy()
        case .luckyForLife:
            strategy = LuckyForLifeEncodingStrategy()
        case .powerball, .megaMillions:
            strategy = PowerballMegaMillionsEncodingStrategy()
        case .keno:
            strategy = KenoEncodingStrategy()
        case .allOrNothing:
            strategy = AllOrNothingEncodingStrategy()
        default:
            strategy = nil
        }
    }
    
    func encode(playslip: Playslip) -> Data? {
        do {
            return try strategy?.encode(playslip: playslip)
        } catch {
            LottoLog.standard.error(msg: "Failed to encode playslip with BinaryEncodingException %s", args: error.localizedDescription)
            return nil
        }
    }
}
