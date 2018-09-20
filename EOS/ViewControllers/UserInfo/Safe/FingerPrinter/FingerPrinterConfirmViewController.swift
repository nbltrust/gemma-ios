//
//  FingerPrinterConfirmViewController.swift
//  EOS
//
//  Created peng zhu on 2018/8/3.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class FingerPrinterConfirmViewController: BaseViewController {

    @IBOutlet weak var clickView: UIImageView!
    
    @IBOutlet weak var clickLabel: UILabel!
    
    var canDismiss: Bool = true
    
    var coordinator: (FingerPrinterConfirmCoordinatorProtocol & FingerPrinterConfirmStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        self.coordinator?.confirm()
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
    
    override func configureObserveState() {
        clickView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] tap in
            guard let `self` = self else { return }
            self.coordinator?.confirm()
        }).disposed(by: disposeBag)
        
        clickLabel.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] tap in
            guard let `self` = self else { return }
            self.coordinator?.confirm()
        }).disposed(by: disposeBag)
    }
}
