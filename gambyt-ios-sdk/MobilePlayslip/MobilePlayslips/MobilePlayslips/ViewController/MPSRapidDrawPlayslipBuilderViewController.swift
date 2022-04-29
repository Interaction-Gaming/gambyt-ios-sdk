//
//  MPSRapidDrawPlayslipBuilderViewController.swift
//  mal-ios
//
//  Created by Noah Karman on 7/12/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import UIKit
import ReSwift

class MPSRapidDrawPlayslipBuilderViewController: UIViewController, NumberGridSelectionDelegate {
    struct Props: Equatable {
        var game: PlayslipGame?

        init(state: AppState) {

        }
    }
    
    var selectedNumbersByPool: NumberPoolSelections = [:] {
        didSet {
            var selectionsMaxed: [Bool] = []
            selectedNumbersByPool.forEach { (pair) in
                let identifier = pair.key
                let selections = pair.value
                
                if let numberPool = builder.game?.numberPools.first(where: { $0.identifier == identifier }) {
                    selectionsMaxed.append(numberPool.selectableNumberCount.min <= selections.count)
                }
            }
            
            addLineEnabled = selectionsMaxed.allSatisfy { $0 }
        }
    }
    
    var addLineEnabled: Bool = false {
        didSet {
            addLineButton?.isEnabled = addLineEnabled
            addLineButton?.backgroundColor = addLineEnabled ? .lotteryNavy : .lightGray
        }
    }
    
    var selectedNumbers: [Int] = []  {
        didSet {
            // rapid draw have singular number pool
            if let numberPool = builder.game?.numberPools.first {
                addLineEnabled = numberPool.selectableNumberCount.min <= selectedNumbers.count
            }
        }
    }
    
    @IBOutlet weak var kenoGridContainer: UIView?
    @IBOutlet weak var aonGridContainer: UIView?
    @IBOutlet weak var addLineButton: DesignableButton?
    
    weak var kenoNumberGrid: MPSNumberGridCollectionViewController?
    weak var aonNumberGrid: MPSAllOrNothingNumberGridCollectionViewController?
    var deletionDelegates: [NumberGridDeletionDelegate] = []

    var builder: PlayslipBuilder = PlayslipBuilder()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        appStore.subscribe(self) {
            $0.select(Props.init)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        deletionDelegates = []
        
        appStore.unsubscribe(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Rapid draw games have a singular number pool
        if let dest = segue.destination as? MPSAllOrNothingNumberGridCollectionViewController {
            aonNumberGrid = dest
            aonNumberGrid?.selectionDelegate = self
            self.deletionDelegates.append(dest as NumberGridDeletionDelegate)
        } else if let dest = segue.destination as? MPSNumberGridCollectionViewController {
            kenoNumberGrid = dest
            kenoNumberGrid?.selectionDelegate = self
            self.deletionDelegates.append(dest as NumberGridDeletionDelegate)
        } else if let dest = segue.destination as? MPSRapidDrawAddOnViewController {
            dest.playslipBuilder = builder
        }
    }
    
    func numbersSelected(selections: [Int], numberPoolIdentifier: String) {
        self.selectedNumbers = selections
    }
    
    @IBAction func clearSelections(_ sender: Any) {
        self.selectedNumbers = []
        
        deletionDelegates.forEach { (delegate) in
            delegate.clear()
        }
    }
    
    @IBAction func addLinePressed(_ sender: Any) {
        guard let pool = builder.game?.numberPools.first else { return }
        
        builder.addLine(PlayslipLine(selectedNumbersByPool: [pool.identifier: selectedNumbers]))
    }
    
    func setupForGame(_ game: PlayslipGame) {
        builder.withGame(game)
        self.title = game.name
        
        if game.identifier == .some(.keno) {
            kenoGridContainer?.isHidden = false
            aonGridContainer?.isHidden = true
            
            kenoNumberGrid?.numberPool = game.numberPools.first
        } else if game.identifier == .some(.allOrNothing) {
            kenoGridContainer?.isHidden = true
            aonGridContainer?.isHidden = false
            
            aonNumberGrid?.numberPool = game.numberPools.first
        }
    }
}

extension MPSRapidDrawPlayslipBuilderViewController: StoreSubscriber {
    func newState(state: Props) {
        if builder.game != state.game, let game = state.game {
           setupForGame(game)
        }
    }
}
