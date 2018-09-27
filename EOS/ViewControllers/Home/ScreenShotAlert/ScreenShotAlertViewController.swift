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
    var context: ScreenShotAlertContext?
    
    @IBOutlet weak var alertView: ScreenShotAlertView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
    }
    
    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: {[weak self] route in
            guard let `self` = self else { return }
            
            if let route = route as? ScreenShotAlertContext {
                self.context = route
                
                self.setupAlertView()
            }
        }).disposed(by: disposeBag)
    }
    
    func setupAlertView() {
        guard let context = context else { return }

        if let imageName = context.imageName {
            self.alertView.titleImage.isHidden = false
            self.alertView.titleImage.image = UIImage(named: imageName)
        }
        else {
            self.alertView.titleImage.isHidden = true
        }
        
        self.alertView.titleLabel.text = context.title
        self.alertView.cancelButton.isHidden = !context.needCancel
        self.alertView.knowButton.setTitle(context.buttonTitle, for: .normal)
        
        if let desc = context.desc {
            self.alertView.tipsLabel.superview?.isHidden = false
            self.alertView.tipsLabel.text = desc
        }
        else {
            self.alertView.tipsLabel.superview?.isHidden = true
        }
        self.alertView.updateHeight()
    }
}

extension ScreenShotAlertViewController {
    @objc func sureShot(_ data:[String: Any]) {
        self.coordinator?.dismiss()

        if let context = self.context, let callback = context.sureShot {
            callback()
        }
  
    }
    
    @objc func cancelShot(_ data:[String: Any]) {
        self.coordinator?.dismiss()
    }
}
