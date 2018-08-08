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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSafeSetting()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
    }
    
    func setupUI() {
        self.title = R.string.localizable.mine_safesetting()
    }
    
    func setupEvent() {
        faceView.safeSwitch.addTarget(self, action: #selector(faceLock(_:)), for: .touchUpInside)
        fingerView.safeSwitch.addTarget(self, action: #selector(fingerLock(_:)), for: .valueChanged)
        gestureView.safeSwitch.addTarget(self, action: #selector(gestureLock(_:)), for: .valueChanged)
    }
    
    @objc func faceLock(_ sender: UISwitch) {
        if sender.isOn {
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
    
    @objc func fingerLock(_ sender: UISwitch) {
        if sender.isOn {
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
    
    @objc func gestureLock(_ sender: UISwitch) {
        if sender.isOn {
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
    
    func updateSafeSetting() {
        log.debug(SafeManager.shared.isFingerPrinterLockOpened())
        faceView.safeSwitch.setOn(SafeManager.shared.isFaceIdOpened(), animated: true)
        fingerView.safeSwitch.setOn(SafeManager.shared.isFingerPrinterLockOpened(), animated: true)
        gestureView.safeSwitch.setOn(SafeManager.shared.isGestureLockOpened(), animated: true)
        
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
