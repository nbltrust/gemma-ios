//
//  WalletListViewController.swift
//  EOS
//
//  Created peng zhu on 2018/11/14.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class WalletListViewController: BaseViewController {

    @IBOutlet weak var walletListTable: UITableView!
    var coordinator: (WalletListCoordinatorProtocol & WalletListStateManagerProtocol)?
    private(set) var context: WalletListContext?

	override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
        setupEvent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTable()
    }

    override func refreshViewController() {

    }

    func reloadTable() {
        walletListTable.reloadData()
    }

    func setupUI() {
        self.title = R.string.localizable.select_wallet.key.localized()

        let walletNibName = R.nib.walletItemCell.name
        walletListTable.register(UINib.init(nibName: walletNibName, bundle: nil), forCellReuseIdentifier: walletNibName)
    }

    func setupData() {
        loadData()
    }

    func loadData() {
        context?.walletList = WalletManager.shared.walletList()
        walletListTable.reloadData()
    }

    func setupEvent() {

    }

    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }

            if let context = context as? WalletListContext {
                self.context = context
            }

        }).disposed(by: disposeBag)
    }
}

extension WalletListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return context?.walletList.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nibString = R.nib.walletItemCell.name
        let reuseCell = tableView.dequeueReusableCell(withIdentifier: nibString, for: indexPath)
        guard let cell = reuseCell as? WalletItemCell else {
            return UITableViewCell()
        }
        if let wallet = context?.walletList[indexPath.row] {
            cell.itemView.adapterModelToWalletItemView(wallet)
        }
        cell.moreCallback = { [weak self] in
            guard let `self` = self else { return }
            if let wallet = self.context?.walletList[indexPath.row] {
                self.coordinator?.pushToWalletManagerVC(wallet)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let wallet = context?.walletList[indexPath.row] {
            if let currentWallet = WalletManager.shared.currentWallet(), currentWallet.type == .bluetooth {
                BLTWalletIO.shareInstance()?.disConnect({}, failed: { (reason) in})
            }
            self.coordinator?.switchToWallet(wallet)
        }
    }
}
