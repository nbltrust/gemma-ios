//
//  LeadInViewController.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class LeadInViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var coordinator: (LeadInCoordinatorProtocol & LeadInStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
       
        self.title = R.string.localizable.lead_in()
        self.configRightNavButton(R.image.scan_qr_code())
        
    }
    
    override func rightAction(_ sender: UIButton) {
        
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

extension LeadInViewController {
    @objc func switchToKeyView(_ sender : [String:Any]) {
        self.scrollView.setContentOffset(CGPoint(x: self.view.width, y: 0), animated: true)
    }
    @objc func beginLeadInAction(_ sender : [String:Any]) {
        self.coordinator?.openSetWallet()
    }
}
