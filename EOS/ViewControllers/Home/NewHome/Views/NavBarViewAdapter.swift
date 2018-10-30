//
//  NavBarViewAdapter.swift
//  EOS
//
//  Created zhusongyu on 2018/10/22.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

extension NavBarView {
    func adapterModelToNavBarView(_ model:Wallet) {
        self.nameLabel.text = model.name
        if model.type != .bluetooth {
            self.bluetoothImgView.isHidden = true
            self.bluetoothStateLabel.isHidden = true
        }
    }
}
