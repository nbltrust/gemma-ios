//
//  ScreenShotAlertViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class ScreenShotAlertViewController: BaseViewController {

	var coordinator: (ScreenShotAlertCoordinatorProtocol & ScreenShotAlertStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
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

extension ScreenShotAlertViewController {
    @objc func sureShot(_ data: [String : Any]) {
        self.coordinator?.dismissScreenShotAlert()
    }
}
