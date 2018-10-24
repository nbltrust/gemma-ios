//
//  BLTCardConfirmPinViewController.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class BLTCardConfirmPinViewController: BaseViewController {

	var coordinator: (BLTCardConfirmPinCoordinatorProtocol & BLTCardConfirmPinStateManagerProtocol)?

    private(set) var context: BLTCardConfirmPinContext?
    
    @IBOutlet weak var confirmView: TransferConfirmPasswordView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        setupUI()
        setupEvent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func refreshViewController() {

    }

    func setupUI() {
        self.confirmView.title = R.string.localizable.wookong_confirm_pin_title.key.localized()
        self.confirmView.textField.placeholder = R.string.localizable.wookong_confirm_pin_pla.key.localized()
        self.confirmView.btnTitle = R.string.localizable.wookong_confirm_pin_btn.key.localized()
    }

    func setupData() {

    }

    func setupEvent() {

    }

    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }
            
            if let context = context as? BLTCardConfirmPinContext {
                self.context = context
            }
            
        }).disposed(by: disposeBag)
    }
}

// MARK: - TableViewDelegate

//extension BLTCardConfirmPinViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//          let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.<#cell#>.name, for: indexPath) as! <#cell#>
//
//        return cell
//    }
//}

// MARK: - View Event

//extension BLTCardConfirmPinViewController {
//    @objc func <#view#>DidClicked(_ data:[String: Any]) {
//        if let addressdata = data["data"] as? <#model#>, let view = data["self"] as? <#view#>  {
//
//        }
//    }
//}
