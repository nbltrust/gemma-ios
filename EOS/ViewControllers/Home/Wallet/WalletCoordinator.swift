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

    func pushToLeadInWallet()

    func popToLastVC()

    func pushToBLTEntryVC()
}

protocol WalletStateManagerProtocol {
    var state: WalletState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<WalletState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState

    func createSectionOneDataInfo(data: [WalletManagerModel]) -> [LineView.LineViewModel]
    func createSectionTwoDataInfo() -> [LineView.LineViewModel]

    func switchWallet(_ pubKey: String)
}

class WalletCoordinator: NavCoordinator {

    lazy var creator = WalletPropertyActionCreate()

    var store = Store<WalletState>(
        reducer: WalletReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )
}

extension WalletCoordinator: WalletCoordinatorProtocol {
    func popToLastVC() {
        self.rootVC.popViewController()
    }

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
            coordinator.state.callback.endCallback.accept {[weak self] in
                guard let `self` = self else { return }
                self.rootVC.popToRootViewController(animated: true)
            }
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }

    func pushToLeadInWallet() {
        if let vc = R.storyboard.leadIn.leadInViewController() {
            let coordinator = LeadInCoordinator(rootVC: self.rootVC)
            let lastVC = self.rootVC.viewControllers[self.rootVC.viewControllers.count - 2]
            coordinator.state.callback.fadeCallback.accept {
                self.rootVC.popToViewController(lastVC, animated: true)
            }
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }

    func pushToBLTEntryVC() {
        if let vc = R.storyboard.bltCard.bltCardEntryViewController() {
            let coordinator = BLTCardEntryCoordinator(rootVC: self.rootVC)
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
                                        imageName: R.image.icTabMore.name,
                                        nameStyle: LineViewStyleNames.normalName,
                                        contentStyle: LineViewStyleNames.normalContent,
                                        isBadge: false,
                                        contentLineNumber: 1,
                                        isShowLineView: false)
            array.append(model)
        }
        return array
    }

    func createSectionTwoDataInfo() -> [LineView.LineViewModel] {
        return [LineView.LineViewModel.init(name: R.string.localizable.import_wallet.key.localized(),
                                            content: "",
                                            imageName: R.image.icArrow.name,
                                            nameStyle: LineViewStyleNames.normalName,
                                            contentStyle: LineViewStyleNames.normalContent,
                                            isBadge: false,
                                            contentLineNumber: 1,
                                            isShowLineView: false),
                LineView.LineViewModel.init(name: R.string.localizable.create_wallet.key.localized(),
                                            content: "",
                                            imageName: R.image.icArrow.name,
                                            nameStyle: LineViewStyleNames.normalName,
                                            contentStyle: LineViewStyleNames.normalContent,
                                            isBadge: false,
                                            contentLineNumber: 1,
                                            isShowLineView: false),
                LineView.LineViewModel.init(name: R.string.localizable.pair_wookong.key.localized(),
                                            content: "",
                                            imageName: R.image.icArrow.name,
                                            nameStyle: LineViewStyleNames.normalName,
                                            contentStyle: LineViewStyleNames.normalContent,
                                            isBadge: false,
                                            contentLineNumber: 1,
                                            isShowLineView: false)
        ]
    }

    func switchWallet(_ pubKey: String) {
        WalletManager.shared.switchWallet(pubKey)
        WalletManager.shared.fetchAccountNames(pubKey) { (_) in

        }
    }
}
