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
        
        self.title = R.string.localizable.payments_detail.key.localized()
        hiddenNavBar()
        self.detailView.data = data
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    
    override func configureObserveState() {
        
    }
}

extension PaymentsDetailViewController {
    @objc func open_safair(_ sender : Any){
        self.coordinator?.openWebView(txid: (data?.hash)!)
    }
}
