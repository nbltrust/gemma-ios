//
//  WalletViewController.swift
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

class WalletViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    var coordinator: (WalletCoordinatorProtocol & WalletStateManagerProtocol)?
    var dataArray: [WalletManagerModel] = []

	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupData() {
        var indexPath = 0

        for (index, wallet) in WalletManager.shared.wallketList().enumerated() {
            var model = WalletManagerModel()
            model.name = wallet.name ?? "--"
            model.address = wallet.publicKey ?? "--"
            model.type = wallet.type ?? .gemma
            if model.type == .bluetooth {
                model.connected = BLTWalletIO.shareInstance()?.isConnection() ?? false
            }

            if model.name == WalletManager.shared.currentWallet()?.name {
                indexPath = index
            }

            dataArray.append(model)
        }

        tableView.reloadData()
        tableView.selectRow(at: IndexPath(row: indexPath, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.none)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dataArray.removeAll()
        setupData()
    }

    func setupUI() {
        self.title = R.string.localizable.tabbarWallet.key.localized()

        let homeNibString = R.nib.homeTableCell.identifier
        tableView.register(UINib.init(nibName: homeNibString, bundle: nil), forCellReuseIdentifier: homeNibString)

        let walletNibString = R.nib.walletTableViewCell.name
        tableView.register(UINib.init(nibName: walletNibString, bundle: nil), forCellReuseIdentifier: walletNibString)
    }

    override func configureObserveState() {

    }
}

extension WalletViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = WalletListHeaderView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 52))

        if section == 0 {
            headView.titleText = R.string.localizable.have_wallet.key.localized()
        } else {
            headView.titleText = R.string.localizable.wallet_manager.key.localized()
        }
        return headView

    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (self.coordinator?.createSectionOneDataInfo(data: dataArray).count)!
        } else {
            return (self.coordinator?.createSectionTwoDataInfo().count)!
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let nibString = String.init(describing: type(of: WalletTableViewCell()))
            let cell = tableView.dequeueReusableCell(withIdentifier: nibString, for: indexPath) as! WalletTableViewCell

            cell.setup(self.coordinator?.createSectionOneDataInfo(data: dataArray)[indexPath.row], indexPath: indexPath)
            return cell

        } else {

            let nibString = String.init(describing: type(of: HomeTableCell()))
            let cell = tableView.dequeueReusableCell(withIdentifier: nibString, for: indexPath) as! HomeTableCell

            cell.setup(self.coordinator?.createSectionTwoDataInfo()[indexPath.row], indexPath: indexPath)
            return cell
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
//            let pub = dataArray[indexPath.row].address
//                self.coordinator?.switchWallet(pub)
//                self.coordinator?.popToLastVC()
//            }
            if let wallet = WalletManager.shared.currentWallet(), wallet.publicKey != dataArray[indexPath.row].address {
                self.coordinator?.switchWallet(dataArray[indexPath.row].address)
                self.coordinator?.popToLastVC()
            } else {
                self.coordinator?.popToLastVC()
            }
        } else {
            switch indexPath.row {
            case 0:self.coordinator?.pushToLeadInWallet()
            case 1:self.coordinator?.pushToEntryVC()
            case 2:self.coordinator?.pushToBLTEntryVC()
            default:
                break
            }
        }

    }
}

extension WalletViewController {
    @objc func right_event(_ data: [String: Any]) {
        if let index = data["index"] as? String {
            self.coordinator?.pushToWalletManager(data: dataArray[index.int!])
        }
    }
}
