//
//  WalletCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol WalletCoordinatorProtocol {
    func pushToWalletManager(data: WalletManagerModel)
    func pushToEntryVC()
    func pushToSetWalletVC()

    func pushToLeadInWallet()
}

protocol WalletStateManagerProtocol {
    var state: WalletState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<WalletState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func createSectionOneDataInfo(data: [WalletManagerModel]) -> [LineView.LineViewModel]
    func createSectionTwoDataInfo() -> [LineView.LineViewModel]

}

class WalletCoordinator: HomeRootCoordinator {
    
    lazy var creator = WalletPropertyActionCreate()
    
    var store = Store<WalletState>(
        reducer: WalletReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension WalletCoordinator: WalletCoordinatorProtocol {
    func pushToWalletManager(data: WalletManagerModel) {
        if let vc = R.storyboard.wallet.walletManagerViewController() {
            let coordinator = WalletManagerCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            vc.data = data
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
    
    func pushToEntryVC() {
        if let vc = R.storyboard.entry.entryViewController() {
            let coordinator = EntryCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
    
    func pushToSetWalletVC() {
        if let vc = R.storyboard.entry.entryViewController() {
            let coordinator = EntryCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
    
    func pushToLeadInWallet() {
        if let vc = R.storyboard.leadIn.leadInViewController() {
            let coordinator = LeadInCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}

extension WalletCoordinator: WalletStateManagerProtocol {
    var state: WalletState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<WalletState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
    func createSectionOneDataInfo(data: [WalletManagerModel]) -> [LineView.LineViewModel] {
        var array: [LineView.LineViewModel] = []
        for content: WalletManagerModel in data {
            let model = LineView.LineViewModel.init(name: content.name,
                                        content: "",
                                        image_name: R.image.icTabMore.name,
                                        name_style: LineViewStyleNames.normal_name,
                                        content_style: LineViewStyleNames.normal_content,
                                        isBadge: false,
                                        content_line_number: 1,
                                        isShowLineView: false)
            array.append(model)
        }
        return array
    }
    
    func createSectionTwoDataInfo() -> [LineView.LineViewModel] {
        return [LineView.LineViewModel.init(name: R.string.localizable.import_wallet(),
                                            content: "",
                                            image_name: R.image.icArrow.name,
                                            name_style: LineViewStyleNames.normal_name,
                                            content_style: LineViewStyleNames.normal_content,
                                            isBadge: false,
                                            content_line_number: 1,
                                            isShowLineView: false),
                LineView.LineViewModel.init(name: R.string.localizable.create_wallet(),
                                            content: "",
                                            image_name: R.image.icArrow.name,
                                            name_style: LineViewStyleNames.normal_name,
                                            content_style: LineViewStyleNames.normal_content,
                                            isBadge: false,
                                            content_line_number: 1,
                                            isShowLineView: false)
        ]
    }
}
