//
//  CreatationCompleteViewController.swift
//  EOS
//
//  Created peng zhu on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class CreatationCompleteViewController: BaseViewController {

    @IBOutlet weak var comfirmView: ComfirmView!
    @IBOutlet weak var contentView: UIView!
    
    var coordinator: (CreatationCompleteCoordinatorProtocol & CreatationCompleteStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = R.string.localizable.back_up_wallet.key.localized()
    }

    override func configureObserveState() {
        comfirmView.cancelButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] touch in
            guard let `self` = self else { return }
            self.coordinator?.dismissCurrentNav(nil)
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}

extension CreatationCompleteViewController {
    @objc func sure_event(_ data:[String:Any]) {
        self.coordinator?.pushBackupPrivateKeyVC()
    }
}
