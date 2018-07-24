//
//  ChangeWalletNameViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class ChangeWalletNameViewController: BaseViewController {

	var coordinator: (ChangeWalletNameCoordinatorProtocol & ChangeWalletNameStateManagerProtocol)?
    var name: String = "-"
    
    @IBOutlet weak var changeWalletNameView: ChangeWalletNameView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI() {
        self.title = R.string.localizable.change_wallet_name()
        changeWalletNameView.text = name
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
