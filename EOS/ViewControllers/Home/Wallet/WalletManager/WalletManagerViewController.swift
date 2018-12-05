//
//  WalletManagerViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import SwiftyUserDefaults

class WalletManagerViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    var coordinator: (WalletManagerCoordinatorProtocol & WalletManagerStateManagerProtocol)?
    var wallet: Wallet!

	override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        WalletManager.shared.saveManagerWallet(wallet)
        reloadFootView()
    }

    func setUpUI() {
        self.title = R.string.localizable.manager_wallet.key.localized()

        let walletNibName = R.nib.verCustomCell.name
        tableView.register(UINib.init(nibName: walletNibName, bundle: nil), forCellReuseIdentifier: walletNibName)

        let customNibName = R.nib.customCell.name
        tableView.register(UINib.init(nibName: customNibName, bundle: nil), forCellReuseIdentifier: customNibName)

        let wookongNibName = R.nib.wookongBioInfoCell.name
        tableView.register(UINib.init(nibName: wookongNibName, bundle: nil), forCellReuseIdentifier: wookongNibName)
    }

    func reloadUI() {
        tableView.reloadData()
        reloadFootView()
    }

    func reloadFootView() {
        if wallet.type == .bluetooth {
            let footView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 84))

            let connectTitle = R.string.localizable.connect.key.localized()
            let disConnectTitle = R.string.localizable.disconnect.key.localized()
            let isConnect = BLTWalletIO.shareInstance()?.isConnection() ?? false
            let btn = Button.init(frame: CGRect.init(x: 35, y: 40, width: footView.width - 70, height: 44))
            btn.title = isConnect ? disConnectTitle : connectTitle
            btn.style = isConnect ? ButtonStyle.border.rawValue : ButtonStyle.full.rawValue
            btn.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
                guard let `self` = self else { return }
                self.buttonClick()
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
            footView.addSubview(btn)

            tableView.tableFooterView = footView
        } else {
            tableView.tableFooterView = UIView()
        }
    }

    func titles() -> [String] {
        switch wallet.type {
        case .HD:
            return [wallet.name,
                    R.string.localizable.wookong_export_mnemonic.key.localized(),
                    R.string.localizable.export_private_key.key.localized(),
                    R.string.localizable.change_password.key.localized()]
        case .bluetooth:
            return [wallet.name,
                    R.string.localizable.fingerprint_password.key.localized()]
        case .nonHD:
            return [wallet.name,
                    R.string.localizable.change_password.key.localized()]
        }
    }

    func subTitle() -> String {
        if wallet.type == .bluetooth {
            return R.string.localizable.mutable_currency_blt.key.localized()
        } else {
            let currencys = CurrencyManager.shared.getAllCurrencys(wallet)
            if currencys.count == 1 {
                let currency = currencys[0]
                return  R.string.localizable.single_currency(currency.type.des)
            } else {
                return R.string.localizable.mutable_currency.key.localized()
            }
        }
    }

    func numberOfRows() -> Int {
        switch wallet.type {
        case .HD:
            return 4
        case .bluetooth:
            let isConnected = BLTWalletIO.shareInstance()?.isConnection() ?? false
            return isConnected ? 2 : 1
        case .nonHD:
            return 2
        }
    }

    func buttonClick() {
        let isConnect = BLTWalletIO.shareInstance()?.isConnection() ?? false
        if isConnect {
            self.coordinator?.disConnect({ [weak self] () in
                guard let `self` = self else { return }
                self.reloadUI()
            })
        } else {
            self.coordinator?.connect(wallet.deviceName, complication: { [weak self] () in
                guard let `self` = self else { return }
                self.reloadUI()
            })
        }
    }

    override func configureObserveState() {

    }
}

extension WalletManagerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if wallet.type == .bluetooth {
                let nibString = R.nib.wookongBioInfoCell.name
                let reuseCell = tableView.dequeueReusableCell(withIdentifier: nibString, for: indexPath)
                guard let cell = reuseCell as? WookongBioInfoCell else {
                    return UITableViewCell()
                }
                cell.title = titles()[indexPath.row]
                cell.subTitle = subTitle()
                return cell
            } else {
                let nibString = R.nib.verCustomCell.name
                let reuseCell = tableView.dequeueReusableCell(withIdentifier: nibString, for: indexPath)
                guard let cell = reuseCell as? VerCustomCell else {
                    return UITableViewCell()
                }
                cell.title = titles()[indexPath.row]
                cell.subTitle = subTitle()
                return cell
            }
        } else {
            let nibString = R.nib.customCell.name
            let reuseCell = tableView.dequeueReusableCell(withIdentifier: nibString, for: indexPath)
            guard let cell = reuseCell as? CustomCell else {
                return UITableViewCell()
            }
            cell.title = titles()[indexPath.row]
            cell.subTitle = ""
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch wallet.type {
        case .HD:
            if indexPath.row == 0 {
                self.coordinator?.pushToChangeWalletName(wallet)
            } else if indexPath.row == 1 {
                self.coordinator?.pushToBackupMnemonicVC()
            } else if indexPath.row == 2 {
                self.coordinator?.pushToExportPrivateKey(wallet)
            } else {
                self.coordinator?.pushToChangePassword(wallet)
            }
        case .bluetooth:
            if indexPath.row == 0 {
                self.coordinator?.pushToWookongBioDetail(wallet)
            } else if indexPath.row == 1 {
                self.coordinator?.pushToFingerVC(wallet)
            }
        case .nonHD:
            if indexPath.row == 0 {
                self.coordinator?.pushToChangeWalletName(wallet)
            } else if indexPath.row == 1 {
                self.coordinator?.pushToChangePassword(wallet)
            }
        }
    }
}
