//
//  PaymentsDetailViewController.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/10.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class PaymentsDetailViewController: BaseViewController {

	var coordinator: (PaymentsDetailCoordinatorProtocol & PaymentsDetailStateManagerProtocol)?
    var data : PaymentsRecordsViewModel?
    
    @IBOutlet weak var detailView: DetailView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = R.string.localizable.payments_history()
        hiddenNavBar()
        self.detailView.data = data
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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

extension PaymentsDetailViewController {
    @objc func open_safair(_ sender : Any){
       self.coordinator?.openWebView()
    }
}
