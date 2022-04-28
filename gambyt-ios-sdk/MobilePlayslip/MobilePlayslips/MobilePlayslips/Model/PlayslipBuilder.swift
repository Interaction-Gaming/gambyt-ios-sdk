//
//  PlayslipBuilder.swift
//  mal-ios
//
//  Created by Noah Karman on 6/16/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import Foundation

class PlayslipBuilder {
    var game: PlayslipGame? = nil
    var wagers: [PlayslipWager] = []
    var lines: [PlayslipLine] = []
    var drawSequence: PlayslipDrawSequence?
    var drawCount: Int = 1
    var multiplier = false
    var idMetadata: PlayslipUserIdMetadata?
    var baseWagerValue: Int?
    
    var workingCostInCents: Int? {
        get {
            if let drawSequence = drawSequence, let game = game {
                return Playslip(game: game, lines: lines, drawCount: drawCount, multiplier: multiplier, drawSequence: drawSequence, wagers: wagers, metadata: PlayslipMetadata(createdAt: Date(), userID: idMetadata, scannedAt: nil)).cost
            }
            return nil
        }
    }
    
    @discardableResult
    func withGame(_ game: PlayslipGame) -> PlayslipBuilder {
        self.game = game
        
        if game.drawSequence.count == 1 {
            self.drawSequence = game.drawSequence.first
        }
        
        if !game.hasWagerOptions, let wager = game.possibleWagers.first, let wagerValue = wager.possibleWagerValuesInCents.first {
            self.wagers = [PlayslipWager(wagerType: wager.wagerType, baseWagerValueInCents: wagerValue)]
        }
        
        return self
    }
    
    @discardableResult
    func addLine(_ line: PlayslipLine) -> PlayslipBuilder {
        if game?.maxLines == 1 {
            lines = [line]
            return self
        }
        
        lines.append(line)
        return self
    }
    
    @discardableResult
    func addWager(_ wager: PlayslipWager) -> PlayslipBuilder {
        if game?.identifier == DrawGameIdentifier.theNumbersGame {
            wagers.append(wager)
            return self
        }
        
        wagers = [wager]
        return self
    }
    
    @discardableResult
    func removeLine(_ line: PlayslipLine) -> PlayslipBuilder {
        if let index = lines.firstIndex(of: line) {
            lines.remove(at: index)
        }
        return self
    }
    
    @discardableResult
    func editLine(oldLine: PlayslipLine, editedLine: PlayslipLine) -> PlayslipBuilder {
        if let index = lines.firstIndex(of: oldLine) {
            lines.replaceSubrange(index...index, with: [editedLine])
        }
        return self
    }
    
    @discardableResult
    func withMultiplier(_ multiplier: Bool) -> PlayslipBuilder {
        self.multiplier = multiplier
        return self
    }
    
    @discardableResult
    func withDrawCount(_ drawCount: Int) -> PlayslipBuilder {
        self.drawCount = drawCount
        return self
    }
    
    @discardableResult
    func withUserIDMetaData(id: String, idType: EncodedUserIdType) -> PlayslipBuilder {
        self.idMetadata = PlayslipUserIdMetadata(type: idType, id: id)
        return self
    }
    
    func build() -> Playslip? {
        guard let game = game, let drawSequence = drawSequence else { return nil }
        return Playslip(game: game, lines: lines, drawCount: drawCount, multiplier: multiplier, drawSequence: drawSequence, wagers: wagers, metadata: PlayslipMetadata(createdAt: Date(), userID: idMetadata, scannedAt: nil))
    }
}
