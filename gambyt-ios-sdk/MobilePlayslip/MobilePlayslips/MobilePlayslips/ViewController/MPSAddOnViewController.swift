//
//  MPSAddOnViewController.swift
//  mal-ios
//
//  Created by Noah Karman on 7/16/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import UIKit
import ReSwift

enum CheckBoxState {
    case checked
    case unchecked
}

class MPSAddOnViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    struct Props {
        init(state: AppState) {
            if let username = state.sessionState.decodedAccessToken()["username"] as? String {
                userId = PlayslipUserIdMetadata(type: .playerId, id: username)
            } else {
                let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "invalid_device_id"
                userId = PlayslipUserIdMetadata(type: .deviceId, id: deviceId)
            }
        }
        
        let userId: PlayslipUserIdMetadata
    }
    
    @IBOutlet weak var multiplierTitleLabel: UILabel?
    @IBOutlet weak var multiplierSubtitleLabel: UILabel?
    @IBOutlet weak var drawCountSelectorButton: DesignableButton?
    @IBOutlet weak var pickerPresenter: UITextField?
    @IBOutlet weak var ticketCostLabel: UILabel?
    @IBOutlet weak var checkBoxButton: UIImageView?
    @IBOutlet weak var multiplierView: UIView?
    
    var checkboxState: CheckBoxState = .unchecked
    
    var playslipBuilder: PlayslipBuilder = PlayslipBuilder() {
        didSet {
            updateViews()
        }
    }
    
    var drawPickerData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePickerView()
        configureMultiplierView()
        updateCost()
        
        self.title = playslipBuilder.game?.name
        let backImage = UIImage(named: "backChevron")
        let customBackButton = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = customBackButton
        
        checkBoxButton?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkboxToggled)))
    }
    
    @objc func checkboxToggled(sender: Any) -> Void {
        if checkboxState == .unchecked {
            checkboxState = .checked
        } else if checkboxState == .checked {
            checkboxState = .unchecked
        }
        
        checkBoxButton?.isHighlighted = checkboxState == .checked
        
        playslipBuilder.withMultiplier(checkboxState == .checked)
        updateViews()
    }
    
    func configureMultiplierView() {
        guard let game = playslipBuilder.game else { return }
        
        if let multiplierName = game.multiplier?.multiplierName, let helpText = game.multiplier?.multiplierHelpText {
            multiplierTitleLabel?.text = multiplierName
            multiplierSubtitleLabel?.text = helpText
        }
    }
    
    func updateCost() {
        if let costInt = playslipBuilder.workingCostInCents {
            let costInCents = Double(costInt) / 100.0
            ticketCostLabel?.text = costInCents.formatDollarsString(fractionDigits: 2)
        }
    }
    
    func updateViews() {
        if let game = playslipBuilder.game {
            let pickerDataInt = Array(game.multiDrawRange.min...game.multiDrawRange.max)
            drawPickerData = pickerDataInt.compactMap {  String($0) }
        }
        
        updateCost()
        configureMultiplierView()
    }
    
    func configurePickerView() {
        let picker  = UIPickerView(frame: CGRect.zero)
        picker.delegate = self
        picker.dataSource = self
        pickerPresenter?.inputView = picker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(done))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        pickerPresenter?.inputAccessoryView = toolBar
    }
    
    @IBAction func drawCountSelectorPressed(_ sender: Any) {
        pickerPresenter?.becomeFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return drawPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return drawPickerData[safe: row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let drawCountString = drawPickerData[safe: row], let drawCount = Int(drawCountString) {
            playslipBuilder.withDrawCount(drawCount)
            let drawsString = drawCount == 1 ? " Draw" : " Draws"
            drawCountSelectorButton?.setTitle(drawCountString + drawsString, for: .normal)
            updateViews()
        }
    }
    
    @objc func done() {
        pickerPresenter?.resignFirstResponder()
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savePlayslip(_ sender: Any) {
        if let slip = playslipBuilder.build() {
            appStore.dispatch(SavePlayslipToCartAction(playslip: slip))
            self.performSegue(withIdentifier: "unwind_from_playslips_segue", sender: self)
        }
    }
}

extension MPSAddOnViewController: StoreSubscriber {
    override func viewWillAppear(_ animated: Bool) {
        appStore.subscribe(self) {
            $0.select(Props.init)
        }
    }
    
    func newState(state: Props) {
        playslipBuilder.withUserIDMetaData(id: state.userId.id, idType: state.userId.type)
    }
}

