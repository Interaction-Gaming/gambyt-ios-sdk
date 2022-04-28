//
//  MPSRapidDrawAddOnViewController.swift
//  mal-iosTests
//
//  Created by Noah Karman on 7/16/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import UIKit

class MPSRapidDrawAddOnViewController: MPSAddOnViewController {
    @IBOutlet weak var wagerCollectionView: DynamicHeightCollectionView?
    @IBOutlet weak var kenoBonusExclusionDisclaimer: UILabel?
    @IBOutlet weak var numberPreviewRow1: UIStackView?
    @IBOutlet weak var numberPreviewRow2: UIStackView?
    @IBOutlet weak var numberPreviewRow1Parent: UIView?
    @IBOutlet weak var numberPreviewRow2Parent: UIView?
    @IBOutlet weak var savePlayslipButton: DesignableButton?
    
    var selectedIndexPath: IndexPath? {
        didSet {
            savePlayslipButton?.isEnabled = selectedIndexPath != nil
            savePlayslipButton?.alpha = selectedIndexPath != nil ? 1.0 : 0.5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wagerCollectionView?.delegate = self
        wagerCollectionView?.dataSource = self
        selectedIndexPath = nil
        
        if let alignedFlowLayout = wagerCollectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout {
            alignedFlowLayout.horizontalAlignment = .left
            alignedFlowLayout.verticalAlignment = .top
            alignedFlowLayout.minimumInteritemSpacing = 8.0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupViews()
    }
    
    func setupViews() {
        configureMultiplierExclusions()
        setupNumberPreview()
        setupBonusLabels()
    }
    
    func configureMultiplierExclusions() {
        if let exclusions = playslipBuilder.game?.multiplier?.exclusions, let singleLine = playslipBuilder.lines.first,
           let singlePool = playslipBuilder.game?.numberPools.first,
           let selectionCount = singleLine.selectedNumbersByPool[singlePool.identifier]?.count,
           !exclusions.isEmpty {
            kenoBonusExclusionDisclaimer?.isHidden = !exclusions.contains(selectionCount)
            checkBoxButton?.isUserInteractionEnabled = !exclusions.contains(selectionCount)
            let alpha: CGFloat = exclusions.contains(selectionCount) ? 0.5 : 1.0
            multiplierTitleLabel?.alpha = alpha
            checkBoxButton?.alpha = alpha
            
            if exclusions.contains(selectionCount) {
                playslipBuilder.withMultiplier(false)
            }
            
        } else {
            kenoBonusExclusionDisclaimer?.isHidden = true
            checkBoxButton?.isUserInteractionEnabled = true
            checkBoxButton?.alpha = 1.0
        }
    }
    
    func setupNumberPreview() {
        guard let pool = playslipBuilder.game?.numberPools.first, let selectionsByPool = playslipBuilder.lines.first?.selectedNumbersByPool, let selections = selectionsByPool[pool.identifier] else {
            return
        }
        
        // two rows of six number balls max
        let ROW_MAX = 6
        numberPreviewRow2Parent?.isHidden = selections.count <= ROW_MAX
        
        selections.enumerated().forEach { (index, number) in
            let targetStack = index <= 5 ? numberPreviewRow1 : numberPreviewRow2
            
            let cell = CircleNumberView()
            cell.number = number
            targetStack?.addArrangedSubview(cell)
        }
    }
    
    func setupBonusLabels() {
        guard let game = playslipBuilder.game, let multiplier = game.multiplier else { return }
        
        if game.identifier == .keno || game.identifier == .allOrNothing, let name = multiplier.multiplierName {
            multiplierTitleLabel?.text = "Add \(name)"
            multiplierSubtitleLabel?.text = multiplier.multiplierHelpText
        }
    }
}

extension MPSRapidDrawAddOnViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Rapid Draw games always have a singular wager option
        guard let wagerOption = playslipBuilder.game?.possibleWagers.first else { return 0 }
        
        return wagerOption.possibleWagerValuesInCents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Rapid Draw games always have a singular wager option
        if let wagerOption = playslipBuilder.game?.possibleWagers.first,
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wager_amount_cell", for: indexPath) as?  MPSRapidDrawAddOnWagerAmountCollectionViewCell {
            cell.isActiveWager = indexPath == selectedIndexPath
            cell.wagerAmount = wagerOption.possibleWagerValuesInCents[indexPath.item]

            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
            playslipBuilder.addWager(PlayslipWager(wagerType: .standard, baseWagerValueInCents: 0))
        } else if let wagerOption = playslipBuilder.game?.possibleWagers.first {
            let wagerAmount = wagerOption.possibleWagerValuesInCents[indexPath.item]
            selectedIndexPath = indexPath
            playslipBuilder.addWager(PlayslipWager(wagerType: .standard, baseWagerValueInCents: wagerAmount))
        }
        
        collectionView.reloadData()
        updateCost()
    }

    var cellSize: CGSize {
        get {
            let sizeClass = self.traitCollection.horizontalSizeClass
            
            switch sizeClass {
            case .compact:
                return CGSize(width: 52, height: 44)
            case .regular:
                return CGSize(width: 90, height: 84)
            default:
                return CGSize(width: 36, height: 36)
            }
        }
    }
}


