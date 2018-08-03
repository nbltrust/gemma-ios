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
        self.title = R.string.localizable.mine_safesetting()
    }
    
    func setupEvent() {
        faceView.safeSwitch.addTarget(self, action: #selector(faceLock(_:)), for: .valueChanged)
        fingerView.safeSwitch.addTarget(self, action: #selector(fingerLock(_:)), for: .valueChanged)
        gestureView.safeSwitch.addTarget(self, action: #selector(gestureLock(_:)), for: .valueChanged)
    }
    
    @objc func faceLock(_ sender: UISwitch) {
        if sender.isOn {
            self.coordinator?.openFaceIdLock({[weak self] (result) in
                guard let `self` = self else { return }
                if !result {
                    self.updateSafeSetting()
                }
            })
        } else {
            self.coordinator?.closeFaceIdLock({[weak self] (result) in
                guard let `self` = self else { return }
                if !result {
                    self.updateSafeSetting()
                }
            })
        }
    }
    
    @objc func fingerLock(_ sender: UISwitch) {
        if sender.isOn {
            self.coordinator?.openFingerSingerLock({[weak self] (result) in
                guard let `self` = self else { return }
                if !result {
                    self.updateSafeSetting()
                }
            })
        } else {
            self.coordinator?.closeFingerSingerLock({[weak self] (result) in
                guard let `self` = self else { return }
                if !result {
                    self.updateSafeSetting()
                }
            })
        }
    }
    
    @objc func gestureLock(_ sender: UISwitch) {
        if sender.isOn {
            self.coordinator?.openGestureLock()
        } else {
            self.coordinator?.closeGetureLock()
        }
    }
    
    func updateSafeSetting() {
        faceView.safeSwitch.isOn = SafeManager.shared.isFaceIdOpened()
        fingerView.safeSwitch.isOn = SafeManager.shared.isFingerPrinterLockOpened()
        gestureView.safeSwitch.isOn = SafeManager.shared.isFaceIdOpened()
        
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

            let views = [self.faceView,self.fingerView,self.gestureView]
            if index <= views.count-1 {
    
            }else {
                
            }
        }
    }
}
