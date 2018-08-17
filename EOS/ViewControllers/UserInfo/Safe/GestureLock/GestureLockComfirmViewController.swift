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

    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var gestureLockView: GestureLockView!
    
    var canDismiss: Bool = true
    
    var coordinator: (GestureLockComfirmCoordinatorProtocol & GestureLockComfirmStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        gestureLockView.delegate = self
        if canDismiss {
            self.configLeftNavButton(R.image.icTransferClose())
        }
    }
    
    override func leftAction(_ sender: UIButton) {
        self.coordinator?.dismiss()
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
        
        self.coordinator?.state.property.promotData.asObservable().subscribe(onNext: {[weak self] (arg0) in
            guard let `self` = self else { return }
            self.messageLabel.text = arg0.message
            self.messageLabel.textColor = arg0.isWarning ? UIColor.scarlet : UIColor.darkSlateBlue
            if arg0.isWarning {
                self.gestureLockView.warn()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    override func configureObserveState() {
        commonObserveState()
        
    }
}

extension GestureLockComfirmViewController: GestureLockViewDelegate {
    func gestureLockViewDidTouchesEnd(_ lockView: GestureLockView) {
        if !SafeManager.shared.isGestureLockLocked() {
            let password = lockView.password
            if password.trimmed.count > 0 {
                self.coordinator?.confirmLock(gestureLockView.password)
            }
        }
    }
}
