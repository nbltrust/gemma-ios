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
    func pushTransferVC(_ model: AssetViewModel)
    func pushReceiptVC(_ model: AssetViewModel)
    func pushPaymentsDetail(data: PaymentsRecordsViewModel)
}

protocol AssetDetailStateManagerProtocol {
    var state: AssetDetailState { get }
    
    func switchPageState(_ state:PageState)
    func getDataFromServer(_ account: String, symbol: String, contract: String, completion: @escaping (Bool) -> Void, isRefresh: Bool)
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
    func pushTransferVC(_ model: AssetViewModel) {
        var context = TransferContext()
        context.model = model
        self.pushVC(TransferCoordinator.self, context: context)
    }
    func pushReceiptVC(_ model: AssetViewModel) {
        var context = ReceiptContext()
        context.model = model
        pushVC(ReceiptCoordinator.self, context: context)
    }
    func pushPaymentsDetail(data: PaymentsRecordsViewModel) {
        let vc = R.storyboard.paymentsDetail.paymentsDetailViewController()!
        let coordinator = PaymentsDetailCoordinator(rootVC: self.rootVC)
        vc.coordinator = coordinator
        vc.data = data
        self.rootVC.pushViewController(vc, animated: true)
    }
}

extension AssetDetailCoordinator: AssetDetailStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }

    func getDataFromServer(_ account: String, symbol: String, contract: String, completion: @escaping (Bool) -> Void, isRefresh: Bool) {
        NBLNetwork.request(target: NBLService.accountHistory(account: account, showNum: 10, lastPosition: isRefresh ? 1 :state.lastPos, symbol: symbol, contract: contract), success: { (data) in
            let transactions = data["trace_list"].arrayValue

            if let lastPos = data["trace_count"].int {
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