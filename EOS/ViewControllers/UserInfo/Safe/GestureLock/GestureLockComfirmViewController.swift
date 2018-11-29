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

    var lightModel = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

	override func viewDidLoad() {
        super.viewDidLoad()
        gestureLockView.delegate = self
        self.coordinator?.checkGestureLock()
        if canDismiss {
            self.configLeftNavButton(R.image.ic_mask_close())
        }
    }

    override func leftAction(_ sender: UIButton) {
        self.coordinator?.dismiss()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lightModel = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lightModel = true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return lightModel ? .lightContent : .default
    }

    override func configureObserveState() {
        self.coordinator?.state.property.promotData.asObservable().subscribe(onNext: {[weak self] (arg0) in
            guard let `self` = self else { return }
            self.messageLabel.text = arg0.message
            self.messageLabel.textColor = arg0.isWarning ? UIColor.warningColor : UIColor.baseColor
            if arg0.isWarning && !arg0.isLocked {
                self.gestureLockView.warn()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        self.coordinator?.state.property.locked.asObservable().subscribe(onNext: {[weak self] (locked) in
            guard let `self` = self else { return }
            self.gestureLockView.locked = locked
            if locked {
                self.gestureLockView.warn()
            } else {
                self.gestureLockView.reset()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
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
