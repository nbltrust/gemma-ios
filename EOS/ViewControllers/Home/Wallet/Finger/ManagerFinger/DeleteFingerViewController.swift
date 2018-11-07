//
//  DeleteFingerViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/10/12.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import SwiftyUserDefaults

class DeleteFingerViewController: BaseViewController {

	var coordinator: (DeleteFingerCoordinatorProtocol & DeleteFingerStateManagerProtocol)?
    private(set) var context: DeleteFingerContext?
    @IBOutlet weak var contentView: DeleteFingerView!

    var model = WalletManagerModel()
    var index = 0

	override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupEvent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
    }

    override func refreshViewController() {

    }

    func setupUI() {
        self.title = R.string.localizable.manager_finger.key.localized()
    }

    func setupData() {
        self.contentView.changeNameLineView.contentText = FingerManager.shared.fingerName(model, index: index)
    }

    func setupEvent() {

    }

    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }

            if let context = context as? DeleteFingerContext {
                self.context = context
            }

        }).disposed(by: disposeBag)
    }
}

// MARK: - TableViewDelegate

//extension DeleteFingerViewController: UITableViewDataSource, UITableViewDelegate {
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

extension DeleteFingerViewController {
    @objc func changeNameViewDidClicked(_ data: [String: Any]) {
        self.coordinator?.pushToChangeWalletName(model: self.model, index: self.index)
    }
    @objc func deleteBtnDidClicked(_ data: [String: Any]) {
        self.coordinator?.deleteCurrentFinger(model, index: index)
    }
}
