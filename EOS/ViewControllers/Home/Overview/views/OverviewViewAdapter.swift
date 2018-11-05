//
//  OverviewViewAdapter.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

extension OverviewView {
    func adapterModelToOverviewView(_ model:[AssetViewModel]) {
        self.assetData = model
    }
    func adapterCardModelToOverviewView(_ model:NewHomeViewModel) {
        self.headView.cardView.adapterModelToCardView(model)
        self.cardData = model

        var newModel = AssetViewModel()
        newModel.icon = ""
        newModel.name = model.currency
        newModel.total = model.allAssets
        newModel.CNY = model.CNY
        self.assetData = [newModel]
    }
}
