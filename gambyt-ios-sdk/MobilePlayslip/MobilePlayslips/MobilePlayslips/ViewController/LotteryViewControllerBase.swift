//
//  LotteryViewControllerBase.swift
//  mal-ios
//
//  Created by Noah Karman on 11/4/19.
//  Copyright © 2019 Interaction Gaming. All rights reserved.
//

import UIKit

class LotteryViewControllerBase: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lotteryLightTeal
    }
    
    func createCustomBackButton(text: String, image: UIImage? = UIImage(named: "backChevron"), selector: Selector) {
        self.navigationItem.hidesBackButton = true

        let wText = "  " + text

        let backbutton = UIButton(type: .custom)

        let image = image?.withRenderingMode(.alwaysTemplate)

        backbutton.setImage(image, for: .normal)
        backbutton.setTitle(wText, for: .normal)
        backbutton.setTitleColor(.white, for: .normal)
        backbutton.addTarget(self, action: selector, for: .touchUpInside)
        backbutton.titleLabel?.font = .igBoldSlabFont(size: 17)
        backbutton.tintColor = .white

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
    }

    func configureLeftCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.igBoldSlabFont(size: 17),
                                                                  NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
    }

    @objc func back() {
        navigationController?.popViewController(animated: true)
    }

    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
}

