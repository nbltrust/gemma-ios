//
//  VoteCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/8/8.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import SwiftNotificationCenter

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
    
    func loadVoteList(_ completed: @escaping (Bool) -> ())
    
    func getAccountInfo()
    
    func getAccountInfo(_ account:String)
    
    func voteSelNodes()
}

class VoteCoordinator: HomeRootCoordinator {
    lazy var creator = VotePropertyActionCreate()
    
    var store = Store<VoteState>(
        reducer: VoteReducer,
        state: nil,
        middleware:[TrackingMiddleware]
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
    
    func loadVoteList(_ completed: @escaping (Bool) -> ()) {
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
            }, error: { (code) in
                completed(false)
        }) { (error) in
            completed(false)
        }
    }
    
    func getAccountInfo() {
        WalletManager.shared.FetchAccount { (account) in
            self.getAccountInfo(WalletManager.shared.getAccount())
        }
    }
    
    func getAccountInfo(_ account:String) {
        EOSIONetwork.request(target: .get_account(account: account, otherNode: false), success: { (json) in
            if let accountObj = Account.deserialize(from: json.dictionaryObject) {
                var delegateInfo = DelegatedInfoModel()
                
                if let delegatedObj = accountObj.self_delegated_bandwidth {
                    delegateInfo.delagetedAmount = delegatedObj.cpu_weight.eosAmount.float()! + delegatedObj.net_weight.eosAmount.float()!
                }
                self.store.dispatch(SetDelegatedInfoAction(info: delegateInfo))
            }
            
        }, error: { (code) in
            
        }) { (error) in
            
        }
    }
    
    func voteSelNodes() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.appcoordinator?.showPresenterPwd(leftIconType: .dismiss, pubKey: WalletManager.shared.currentPubKey, type: confirmType.voteNode.rawValue, producers: selectedProducers(), completion: nil)
        }
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
