//
//  ResourceMortgageCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/7/24.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import Presentr

protocol ResourceMortgageCoordinatorProtocol {
    func presentMortgageConfirmVC(data: ConfirmViewModel)
}

protocol ResourceMortgageStateManagerProtocol {
    var state: ResourceMortgageState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<ResourceMortgageState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func getAccountInfo(_ account:String)
}

class ResourceMortgageCoordinator: HomeRootCoordinator {
    
    lazy var creator = ResourceMortgagePropertyActionCreate()
    
    var store = Store<ResourceMortgageState>(
        reducer: ResourceMortgageReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension ResourceMortgageCoordinator: ResourceMortgageCoordinatorProtocol {
    func presentMortgageConfirmVC(data: ConfirmViewModel) {
        let width = ModalSize.full
        let height = ModalSize.custom(size: 323)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height - 323))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let presenter = Presentr(presentationType: customType)
        presenter.dismissOnTap = false
        presenter.keyboardTranslationType = .moveUp
        
        let newVC = BaseNavigationController()
        newVC.navStyle = .white
        let transferConfirm = TransferConfirmRootCoordinator(rootVC: newVC)
        
        self.rootVC.topViewController?.customPresentViewController(presenter, viewController: newVC, animated: true, completion: nil)
        //        transferConfirm .start()
        if let vc = R.storyboard.transfer.transferConfirmViewController() {
            let coordinator = TransferConfirmCoordinator(rootVC: transferConfirm.rootVC)
            vc.coordinator = coordinator
            vc.data = data
            transferConfirm.rootVC.pushViewController(vc, animated: true)
        }
        
        
    }
}

extension ResourceMortgageCoordinator: ResourceMortgageStateManagerProtocol {
    var state: ResourceMortgageState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<ResourceMortgageState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
    func getAccountInfo(_ account:String) {
        EOSIONetwork.request(target: .get_currency_balance(account: account), success: { (json) in
            self.store.dispatch(MBalanceFetchedAction(balance: json))
        }, error: { (code) in
            
        }) { (error) in
            
        }
        
        EOSIONetwork.request(target: .get_account(account: account), success: { (json) in
            if let accountObj = Account.deserialize(from: json.dictionaryObject) {
                self.store.dispatch(MAccountFetchedAction(info: accountObj))
            }
            
        }, error: { (code) in
            
        }) { (error) in
            
        }
        
        SimpleHTTPService.requestETHPrice().done { (json) in
            if let eos = json.filter({ $0["name"].stringValue == NetworkConfiguration.EOSIO_DEFAULT_SYMBOL }).first {
                self.store.dispatch(MRMBPriceFetchedAction(price: eos))
            }
            
            }.cauterize()
    }
}
