//
//  VerifyPriKeyViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/9/25.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class VerifyPriKeyViewController: BaseViewController {

	var coordinator: (VerifyPriKeyCoordinatorProtocol & VerifyPriKeyStateManagerProtocol)?

    @IBOutlet weak var contentView: LeadInKeyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupUI()
        setupEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func refreshViewController() {
        
    }
    
    func setupUI() {
        self.title = R.string.localizable.copy_priKey_title.key.localized()
        self.contentView.title = R.string.localizable.verify_prikey_title.key.localized()
        self.contentView.buttonTitle = R.string.localizable.verify()
    }

    func setupData() {
        
    }
    
    func setupEvent() {
        
    }
    
    override func configureObserveState() {

    }
}

//MARK: - TableViewDelegate

//extension VerifyPriKeyViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//          let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.<#cell#>.name, for: indexPath) as! <#cell#>
//
//        return cell
//    }
//}


//MARK: - View Event

extension VerifyPriKeyViewController {
    @objc func beginLeadInAction(_ sender : [String:Any]) {
        if let priKey = self.contentView.textView.text, priKey == WalletManager.shared.priKey {
            self.coordinator?.finishCopy()
        } else {
            self.showError(message: R.string.localizable.prikey_verify_fail.key.localized())
        }
    }
}

