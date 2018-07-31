//
//  UserInfoViewController.swift
//  EOS
//
//  Created koofrank on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class UserInfoViewController: BaseViewController {
    
    @IBOutlet weak var testView: NormalCellView!
    
    
    var coordinator: (UserInfoCoordinatorProtocol & UserInfoStateManagerProtocol)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.title = R.string.localizable.mine_title()
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

extension UserInfoViewController {
    @objc func clickCellView(_ sender:[String:Any]) {
        switch sender["index"] as! Int {
        case 0:self.coordinator?.openNormalSetting()
        case 1:self.coordinator?.openSafeSetting()
        case 2:self.coordinator?.openHelpSetting()
        case 3:self.coordinator?.openServersSetting()
        case 4:self.coordinator?.openAboutSetting()
        default:
            break
        }
    }
}
