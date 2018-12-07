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
import SwiftyUserDefaults
import SwiftDate

protocol AssetDetailCoordinatorProtocol {
    func pushResourceDetailVC()
    func pushVoteVC()
    func pushTransferVC(_ model: AssetViewModel)
    func pushReceiptVC(_ model: AssetViewModel)
    func pushPaymentsDetail(data: PaymentsRecordsViewModel)
    func getAccountInfo(_ account: String)
    func getTokensWith(_ account: String, symbol: String)
    func popVC()
}

protocol AssetDetailStateManagerProtocol {
    var state: AssetDetailState { get }
    
    func switchPageState(_ state:PageState)
    func getDataFromServer(_ account: String, symbol: String, contract: String, completion: @escaping (Bool) -> Void, isRefresh: Bool)
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
    func popVC() {
        for viewController in self.rootVC.viewControllers {
            if viewController is ResourceMortgageViewController {
                for viewController2 in self.rootVC.viewControllers {
                    if let overVC = viewController2 as? OverviewViewController {
                        self.rootVC.popToViewController(overVC, animated: true)
                        return
                    }
                }
            }
        }
        self.rootVC.popViewController()
    }
}

extension AssetDetailCoordinator: AssetDetailStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }

    func getDataFromServer(_ account: String, symbol: String, contract: String, completion: @escaping (Bool) -> Void, isRefresh: Bool) {

        self.store.dispatch(GetLastPosAction(lastPos: self.state.lastPos, isRefresh: isRefresh))
        NBLNetwork.request(target: NBLService.accountHistory(account: account, showNum: 10, lastPosition: state.lastPos, symbol: symbol, contract: contract), success: { (data) in
            let transactions = data["trace_list"].arrayValue

            if let payments = transactions.map({ (json) in
                Payment.deserialize(from: json.dictionaryObject)
            }) as? [Payment] {
                self.store.dispatch(FetchPaymentsRecordsListAction(data: payments))
                self.getChainInfo(completion: { (lib) in
                    if let libStr = lib {
                        for payment in payments {
                            EOSIONetwork.request(target: .getTransaction(id: payment.trxId), success: { (block) in
                                if let errorcode = block["errno"].stringValue as? String, errorcode == "0" {
                                    if let data = GetTransaction.deserialize(from: block["data"].dictionaryObject) {
                                        let blocknum = data.blockNum
                                        self.store.dispatch(GetBlockNumAction(blockNum: blocknum, libNum: libStr, trxId: payment.trxId, status: nil))
                                    }
                                } else if let errorcode = block["errno"].stringValue as? String, errorcode == "3040011" {
                                    let time = block["timestamp"].stringValue.toDate("yyyy-MM-dd'T'HH:mm:ss.SSSSSS", region: Region.ISO)!
                                    let currentTime = Date().string().toDate("yyyy-MM-dd'T'HH:mm:ss.SSSSSS", region: Region.ISO)!
                                    if currentTime > time {
                                        self.store.dispatch(GetBlockNumAction(blockNum: nil, libNum: libStr, trxId: payment.trxId, status: .fail))
                                    }
                                }
                            }, error: { (_) in
                            }, failure: { (_) in
                            })
                        }
                    }
                })
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
//            let payment: [Payment] = []
//            self.store.dispatch(FetchPaymentsRecordsListAction(data: payment))
            completion(false)
        }
    }

    func getChainInfo(completion: @escaping (String?) -> Void) {
        EOSIONetwork.request(target: .getInfo, success: { (info) in
            let lib = info["last_irreversible_block_num"].stringValue
            completion(lib)
        }, error: { (_) in
            completion(nil)
        }, failure: { (_) in
            completion(nil)
        })
    }

    func getAccountInfo(_ account: String) {
        EOSIONetwork.request(target: .getCurrencyBalance(account: account), success: { (json) in
            self.store.dispatch(MBalanceFetchedAction(balance: json))
        }, error: { (_) in

        }) { (_) in

        }

        SimpleHTTPService.requestETHPrice().done { (json) in
            CurrencyManager.shared.savePriceJsonWith(nil, json: json)
            self.store.dispatch(RMBPriceFetchedAction(currency: nil))
            }.cauterize()
    }
    func getTokensWith(_ account: String, symbol: String) {
        NBLNetwork.request(target: .getTokens(account: account), success: { (data) in
            let tokens = data["tokens"].arrayValue
            if let tokenArr = tokens.map({ (json) in
                Tokens.deserialize(from: json.dictionaryObject)
            }) as? [Tokens] {
                self.store.dispatch(ATokensFetchedAction(data: tokenArr, symbol: symbol))
            }
        }, error: { (_) in

        }) { (_) in

        }
    }
}
