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
        let sectionHeader = R.nib.customTableHeaderView.name
        walletTable.register(UINib.init(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        walletTable.register(UINib.init(nibName: sectionHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: sectionHeader)
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

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = R.nib.customTableHeaderView.name
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: sectionHeader) as? CustomTableHeaderView else {
            return UIView()
        }
        view.title = R.string.localizable.current_wallets.key.localized()
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
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
