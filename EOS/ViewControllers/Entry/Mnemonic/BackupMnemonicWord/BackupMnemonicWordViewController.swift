//
//  BackupMnemonicWordViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/9/14.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class BackupMnemonicWordViewController: BaseViewController {

	var coordinator: (BackupMnemonicWordCoordinatorProtocol & BackupMnemonicWordStateManagerProtocol)?

    @IBOutlet weak var contentView: BackupPrivateKeyView!
    
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
        self.title = R.string.localizable.backup_mnemonic_title.key.localized()
        contentView.redTips = R.string.localizable.backup_mnemonic_red_text.key.localized()
        contentView.buttonTitle = R.string.localizable.backup_mnemonic_knowbtn_title.key.localized()
    }

    func setupData() {
        
    }
    
    func setupEvent() {
        
    }
    
    override func configureObserveState() {

    }
}

//MARK: - TableViewDelegate

//extension BackupMnemonicWordViewController: UITableViewDataSource, UITableViewDelegate {
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

extension BackupMnemonicWordViewController {
//    @objc func <#view#>DidClicked(_ data:[String: Any]) {
//        if let addressdata = data["data"] as? <#model#>, let view = data["self"] as? <#view#>  {
//
//        }
//    }
    @objc func know(_ data:[String:Any]) {
        self.coordinator?.pushToMnemonicWordContentVC()
    }
}

