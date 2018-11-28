//
//  WalletCurrencyListView.swift
//  EOS
//
//  Created zhusongyu on 2018/11/27.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class WalletCurrencyListView: EOSBaseView {
    @IBOutlet weak var tableView: UITableView!

    enum Event:String {
        case walletCurrencyListViewDidClicked
    }

    var listData: Any? {
        didSet {
            tableView.reloadData()
        }
    }
    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        let nibString = R.nib.currencyListCell.name
        tableView.register(UINib.init(nibName: nibString, bundle: nil), forCellReuseIdentifier: nibString)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
    }
    
    func setupSubViewEvent() {
    
    }
    
    @objc override func didClicked() {
        self.next?.sendEventWith(Event.walletCurrencyListViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}

extension WalletCurrencyListView: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let data = listData as? Wallet {
            let currencys = CurrencyManager.shared.getAllCurrencys(data)
            count += currencys.count
        }
        return count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: CurrencyListCell.self), for: indexPath) as? CurrencyListCell else {
            return UITableViewCell()
        }
        if let data = listData as? Wallet, let currencys = CurrencyManager.shared.getAllCurrencys(data) as? [Currency] {
            cell.setup(currencys, indexPath: indexPath)
        }

        return cell
    }
}
