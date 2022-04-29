//
//  PlayslipLineTableViewCell.swift
//  mal-ios
//
//  Created by Noah Karman on 6/15/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import UIKit

class MPSPlayslipLineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numberStackView: WinningNumbersStackView?
    @IBOutlet weak var lineIndexLabel: UILabel?
    
    var game: PlayslipGame?
    
    weak var playslipDelegate: PlayslipMutatorDelegate?
    
    static let cellIdentifier = "playslip_line_cell"

    @IBAction func edit(_ sender: Any) {
        if let line = line {
            playslipDelegate?.editLineAction(line: line)
        }
    }
    
    @IBAction func remove(_ sender: Any) {
        if let line = line {
            playslipDelegate?.removeLineAction(line: line)
        }
    }
    
    var line: PlayslipLine? {
        didSet {
            setupUI()
        }
    }
    
    var index: Int = 0 {
        didSet {
            self.lineIndexLabel?.text = String(index + 1)
        }
    }
    
    func setupUI() {
        guard let line = line else { return }
        for pool in game?.numberPools ?? [] {
            if let numbersByPool = line.selectedNumbersByPool[pool.identifier]?.sorted() {
                numbersByPool.forEach { (number) in
                    let numberView = CircleNumberView()
                    numberView.animateOnLoad = false
                    numberView.number = number
                    if pool.isBonus {
                        numberView.view.backgroundColor = .black
                        numberView.numberLabel?.textColor = .white
                    }
                    numberStackView?.addArrangedSubview(numberView)
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        numberStackView?.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        lineIndexLabel?.text = nil
    }
}
