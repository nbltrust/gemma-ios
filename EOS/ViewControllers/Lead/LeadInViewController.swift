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

    var coordinator: (LeadInCoordinatorProtocol & LeadInStateManagerProtocol)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        self.title = R.string.localizable.lead_in.key.localized()
    }

    override func configureObserveState() {

    }
}

extension LeadInViewController {
    @objc func switchToKeyView(_ sender: [String: Any]) {
        self.coordinator?.openLeadInKey()
    }

}
