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
    var data: PaymentsRecordsViewModel = PaymentsRecordsViewModel()

	override func viewDidLoad() {
        super.viewDidLoad()
    }

    func commonObserveState() {
        coordinator?.subscribe(errorSubscriber) { sub in
            return sub.select { state in state.errorMessage }.skipRepeats({ (_, _) -> Bool in
                return false
            })
        }

        coordinator?.subscribe(loadingSubscriber) { sub in
            return sub.select { state in state.isLoading }.skipRepeats({ (_, _) -> Bool in
                return false
            })
        }
    }

    override func configureObserveState() {
        commonObserveState()

    }
}
