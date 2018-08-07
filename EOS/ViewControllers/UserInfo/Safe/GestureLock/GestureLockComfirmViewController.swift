//
//  GestureLockComfirmViewController.swift
//  EOS
//
//  Created peng zhu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class GestureLockComfirmViewController: BaseViewController {

    @IBOutlet weak var gestureLockView: GestureLockView!
    
    var coordinator: (GestureLockComfirmCoordinatorProtocol & GestureLockComfirmStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        gestureLockView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
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

extension GestureLockComfirmViewController: GestureLockViewDelegate {
    func gestureLockViewDidTouchesEnd(_ lockView: GestureLockView) {
        let password = lockView.password
        if password.trimmed.count > 0 {
            self.coordinator?.confirmLock(gestureLockView.password)
        }
    }
}
