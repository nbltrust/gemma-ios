//
//  SafeViewController.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class SafeViewController: BaseViewController {

	var coordinator: (SafeCoordinatorProtocol & SafeStateManagerProtocol)?

    @IBOutlet weak var faceView: SafeLineView!
    @IBOutlet weak var fingerView: SafeLineView!
    @IBOutlet weak var gestureView: SafeLineView!
    @IBOutlet weak var gestureActionView: NormalCellView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateSafeSetting()
    }
    
    func setupUI() {
        self.title = R.string.localizable.mine_safesetting.key.localized()
    }
    
    func setupEvent() {
        faceView.safeSwitch.valueChange = {[weak self] (isOn) in
            guard let `self` = self else { return }
            if isOn != SafeManager.shared.isFaceIdOpened() {
                return
            }
            if !isOn {
                self.coordinator?.openFaceIdLock({[weak self] (result) in
                    guard let `self` = self else { return }
                    self.updateSafeSetting()
                })
            } else {
                self.coordinator?.confirmFaceId({[weak self] (result) in
                    guard let `self` = self else { return }
                    if result {
                        self.coordinator?.closeFaceIdLock()
                    }
                    self.updateSafeSetting()
                })
            }
        }
        
        fingerView.safeSwitch.valueChange = {[weak self] (isOn) in
            guard let `self` = self else { return }
            if isOn != SafeManager.shared.isFingerPrinterLockOpened() {
                return
            }
            if !isOn {
                self.coordinator?.openFingerSingerLock({[weak self] (result) in
                    guard let `self` = self else { return }
                    self.updateSafeSetting()
                })
            } else {
                self.coordinator?.confirmFingerSinger({[weak self] (result) in
                    guard let `self` = self else { return }
                    if result {
                        self.coordinator?.closeFingerSingerLock()
                    }
                    self.updateSafeSetting()
                })
            }
        }
        
        gestureView.safeSwitch.valueChange = {[weak self] (isOn) in
            guard let `self` = self else { return }
            if isOn != SafeManager.shared.isGestureLockOpened() {
                return
            }
            if !isOn {
                self.coordinator?.openGestureLock({[weak self] (result) in
                    guard let `self` = self else { return }
                    self.updateSafeSetting()
                })
            } else {
                self.coordinator?.confirmGesture({[weak self] (result) in
                    guard let `self` = self else { return }
                    if result {
                        self.coordinator?.closeGetureLock()
                    }
                    self.updateSafeSetting()
                })
            }
        }
    }
    
     func updateSafeSetting() {
        faceView.safeSwitch.setOn(SafeManager.shared.isFaceIdOpened(), animate: true)
        fingerView.safeSwitch.setOn(SafeManager.shared.isFingerPrinterLockOpened(), animate: true)
        gestureView.safeSwitch.setOn(SafeManager.shared.isGestureLockOpened(), animate: true)
        
        gestureView.isShowLineView = SafeManager.shared.isGestureLockOpened()
        gestureActionView.isHidden = !SafeManager.shared.isGestureLockOpened()
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

extension SafeViewController {
    @objc func clickCellView(_ sender : [String:Any]) {
        if let index = sender["index"] as? Int {
            if index == 3 {
                self.coordinator?.confirmGesture({[weak self] (result) in
                    guard let `self` = self else { return }
                    if result {
                        self.coordinator?.openGestureLock({ (resetResult) in
                            self.updateSafeSetting()
                        })
                    }
                })
            }
        }
    }
}
