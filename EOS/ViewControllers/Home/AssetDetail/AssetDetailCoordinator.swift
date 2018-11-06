//
//  AssetDetailCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol AssetDetailCoordinatorProtocol {
    func pushResourceDetailVC()
    func pushVoteVC()
    func pushTransferVC()
}

protocol AssetDetailStateManagerProtocol {
    var state: AssetDetailState { get }
    
    func switchPageState(_ state:PageState)
    func getDataFromServer(_ account: String, completion: @escaping (Bool) -> Void, isRefresh: Bool)
    func removeStateData()
}

class AssetDetailCoordinator: NavCoordinator {
    var store = Store(
        reducer: gAssetDetailReducer,
        state: nil,
        middleware:[trackingMiddleware]
    )
    
    var state: AssetDetailState {
        return store.state
    }
    override class func start(_ root: BaseNavigationController, context:RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.assetDetail.assetDetailViewController()!
        let coordinator = AssetDetailCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

    override func register() {
        Broadcaster.register(AssetDetailCoordinatorProtocol.self, observer: self)
        Broadcaster.register(AssetDetailStateManagerProtocol.self, observer: self)
    }
}

extension AssetDetailCoordinator: AssetDetailCoordinatorProtocol {
    func pushResourceDetailVC() {
        if let rmVC = R.storyboard.resourceMortgage.resourceDetailViewController() {
            let coordinator = ResourceDetailCoordinator(rootVC: self.rootVC)
            rmVC.coordinator = coordinator
            self.rootVC.pushViewController(rmVC, animated: true)
        }
    }
    func pushVoteVC() {
        if let vodeVC = R.storyboard.home.voteViewController() {
            let coordinator = VoteCoordinator(rootVC: self.rootVC)
            vodeVC.coordinator = coordinator
            self.rootVC.pushViewController(vodeVC, animated: true)
        }
    }
    func pushTransferVC() {
        if let transferVC = R.storyboard.transfer.transferViewController() {
            let coordinator = TransferCoordinator(rootVC: self.rootVC)
            transferVC.coordinator = coordinator
            self.rootVC.pushViewController(transferVC, animated: true)
        }
    }
}

extension AssetDetailCoordinator: AssetDetailStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }

    func getDataFromServer(_ account: String, completion: @escaping (Bool) -> Void, isRefresh: Bool) {
        NBLNetwork.request(target: NBLService.accountHistory(account: account, showNum: 10, lastPosition: isRefresh ? -1 :state.lastPos), success: { (data) in
            let transactions = data["transactions"].arrayValue

            if let lastPos = data["last_pos"].int {
                self.store.dispatch(GetLastPosAction(lastPos: lastPos))

                if let payments = transactions.map({ (json) in
                    Payment.deserialize(from: json.dictionaryObject)
                }) as? [Payment] {
                    self.store.dispatch(FetchPaymentsRecordsListAction(data: payments))
                }
            }

            completion(true)
        }, error: { (code) in

            if let gemmaerror = GemmaError.NBLNetworkErrorCode(rawValue: code) {
                let error = GemmaError.NBLCode(code: gemmaerror)
                showFailTop(error.localizedDescription)
            } else {
                showFailTop(R.string.localizable.error_unknow.key.localized())
            }
            completion(false)

        }) { (_) in
            let payment: [Payment] = []
            self.store.dispatch(FetchPaymentsRecordsListAction(data: payment))
            completion(false)
        }
    }

    func removeStateData() {
        self.store.dispatch(RemoveAction())
    }
}
