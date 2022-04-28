//
//  MultiLinePlayslipBuilderTableViewController.swift
//  mal-ios
//
//  Created by Noah Karman on 5/24/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import UIKit
import ReSwift

fileprivate enum CellIdentifier: String {
    case header = "mps_builder_header"
    case counter = "mps_count_cell"
    case addLine = "add_line_cell"
}

struct MultiLinePlayslipBuilderSubState: Equatable {
    var game: PlayslipGame?

    init(state: AppState) {
        guard let tabIndex = Dependencies.tabNavigationController?.selectedTab, let appContext = AppContext(rawValue: tabIndex) else { return }
        guard let gameId = state.gameDetails[appContext]?.gameDetailsSelectedGameIdentifier else { return }
        let playslipGames = state.playslips.games
        
        self.game = playslipGames.first(where: { (g) -> Bool in
            g.identifier.rawValue == gameId
        })
    }
}

protocol PlayslipLineReciever: UIViewController {
    func addLine(line: PlayslipLine)
    func editLine(oldLine: PlayslipLine, editedLine: PlayslipLine)
}

protocol PlayslipMutatorDelegate: UIViewController {
    func removeLineAction(line: PlayslipLine)
    func editLineAction(line: PlayslipLine)
}

class MPSMultiLinePlayslipBuilderTableViewController: LotteryViewControllerBase, PlayslipLineReciever, PlayslipMutatorDelegate, StoreSubscriber {
    
    var DYNAMIC_CELL_COUNT: Int {
        get {
            builder.lines.isEmpty ? 3 : builder.lines.count + 2
        }
    }

    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var nextButton: DesignableButton?
    @IBOutlet weak var ticketCostLabel: UILabel?
    @IBOutlet weak var lineRemovedConfirmationDialog: UIView?
    
    var builder = PlayslipBuilder()
    var lineToEdit: PlayslipLine?
    var lastRemovedLine: PlayslipLine?
    var hasAutoPresentedLineBuilder = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        lineRemovedConfirmationDialog?.isHidden = true
        
        ticketCostLabel?.text = "$0.00"
        self.view.backgroundColor = .white
        let backImage = UIImage(named: "backChevron")
        let customBackButton = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(back))
        
        self.navigationItem.leftBarButtonItem = customBackButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        appStore.subscribe(self) {
            $0.select(MultiLinePlayslipBuilderSubState.init)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        appStore.unsubscribe(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        autoPresentLineBuilderIfNeeded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let dest = segue.destination as? MPSLineBuilderViewController,
           let pools = self.builder.game?.numberPools {
            dest.addLineDelegate = self
            dest.numberPools = pools
            
            if segue.identifier == "edit_line_segue", let lineToEdit = self.lineToEdit {
                dest.lineToEdit = lineToEdit
            }
        }
        
        if let dest = segue.destination as? MPSConfirmNavigationViewController {
            dest.delegate = self
        }
        
        if let dest = segue.destination as? MPSAddOnViewController {
            dest.playslipBuilder = builder
        }
    }
    
    func newState(state: MultiLinePlayslipBuilderSubState) {
        if builder.game != state.game, let game = state.game {
            builder.withGame(game)
            self.title = game.name
        }
    }
    
    @objc func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addLineButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "add_line_segue", sender: sender)
    }
    
    @IBAction func nextButton(_ sender: Any) {
        if builder.lines.count > 0 {
            self.performSegue(withIdentifier: "add_on_screen_segue", sender: self)
        }
    }
    
    func updateTicketCost() {
        if let costInt = builder.workingCostInCents {
            let costInCents = Double(costInt) / 100.0
            ticketCostLabel?.text = costInCents.formatDollarsString(fractionDigits: 2)
        }
    }
    
    func enableOrDisableNextButton() {
        let enabled = builder.lines.count > 0
        nextButton?.isEnabled = enabled
        nextButton?.backgroundColor = enabled ? .lotteryNavy : .lightGray
    }
    
    func addLine(line: PlayslipLine) {
        builder.addLine(line)
        updateTicketCost()
        enableOrDisableNextButton()
        tableView?.reloadData()
    }

    func editLine(oldLine: PlayslipLine, editedLine: PlayslipLine) {
        builder.editLine(oldLine: oldLine, editedLine: editedLine)
        updateTicketCost()
        enableOrDisableNextButton()
        tableView?.reloadData()
    }
    
    func removeLineAction(line: PlayslipLine) {
        builder.removeLine(line)
        
        lastRemovedLine = line
        
        presentRemovalUndoOption()
        
        updateTicketCost()
        enableOrDisableNextButton()
        tableView?.reloadData()
    }
    
    func presentRemovalUndoOption() {
        showRemovalUndoOption()
        
        // Hide alert after 3 seconds of no interaction
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.hideRemovalUndoOption()
        }
    }
    
    func hideRemovalUndoOption() {
        UIView.animate(withDuration: 0.3) {
            self.lineRemovedConfirmationDialog?.isHidden = true
        }
    }
    
    func showRemovalUndoOption() {
        UIView.animate(withDuration: 0.3) {
            self.lineRemovedConfirmationDialog?.isHidden = false
        }
    }
    
    @IBAction func undoRemoveLine(_ sender: Any) {
        if let removedLine = lastRemovedLine {
            builder.addLine(removedLine)
            
            hideRemovalUndoOption()
            
            updateTicketCost()
            enableOrDisableNextButton()
            tableView?.reloadData()
        }
    }
    
    func editLineAction(line: PlayslipLine) {
        self.lineToEdit = line
        self.performSegue(withIdentifier: "edit_line_segue", sender: self)
    }
    
    func autoPresentLineBuilderIfNeeded() {
        if builder.lines.count == 0, !hasAutoPresentedLineBuilder {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.hasAutoPresentedLineBuilder = true
                self.performSegue(withIdentifier: "add_line_segue", sender: self)
            }
        }
    }
    
    @objc override func back() {
        // no need to confirm if user has done no editing
        if builder.lines.isEmpty {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.performSegue(withIdentifier: "confirm_leave_segue", sender: self)
    }
}

extension MPSMultiLinePlayslipBuilderTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DYNAMIC_CELL_COUNT
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if builder.lines.isEmpty {
            switch indexPath.row {
            case 0:
                return tableView.dequeueReusableCell(withIdentifier: CellIdentifier.header.rawValue, for: indexPath)
            case 1:
                return tableView.dequeueReusableCell(withIdentifier: CellIdentifier.counter.rawValue, for: indexPath)
            case 2:
                return tableView.dequeueReusableCell(withIdentifier: CellIdentifier.addLine.rawValue, for: indexPath)
            default:
                return UITableViewCell()
            }
        }
        
        switch indexPath.row {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: CellIdentifier.header.rawValue, for: indexPath)
        case DYNAMIC_CELL_COUNT - 1:
            return tableView.dequeueReusableCell(withIdentifier: CellIdentifier.addLine.rawValue, for: indexPath)
        case 1...builder.lines.count:
            if let cell = tableView.dequeueReusableCell(withIdentifier: MPSPlayslipLineTableViewCell.cellIdentifier, for: indexPath) as? MPSPlayslipLineTableViewCell {
                cell.game = builder.game
                cell.index = indexPath.row - 1
                cell.line = builder.lines[cell.index]
                cell.playslipDelegate = self
                return cell
            }
            
            return tableView.dequeueReusableCell(withIdentifier: CellIdentifier.addLine.rawValue, for: indexPath)
        default:
            return UITableViewCell()
        }
    }
}

extension MPSMultiLinePlayslipBuilderTableViewController: ConfirmNavigationDelegate {
    func confirm() {
        self.navigationController?.popViewController(animated: true)
    }
}
