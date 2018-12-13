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
    var indicatorView: UIActivityIndicatorView?
    @IBOutlet weak var promoteLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
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

    override func rightAction(_ sender: UIButton) {
        self.reloadRightItem(false)
        if self.context?.actionRetry != nil {
            self.context?.actionRetry!()
        }
    }

    func reloadRightItem(_ isStoped: Bool) {
        if isStoped {
            configRightNavButton(R.image.ic_retry())
            indicatorView?.stopAnimating()
        } else {
            if indicatorView == nil {
                indicatorView = UIActivityIndicatorView(style: .gray)
                indicatorView?.hidesWhenStopped = true
            }
            configRightCustomView(indicatorView!)
            indicatorView?.startAnimating()
        }
    }

    func setupUI() {
        if self.navigationController?.viewControllers.count == 1 {
            self.configLeftNavButton(R.image.ic_mask_close())
        } else {
            self.configLeftNavButton(R.image.ic_mask_back())
        }
        if !(self.context?.promate?.isEmpty ?? true) {
            promoteLabel.text = self.context?.promate
        }

        if self.context?.needAttention ?? false {
            imageView.image = R.image.card_open_attention()
        }
    }

    override func leftAction(_ sender: UIButton) {
        self.coordinator?.cancelWaitPowerButtonPress()
        self.coordinator?.handleVCChange()
    }

    func setupData() {
        reloadRightItem(false)
    }

    func setupEvent() {
        BLTWalletIO.shareInstance()?.powerButtonPressed = { [weak self] in
            guard let `self` = self else {return}
            if self.navigationController?.viewControllers.count == 0 {
                self.coordinator?.popVC()
            } else {
                self.navigationController?.dismiss(animated: true, completion: {
                    if self.context?.powerButtonPressed != nil {
                        self.context?.powerButtonPressed!()
                    }
                })
            }
        }
        BLTWalletIO.shareInstance()?.powerButtonFailed = { [weak self] in
            guard let `self` = self else {return}
            self.reloadRightItem(true)
        }
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
