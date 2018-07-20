//
//  GestureLockSetViewController.swift
//  EOS
//
//  Created peng zhu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class GestureLockSetViewController: BaseViewController {

    @IBOutlet weak var infoView: GestureLockInfoView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var lockView: GestureLockView!
    
    var coordinator: (GestureLockSetCoordinatorProtocol & GestureLockSetStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func setupUI() {
        
    }
    
    override func configureObserveState() {
        commonObserveState()
        
    }
}
