//
//  ScreenShotAlertViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/8/2.
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
    
    override func configureObserveState() {
        
    }
}

extension ScreenShotAlertViewController {
    @objc func sureShot(_ data:[String: Any]) {
        self.coordinator?.dismiss()
    }
}
