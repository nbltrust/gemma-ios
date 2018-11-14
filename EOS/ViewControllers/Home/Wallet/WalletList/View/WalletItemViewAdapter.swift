//
//  WalletItemViewAdapter.swift
//  EOS
//
//  Created peng zhu on 2018/11/14.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension WalletItemView {
    func adapterModelToWalletItemView(_ model: Wallet) {
        nameLabel.text = model.name
        let walletId = Int64(Defaults[.currentWalletID])
        selectView.isHidden = ((model.id ?? 0) != walletId)
        logoView.isHidden = (model.type != .bluetooth)
        desLabel.text = desForWallet(model)
    }

    func desForWallet(_ wallet: Wallet) -> String {
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
}
