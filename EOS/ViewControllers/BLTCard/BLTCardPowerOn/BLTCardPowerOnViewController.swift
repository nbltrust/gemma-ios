//
//  BLTCardPowerOnViewController.swift
//  EOS
//
//  Created peng zhu on 2018/9/30.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

enum PowerOnType: Int {
    case transfer
}

class BLTCardPowerOnViewController: BaseViewController {

	var coordinator: (BLTCardPowerOnCoordinatorProtocol & BLTCardPowerOnStateManagerProtocol)?
    private(set) var context: BLTCardPowerOnContext?

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
        if self.navigationController?.viewControllers.count == 1 {
            self.configLeftNavButton(R.image.icTransferClose())
        } else {
            self.configLeftNavButton(R.image.icBack())
        }
    }

    override func leftAction(_ sender: UIButton) {
        if self.navigationController?.viewControllers.count == 1 {
            self.coordinator?.dismissVC()
        } else {
            self.coordinator?.popVC()
        }
    }
    
    func setupData() {

    }

    func setupEvent() {

    }

    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }

            if let context = context as? BLTCardPowerOnContext {
                self.context = context
            }

        }).disposed(by: disposeBag)
    }
}

// MARK: - TableViewDelegate

//extension BLTCardPowerOnViewController: UITableViewDataSource, UITableViewDelegate {
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

//extension BLTCardPowerOnViewController {
//    @objc func <#view#>DidClicked(_ data:[String: Any]) {
//        if let addressdata = data["data"] as? <#model#>, let view = data["self"] as? <#view#>  {
//
//        }
//    }
//}
