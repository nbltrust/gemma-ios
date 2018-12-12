//
//  LeadInMnemonicCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule
import seed39_ios_golang
import Seed39

protocol LeadInMnemonicCoordinatorProtocol {
    func openSetWallet(_ mnemonic: String)

    func dismissNav()

    func presentSetFingerPrinterVC()

    func presentToScanVC()
}

protocol LeadInMnemonicStateManagerProtocol {
    var state: LeadInMnemonicState { get }

    func switchPageState(_ state: PageState)

    func validMnemonic(_ mnemonic: String) -> Bool

    func importForWookong(_ mnemonic: String)
}

class LeadInMnemonicCoordinator: NavCoordinator {
    var store = Store(
        reducer: gLeadInMnemonicReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    var state: LeadInMnemonicState {
        return store.state
    }

    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let selfVC = R.storyboard.leadIn.leadInMnemonicViewController()!
        let coordinator = LeadInMnemonicCoordinator(rootVC: root)
        selfVC.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return selfVC
    }

    override func register() {
        Broadcaster.register(LeadInMnemonicCoordinatorProtocol.self, observer: self)
        Broadcaster.register(LeadInMnemonicStateManagerProtocol.self, observer: self)
    }
}

extension LeadInMnemonicCoordinator: LeadInMnemonicCoordinatorProtocol {
    func openSetWallet(_ mnemonic: String) {
        if let setVC = R.storyboard.leadIn.setWalletViewController() {
            let coordinator = SetWalletCoordinator(rootVC: self.rootVC)
            setVC.coordinator = coordinator
            setVC.settingType = .leadInWithMnemonic
            setVC.mnemonicStr = mnemonic
            self.rootVC.pushViewController(setVC, animated: true)
        }
    }

    func dismissNav() {
        self.rootVC.dismiss(animated: false) {
            self.presentSetFingerPrinterVC()
        }
    }

    func presentSetFingerPrinterVC() {
        let newHomeNav = appCoodinator.newHomeCoordinator.rootVC
        let printerVC = R.storyboard.bltCard.bltCardSetFingerPrinterViewController()!
        let nav = BaseNavigationController.init(rootViewController: printerVC)
        let coor = BLTCardSetFingerPrinterCoordinator(rootVC: nav)
        printerVC.coordinator = coor
        newHomeNav?.present(nav, animated: true, completion: nil)
    }

    func presentToScanVC() {
        let context = ScanContext()
        context.scanResult.accept { (result) in
            if let leadInVC = self.rootVC.topViewController as? LeadInMnemonicViewController {
                leadInVC.mnemonicView.textView.text = result
            }
        }

        presentVC(ScanCoordinator.self, context: context, navSetup: { (nav) in
            nav.navStyle = .clear
        }, presentSetup: nil)
    }
}

extension LeadInMnemonicCoordinator: LeadInMnemonicStateManagerProtocol {
    func switchPageState(_ state: PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }

    func validMnemonic(_ mnemonic: String) -> Bool {
        return Seed39CheckMnemonic(BLTUtils.validSeedWithimportSeed(mnemonic))
    }

    func importForWookong(_ mnemonic: String) {
        self.rootVC.topViewController?.startLoadingOnSelf(false, message: "")
        BLTWalletIO.shareInstance()?.importSeed(mnemonic, success: {
            var hint = ""
            self.rootVC.viewControllers.forEach { (vc) in
                if let setWalletVC = vc as? SetWalletViewController {
                    hint = setWalletVC.fieldView.hintView.textField.text ?? ""
                }
            }
            self.createWookongBioWallet(hint, success: { [weak self] in
                guard let `self` = self else {return}
                self.rootVC.topViewController?.endLoading()
                self.dismissNav()
                }, failed: { (reason) in
                    self.rootVC.topViewController?.endLoading()
                    if let failedReason = reason {
                        showFailTop(failedReason)
                    }
            })
        }, failed: { (reason) in
            self.rootVC.topViewController?.endLoading()
            if let reason = reason {
                showFailTop(reason)
            }
        })
    }

    func createWookongBioWallet(_ hint: String,
                                success: @escaping SuccessedComplication,
                                failed: @escaping FailedComplication) {
        importWookongBioWallet(self.rootVC, hint: hint, success: success, failed: failed)
    }
}
