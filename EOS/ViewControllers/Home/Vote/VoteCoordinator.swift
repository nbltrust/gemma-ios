//
//  VoteCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/8/8.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol VoteCoordinatorProtocol {
    func pushSelectedVote()

    func popVC()
}

protocol VoteStateManagerProtocol {
    var state: VoteState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<VoteState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState

    func updateIndexPaths(_ indexPaths: [IndexPath]?)

    func loadVoteList(_ completed: @escaping (Bool) -> Void)

    func getAccountInfo()

    func getAccountInfo(_ account: String)

    func voteSelNodes()
}

class VoteCoordinator: NavCoordinator {
    lazy var creator = VotePropertyActionCreate()

    var store = Store<VoteState>(
        reducer: gVoteReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    override func register() {
        Broadcaster.register(VoteCoordinatorProtocol.self, observer: self)
        Broadcaster.register(VoteStateManagerProtocol.self, observer: self)
    }
}

extension VoteCoordinator: VoteCoordinatorProtocol {
    func pushSelectedVote() {
        let selVoteVC = R.storyboard.home.selectedVoteViewController()
        let coordinator = SelectedVoteCoordinator(rootVC: self.rootVC)
        selVoteVC?.coordinator = coordinator
        self.rootVC.pushViewController(selVoteVC!, animated: true)
    }

    func popVC() {
        self.rootVC.popViewController(animated: true)
    }
}

extension VoteCoordinator: VoteStateManagerProtocol {
    func updateIndexPaths(_ indexPaths: [IndexPath]?) {
        if indexPaths != nil {
            self.store.dispatch(SetSelIndexPathsAction(indexPaths: indexPaths!))
        }
    }

    func loadVoteList(_ completed: @escaping (Bool) -> Void) {
        NBLNetwork.request(target: .producer(showNum: 999), success: {[weak self] (json) in
            let result = json.dictionaryValue
            if let producers = result["producers"]?.arrayValue {
                var nodes: [NodeVoteViewModel] = [NodeVoteViewModel]()
                for producer in producers {
                    let node = NodeVote.deserialize(from: producer.dictionaryObject)
                    var nodeModel = NodeVoteViewModel()
                    nodeModel.name = node?.alias
                    nodeModel.owner = node?.account
                    nodeModel.percent = String(format: "%g", (node?.percentage)! * 100) + "%"
                    nodeModel.url = node?.url
                    nodeModel.rank = " "
                    nodes.append(nodeModel)
                }
                self?.store.dispatch(SetVoteNodeListAction(datas: nodes))
                completed(true)
            } else {
                completed(true)
            }
            }, error: { (_) in
                completed(false)
        }) { (_) in
            completed(false)
        }
    }

    func getAccountInfo() {
        CurrencyManager.shared.fetchAccount(.EOS) { [weak self] in
            guard let `self` = self else { return }
            self.getAccountInfo(CurrencyManager.shared.getCurrentAccountName())
        }
    }

    func getAccountInfo(_ account: String) {
        EOSIONetwork.request(target: .getAccount(account: account, otherNode: false), success: { (json) in
            if let accountObj = Account.deserialize(from: json.dictionaryObject) {
                var delegateInfo = DelegatedInfoModel()

                if let delegatedObj = accountObj.selfDelegatedBandwidth {
                    delegateInfo.delagetedAmount = delegatedObj.cpuWeight.eosAmount.float()! + delegatedObj.netWeight.eosAmount.float()!
                }
                self.store.dispatch(SetDelegatedInfoAction(info: delegateInfo))
            }

        }, error: { (_) in

        }) { (_) in

        }
    }

    func voteSelNodes() {
        let id = CurrencyManager.shared.getCurrentCurrencyID()
        appCoodinator.showPresenterPwd(leftIconType: .dismiss, currencyID: id, type: ConfirmType.voteNode.rawValue, producers: selectedProducers(), completion: nil)
    }

    func selectedProducers() -> [String] {
        var producers: [String] = []
        for indexPath in self.state.property.selIndexPaths {
            let producer = self.state.property.datas[indexPath.row]
            producers.append(producer.owner)
        }
        return producers
    }

    var state: VoteState {
        return store.state
    }

    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<VoteState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }

}
