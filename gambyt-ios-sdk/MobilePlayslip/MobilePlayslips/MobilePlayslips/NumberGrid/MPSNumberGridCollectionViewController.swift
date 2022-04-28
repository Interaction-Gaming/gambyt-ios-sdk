//
//  MPSNumberGridCollectionViewController.swift
//  mal-ios
//
//  Created by Noah Karman on 5/25/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import UIKit

private let reuseIdentifier = "number_cell"
private let headerReuseIdentifier = "header_cell"

protocol NumberGridSelectionDelegate: UIViewController {
    func numbersSelected(selections: [Int], numberPoolIdentifier: String)
}

protocol NumberGridDeletionDelegate: UIViewController {
    func clear()
}

class MPSNumberGridCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NumberGridHeaderDelegate, NumberGridDeletionDelegate {
    
    private var selectableNumbers: [Int] = []
    
    weak var selectionDelegate: NumberGridSelectionDelegate?
    weak var counterDelegate: NumberGridHeaderCounterDelegate?
    
    var selections: [Int] = [] {
        didSet {
            self.counterDelegate?.numbersSelected(count: selections.count)
        }
    }
    
    private var selectionsMaxedOut: Bool {
        get {
            return selections.count == numberPool?.selectableNumberCount.max
        }
    }
    
    var numberPool: NumberPool? {
        didSet {
            guard let numberPool = numberPool else { return }
            selectableNumbers = Array(numberPool.selectableNumberRange.min...numberPool.selectableNumberRange.max)
            collectionView.reloadData()
            updatePreferredContentSize()
        }
    }
    
    var numberOfCurrentSelections: Int {
        get {
            return selections.count
        }
    }
    
    var cellSize: CGSize {
        get {
            let sizeClass = self.traitCollection.horizontalSizeClass
            
            switch sizeClass {
            case .compact:
                
                if self.view.frame.width <= 375 {
                    return CGSize(width: 35.8, height: 35.8)
                }
                
                if self.view.frame.width > 400.0 {
                    return CGSize(width: 39.8, height: 39.8)
                }
                
                return CGSize(width: 36, height: 36)
            case .regular:
                return CGSize(width: 40, height: 40)
            default:
                return CGSize(width: 36, height: 36)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.register(MPSNumberGridCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "blank_cell")
        self.collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "blank_header")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func handleNumberSelection(for number: Int) {
        // clicking a selected number a second time -> Remove
        if let i = selections.firstIndex(of: number) {
            selections.remove(at: i)
            
            if let identifier = numberPool?.identifier {
                selectionDelegate?.numbersSelected(selections: selections, numberPoolIdentifier: identifier)
            }
            
            return
        }
        
        // When a new selection pushes us over the maximum count -> Do nothing
        if let max = numberPool?.selectableNumberCount.max, selections.count == max {
            return
        }
        
        // select a number for the first time -> Add to Selections
        if !selections.contains(number) {
            selections.append(number)
            
            if let identifier = numberPool?.identifier {
                selectionDelegate?.numbersSelected(selections: selections, numberPoolIdentifier: identifier)
            }
        }
    }
    
    func applyBackgroundColorsForSelections(selections: [Int]) {
        for selectableNumber in selectableNumbers {
            if let cellIndex = selectableNumbers.firstIndex(of: selectableNumber),
               let cell = collectionView.cellForItem(at: IndexPath(item: Int(cellIndex), section: 0)) {
                cell.backgroundColor = selections.contains(selectableNumber) ? .playslipLightGray : .white
            }
        }
    }
    
    func autoFill() {
        guard let selectionsMax = numberPool?.selectableNumberCount.max, selectableNumbers.count != 0 else { return }
        let autoFillNumbers = selectableNumbers.shuffled().prefix(selectionsMax)
        
        self.selections = Array(autoFillNumbers)
        
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        
        applyBackgroundColorsForSelections(selections: selections)
        
        if let identifier = numberPool?.identifier {
            self.selectionDelegate?.numbersSelected(selections: selections, numberPoolIdentifier: identifier)
        }
    }
    
    func setupForEditing(selectedNumbersToEdit: [Int]) {
        self.selections = selectedNumbersToEdit
        
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        
        applyBackgroundColorsForSelections(selections: selections)
        
        if let identifier = numberPool?.identifier {
            self.selectionDelegate?.numbersSelected(selections: selections, numberPoolIdentifier: identifier)
        }
    }
    
    func clear() {
        self.selections = []
        collectionView.reloadData()
        applyBackgroundColorsForSelections(selections: [])
    }
    
    func updatePreferredContentSize() {
        let numberOfItems = self.collectionView.numberOfItems(inSection: 0)
        let numberOfColumns = Int((collectionView.frame.width / cellSize.width).rounded(.down))
        let numberOfRows = numberOfItems / numberOfColumns
        
        self.preferredContentSize = CGSize(width: self.view.frame.width, height: CGFloat(numberOfRows) * cellSize.height + 110)
        
        self.view.heightAnchor.constraint(equalToConstant: preferredContentSize.height).isActive = true
    }
    
    // MARK: UICollectionViewDelegate + UICollectionViewDelegateFlowLayout

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let numberPool = numberPool else { return 0 }
        
        return (numberPool.selectableNumberRange.min...numberPool.selectableNumberRange.max).count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let number = selectableNumbers[safe: indexPath.row] {
            handleNumberSelection(for: number)
            
            collectionView.reloadData()
            
            // cells won't be available in cellForItem(at:) until laid out
            // we need this to guaruntee access to cells in applyBackgroundColorsForSelections
            collectionView.layoutIfNeeded()
            
            applyBackgroundColorsForSelections(selections: selections)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MPSNumberGridCollectionViewCell {
            let selectedNumber = selectableNumbers[indexPath.row]
            cell.number = selectedNumber
            cell.grayLabel = selections.contains(selectedNumber) ? false : self.selectionsMaxedOut
            cell.exposedEdges = calculateExposedEdges(indexPath: indexPath)
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "blank_cell", for: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as? MPSNumberGridCollectionViewHeader,
           let maxSelections = numberPool?.selectableNumberCount.max {
            header.delegate = self
            header.numberOfSelections = maxSelections
            header.setup()
            self.counterDelegate = header
            return header
        }
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "blank_header", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
    
    func calculateExposedEdges(indexPath: IndexPath) -> [ExposedEdge] {
        var edges: [ExposedEdge] = []
        
        let numberOfItems = self.collectionView.numberOfItems(inSection: 0)
        let numberOfColumns = Int((collectionView.frame.width / cellSize.width).rounded(.down))
        let numberOfRows = numberOfItems / numberOfColumns
        
        let rowIndex = indexPath.item % numberOfColumns
        
        // left == first cell in row
        if rowIndex == 0 {
            edges.append(.left)
        }
        
        // right == last cell in row or last cell in collection
        if rowIndex == numberOfColumns - 1 {
            edges.append(.right)
        } else if indexPath.item == numberOfItems - 1 {
            edges.append(.right)
        }
        
        // top == first row
        if indexPath.item < numberOfColumns {
            edges.append(.top)
        }
        
        // bottom == last row or second to last row overhang
        if indexPath.item >= numberOfColumns * numberOfRows {
            edges.append(.bottom)
        } else if indexPath.item >= numberOfColumns * (numberOfRows - 1) {
            let lastRowItemCount = numberOfItems % numberOfColumns
            if rowIndex >= lastRowItemCount {
                edges.append(.bottom)
            }
        }
        
        return edges
    }
    
}
