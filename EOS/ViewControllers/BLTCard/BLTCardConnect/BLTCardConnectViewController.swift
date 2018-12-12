//
//  BLTCardConnectViewController.swift
//  EOS
//
//  Created peng zhu on 2018/10/4.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class BLTCardConnectViewController: BaseViewController {
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var contentLabel: UILabel!

    @IBOutlet weak var connectButton: Button!

    var indicatorView: UIActivityIndicatorView?

    var coordinator: (BLTCardConnectCoordinatorProtocol & BLTCardConnectStateManagerProtocol)?
    private(set) var context: BLTCardConnectContext?

	override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        setupUI()
        setupEvent()
        connectDevice()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func refreshViewController() {

    }

    func setupUI() {
        self.titleLabel.text = R.string.localizable.wookong_connecting_title.key.localized()

        configLeftNavButton(R.image.ic_mask_close())

        indicatorView = UIActivityIndicatorView(style: .gray)
        indicatorView?.hidesWhenStopped = true
        configRightCustomView(indicatorView!)
    }

    override func leftAction(_ sender: UIButton) {
        self.coordinator?.dismissVC({})
    }

    func setupData() {

    }

    func setupEvent() {
        connectButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.connectDevice()
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }

    func connectDevice() {
        indicatorView?.startAnimating()
        resetUI()
        self.coordinator?.reconnectDevice({ [weak self] in
            guard let `self` = self else { return }
            self.indicatorView?.stopAnimating()
            self.navigationController?.dismiss(animated: true, completion: {
                if (self.context?.connectSuccessed != nil) {
                    self.context?.connectSuccessed!()
                }
            })
            }, failed: { [weak self] (reason) in
                guard let `self` = self else { return }
                self.contentLabel.isHidden = true
                self.connectButton.isHidden = false
                self.titleLabel.text = R.string.localizable.wookong_connectfailed_title.key.localized()
                self.indicatorView?.stopAnimating()
                if let failedReason = reason {
                    self.showError(message: failedReason)
                }
        })
    }

    func resetUI() {
        self.contentLabel.isHidden = false
        self.connectButton.isHidden = true
        self.titleLabel.text = R.string.localizable.wookong_connecting_title.key.localized()
    }

    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }

            if let context = context as? BLTCardConnectContext {
                self.context = context
            }

        }).disposed(by: disposeBag)

    }
}

// MARK: - TableViewDelegate

//extension BLTCardConnectViewController: UITableViewDataSource, UITableViewDelegate {
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

//extension BLTCardConnectViewController {
//    @objc func <#view#>DidClicked(_ data:[String: Any]) {
//        if let addressdata = data["data"] as? <#model#>, let view = data["self"] as? <#view#>  {
//
//        }
//    }
//}
