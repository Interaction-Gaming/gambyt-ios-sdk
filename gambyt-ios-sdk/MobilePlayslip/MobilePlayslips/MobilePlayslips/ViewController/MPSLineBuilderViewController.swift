//
//  MobilePlayslipLineBuilderViewController.swift
//  mal-ios
//
//  Created by Noah Karman on 5/25/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import UIKit

class MPSLineBuilderViewController: LotteryViewControllerBase, NumberGridSelectionDelegate {
    
    @IBOutlet weak var selectorsStackView: UIStackView?
    @IBOutlet weak var addLineButton: DesignableButton?
    @IBOutlet weak var selectedNumbersStackView: WinningNumbersStackView?
    
    var numberPools: [NumberPool] = []
    var numberViewMap: [String : NumberView] = [:]
    var numberGridDeletionDelegates: [NumberGridDeletionDelegate] = []
    var numberGridsByPoolId: [String: MPSNumberGridCollectionViewController] = [:]
    
    var lineToEdit: PlayslipLine? = nil {
        didSet {
            if let lineToEdit = lineToEdit {
                prepareToEdit(line: lineToEdit)
            }
        }
    }
    
    weak var addLineDelegate: PlayslipLineReciever?
    
    var selectedNumbersByPool: NumberPoolSelections = [:] {
        didSet {
            var selectionsMaxed: [Bool] = []
            selectedNumbersByPool.forEach { (pair) in
                let identifier = pair.key
                let selections = pair.value
                
                if let numberPool = numberPools.first(where: { $0.identifier == identifier }) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNumberViews()
        configureLeftCancelButton()
        view.backgroundColor = .white
        
        if lineToEdit == nil {
            numberPools.forEach { (pool) in
                selectedNumbersByPool[pool.identifier] = []
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if lineToEdit != nil {
            addLineButton?.setTitle("Save", for: .normal)
        }
    }
    
    func prepareToEdit(line: PlayslipLine) {
        for poolId in Array(line.selectedNumbersByPool.keys) {
            if let numbers = line.selectedNumbersByPool[poolId] {
                numbersSelected(selections: numbers, numberPoolIdentifier: poolId)
            }
        }
    }
    
    func numbersSelected(selections: [Int], numberPoolIdentifier: String) {
        guard let pool = numberPools.first(where: { (p) -> Bool in p.identifier == numberPoolIdentifier}) else { return }
        
        let orderedSelections = selections.sorted()
        
        selectedNumbersByPool[numberPoolIdentifier] = selections
        
        for i in 0...pool.selectableNumberCount.max - 1 {
            let num = orderedSelections.indices.contains(i) ? orderedSelections[i] : nil
            numberViewMap[numberPoolIdentifier+String(i)]?.number = num
        }
    }
    
    func setupNumberViews() {
        for pool in numberPools {
            for i in 0...pool.selectableNumberCount.max - 1 {
                let view = CircleNumberView()
                view.view.backgroundColor = !pool.isBonus ? .white : .black
                view.numberLabel?.textColor = pool.isBonus ? .white : .black
                view.clipsToBounds = true
                view.animateOnLoad = false
                numberViewMap[pool.identifier + String(i)] = view
                
                // init numberViews with numbers if editing existing line
                if let lineToEdit = lineToEdit, let number = lineToEdit.selectedNumbersByPool[pool.identifier]?[i] {
                    view.number = number
                }
                
                selectedNumbersStackView?.addArrangedSubview(view)
            }
        }
    }
    
    @objc
    override func cancel() {
        self.performSegue(withIdentifier: "confirm_leave_segue", sender: self)
    }
    
    @IBAction func clearSelections(_ sender: Any) {
        guard let selectedNumbersStackView = selectedNumbersStackView else { return }
        
        for delegate in numberGridDeletionDelegates {
            delegate.clear()
        }
        
        for view in selectedNumbersStackView.arrangedSubviews {
            if let view = view as? CircleNumberView {
                view.number = nil
            }
        }
        
        for numberPool in numberPools {
            selectedNumbersByPool[numberPool.identifier] = []
        }
        
        addLineEnabled = false
    }
    
    @IBAction func addLine() {
        if let lineToEdit = lineToEdit {
            addLineDelegate?.editLine(oldLine: lineToEdit, editedLine: PlayslipLine(selectedNumbersByPool: selectedNumbersByPool))
        } else {
            let line = PlayslipLine(selectedNumbersByPool: selectedNumbersByPool)
            addLineDelegate?.addLine(line: line)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MPSNumberGridCollectionViewController {
            
            destination.selectionDelegate = self
            
            if segue.identifier == "pool_selector_1", numberPools.count > 0 {
                destination.view.translatesAutoresizingMaskIntoConstraints = false
                destination.numberPool = numberPools[0]
                numberGridsByPoolId[numberPools[0].identifier] = destination
                numberGridDeletionDelegates.append(destination)
            }
            
            if segue.identifier == "pool_selector_2", numberPools.count > 1 {
                destination.view.translatesAutoresizingMaskIntoConstraints = false
                destination.numberPool = numberPools[1]
                numberGridsByPoolId[numberPools[1].identifier] = destination
                numberGridDeletionDelegates.append(destination)
            }
            
            if let lineToEdit = lineToEdit, let destinationPoolId = destination.numberPool?.identifier,
               let numbers = lineToEdit.selectedNumbersByPool[destinationPoolId] {
                destination.setupForEditing(selectedNumbersToEdit: numbers)
            }
        }
        
        if let destination = segue.destination as? MPSConfirmNavigationViewController {
            destination.delegate = self
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "pool_selector_2" && numberPools.count == 1 {
            // don't embed a secondary pool selector for single pool games
            return false
        }
        
        return true
    }
}

extension MPSLineBuilderViewController: ConfirmNavigationDelegate {
    func confirm() {
        self.navigationController?.popViewController(animated: true)
    }
}
