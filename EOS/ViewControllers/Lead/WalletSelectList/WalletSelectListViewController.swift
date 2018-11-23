//
//  WalletSelectListViewController.swift
//  EOS
//
//  Created peng zhu on 2018/11/1.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class WalletSelectListViewController: BaseViewController {

    @IBOutlet weak var walletTable: UITableView!

	var coordinator: (WalletSelectListCoordinatorProtocol & WalletSelectListStateManagerProtocol)?
    private(set) var context: WalletSelectListContext?

    var wallets: [Wallet] = []

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
        self.title = R.string.localizable.leadin_to_wallet.key.localized()

        walletTable.tableFooterView = UIView()
        let cellName = R.nib.walletCheckCell.name
        walletTable.register(UINib.init(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }

    func setupData() {
        do {
            if let wallets = try WalletCacheService.shared.fetchAllWallet() {
                self.wallets = wallets
            }
        } catch {}
    }

    func setupEvent() {

    }

    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }
            if let context = context as? WalletSelectListContext {
                self.context = context
            }
        }).disposed(by: disposeBag)
    }
}

extension WalletSelectListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + (wallets.count > 0 ? 1 : 0)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return wallets.count
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if view.isKind(of: UITableViewHeaderFooterView.classForCoder()) {
            if let headView = view as? UITableViewHeaderFooterView {
                headView.backgroundColor = UIColor.whiteColor
                headView.textLabel?.font = UIFont.systemFont(ofSize: 14)
                headView.textLabel?.textColor = UIColor.subTitleColor
                headView.textLabel?.left = 20
            }
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return R.string.localizable.current_wallets.key.localized()
        }
        return ""
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 45
        }
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellName = R.nib.walletCheckCell.name
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? WalletCheckCell else {
            return UITableViewCell()
        }

        if indexPath.section == 0 {
            cell.title = R.string.localizable.new_wallet.key.localized()
            cell.isChoosed = (self.context?.selectedWallet == nil) || (self.context?.selectedWallet?.id == 0)
        } else {
            let wallet = wallets[indexPath.row]
            cell.title = wallet.name
            cell.isChoosed = self.context?.selectedWallet?.id == wallet.id
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let context = self.coordinator?.state.context.value as? WalletSelectListContext else { return }
        if indexPath.section == 0 {
            context.chooseNewWalletResult.value?()
        } else {
            context.walletSelectResult.value?(wallets[indexPath.row])
        }
        walletTable.reloadData()
        self.coordinator?.popVC()
    }
}
