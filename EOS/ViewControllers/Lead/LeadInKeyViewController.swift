//
//  LeadInKeyViewController.swift
//  EOS
//
//  Created DKM on 2018/7/31.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class LeadInKeyViewController: BaseViewController {

    @IBOutlet weak var leadInKeyView: LeadInKeyView!
    var coordinator: (LeadInKeyCoordinatorProtocol & LeadInKeyStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if leadInKeyView.textView.text == "" {
            leadInKeyView.creatButton.isEnabel.accept(false)
        } else {
            leadInKeyView.creatButton.isEnabel.accept(true)
        }
    }
    
    func setupUI() {
        self.title = R.string.localizable.lead_in()
        self.configRightNavButton(R.image.scan_qr_code())
    }
    
    override func rightAction(_ sender: UIButton) {
        self.coordinator?.openScan()
    }
    
    func commonObserveState() {
        coordinator?.subscribe(errorSubscriber) { sub in
            return sub.select { state in state.errorMessage }.skipRepeats({ (old, new) -> Bool in
                return false
            })
        }
        
        coordinator?.subscribe(loadingSubscriber) { sub in
            return sub.select { state in state.isLoading }.skipRepeats({ (old, new) -> Bool in
                return false
            })
        }
    }
    
    override func configureObserveState() {
        commonObserveState()
        
    }
}

extension LeadInKeyViewController {
    @objc func beginLeadInAction(_ sender : [String:Any]) {
        guard let priKey = self.leadInKeyView.textView.text else {
            return
        }
        
        if let valid = self.coordinator?.validPrivateKey(priKey).0 {
            if valid == true {
                self.coordinator?.importPrivKey(priKey)
                self.coordinator?.openSetWallet()
            }
        }
    }
}
