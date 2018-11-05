//
//  PaymentsViewController.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/10.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import ESPullToRefresh

class PaymentsViewController: BaseViewController {

    @IBOutlet weak var contentView: PaymentView!
    var coordinator: (PaymentsCoordinatorProtocol & PaymentsStateManagerProtocol)?
    var data = [PaymentsRecordsViewModel]()
    var isNoMoreData: Bool = false

	override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupEvent()
    }

    func setupUI() {
        self.title = R.string.localizable.payments_history.key.localized()
    }

    func setupEvent() {
        self.startLoading()

        self.coordinator?.getDataFromServer(CurrencyManager.shared.getCurrentAccountName(), completion: {[weak self] (success) in
            guard let `self` = self else { return }

            if success {
                self.endLoading()
                self.data.removeAll()
                if (self.coordinator?.state.property.data)!.count < 10 {
                    self.isNoMoreData = true
                }
                if (self.coordinator?.state.property.data)!.count == 0 {
                    self.contentView.isHidden = true
                } else {
                    self.contentView.isHidden = false
                }

                self.data += (self.coordinator?.state.property.data)!
                self.contentView.adapterModelToPaymentView(self.data)
            }

            }, isRefresh: true)

        self.addPullToRefresh(self.contentView.tableView) {[weak self] (completion) in
            guard let `self` = self else {return}

            self.coordinator?.getDataFromServer(CurrencyManager.shared.getCurrentAccountName(), completion: {[weak self] (success) in
                guard let `self` = self else {return}

                if success {
                    self.data.removeAll()
                    if (self.coordinator?.state.property.data)!.count < 10 {
                        self.isNoMoreData = true
                    } else {
                        self.isNoMoreData = false
                    }
                    completion?()
                    self.data += (self.coordinator?.state.property.data)!
                    self.contentView.adapterModelToPaymentView(self.data)
                } else {
                }
            }, isRefresh: true)
        }

        self.addInfiniteScrolling(self.contentView.tableView) {[weak self] (completion) in
            guard let `self` = self else {return}

            if self.isNoMoreData {
                completion?(true)
                return
            }
            self.coordinator?.getDataFromServer(CurrencyManager.shared.getCurrentAccountName(), completion: { [weak self](_) in
                guard let `self` = self else {return}
                if (self.coordinator?.state.property.data.count)! < 10 {
                    self.isNoMoreData = true
                    completion?(true)
                } else {
                    completion?(false)
                }
                self.data += (self.coordinator?.state.property.data)!
                self.contentView.adapterModelToPaymentView(self.data)
            }, isRefresh: false)
        }
    }

    override func configureObserveState() {

    }

}

