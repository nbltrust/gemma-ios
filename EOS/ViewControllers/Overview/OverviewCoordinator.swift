//
//  OverviewCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule
import Presentr

protocol OverviewCoordinatorProtocol {
    func pushToDetailVC(_ model: AssetViewModel)
    func pushAccountList(_ complication: @escaping () -> Void)
}

protocol OverviewStateManagerProtocol {
    var state: OverviewState { get }
    
    func switchPageState(_ state:PageState)

    func getTokensWith(_ account: String)
    func getAccountInfo(_ account: String)
}

class OverviewCoordinator: NavCoordinator {
    var store = Store(
        reducer: gOverviewReducer,
        state: nil,
        middleware:[trackingMiddleware]
    )
    
    var state: OverviewState {
        return store.state
    }
    
    override class func start(_ root: BaseNavigationController, context:RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.home.overviewViewController()!
        let coordinator = OverviewCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

    override func register() {
        Broadcaster.register(OverviewCoordinatorProtocol.self, observer: self)
        Broadcaster.register(OverviewStateManagerProtocol.self, observer: self)
    }
}

extension OverviewCoordinator: OverviewCoordinatorProtocol {
    func pushToDetailVC(_ model: AssetViewModel) {
        var context = AssetDetailContext()
        context.model = model
        self.pushVC(AssetDetailCoordinator.self, animated: true, context: context)
    }

    func pushAccountList(_ complication: @escaping () -> Void) {
        let width = ModalSize.full
        let height = ModalSize.custom(size: 272)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height - 272))
        let customType = PresentationType.custom(width: width, height: height, center: center)

        let presenter = Presentr(presentationType: customType)
        presenter.keyboardTranslationType = .stickToTop

        var context = AccountListContext()
        context.didSelect = {
            complication()
        }

        presentVC(AccountListCoordinator.self, animated: true, context: context, navSetup: { (nav) in
            nav.navStyle = .common
        }) { (top, target) in
            top.customPresentViewController(presenter, viewController: target, animated: true, completion: nil)
        }
    }
}

extension OverviewCoordinator: OverviewStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }

    func getTokensWith(_ account: String) {
        NBLNetwork.request(target: .getTokens(account: account), success: { (data) in
            let tokens = data["tokens"].arrayValue
            if let tokenArr = tokens.map({ (json) in
                Tokens.deserialize(from: json.dictionaryObject)
            }) as? [Tokens] {
                self.store.dispatch(TokensFetchedAction(data: tokenArr))
            }
        }, error: { (_) in

        }) { (_) in

        }
    }
    func getAccountInfo(_ account: String) {
        EOSIONetwork.request(target: .getCurrencyBalance(account: account), success: { (json) in
            self.store.dispatch(MBalanceFetchedAction(balance: json))
        }, error: { (_) in

        }) { (_) in

        }

        EOSIONetwork.request(target: .getAccount(account: account, otherNode: false), success: { (json) in
            if let accountObj = Account.deserialize(from: json.dictionaryObject) {
                self.store.dispatch(MAccountFetchedAction(info: accountObj))
            }

        }, error: { (_) in

        }) { (_) in

        }

        SimpleHTTPService.requestETHPrice().done { (json) in
            self.store.dispatch(RMBPriceFetchedAction(currency: nil))
            }.cauterize()
    }
}
