//
//  BLTCardEntryCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule
import Presentr

protocol BLTCardEntryCoordinatorProtocol {
    func pushIntroduceVC()

    func pushToSetWalletVC()

    func presentBLTCardSearchVC()

    func pushToMnemonicVC()

    func pushToImportVC()

    func dismissVC()

    func presentFingerPrinterVC(_ state: BLTCardPINState)

    func presentPinVC(_ state: BLTCardPINState)
}

protocol BLTCardEntryStateManagerProtocol {
    var state: BLTCardEntryState { get }

    func switchPageState(_ state: PageState)

    func checkPinState()

    func createWookongBioWallet(_ hint: String,
                                success: @escaping SuccessedComplication,
                                failed: @escaping FailedComplication)

    func checkFPExist(_ success: @escaping CompletionCallback,
                      failed: @escaping CompletionCallback)
}

class BLTCardEntryCoordinator: BLTCardRootCoordinator {
    var store = Store(
        reducer: BLTCardEntryReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    var state: BLTCardEntryState {
        return store.state
    }

    override func register() {
        Broadcaster.register(BLTCardEntryCoordinatorProtocol.self, observer: self)
        Broadcaster.register(BLTCardEntryStateManagerProtocol.self, observer: self)
    }
}

extension BLTCardEntryCoordinator: BLTCardEntryCoordinatorProtocol {
    func pushIntroduceVC() {

    }

    func dismissVC() {
        self.rootVC.dismiss(animated: true, completion: nil)
    }

    func pushToSetWalletVC() {
        if let setWalletVC = R.storyboard.leadIn.setWalletViewController() {
            setWalletVC.coordinator = SetWalletCoordinator(rootVC: self.rootVC)
            setWalletVC.settingType = .wookong
            self.rootVC.pushViewController(setWalletVC, animated: true)
        }
    }

    func presentBLTCardSearchVC() {
        BLTWalletIO.shareInstance()?.disConnect({
            let width = ModalSize.full

            let height: Float = 320
            let heightSize = ModalSize.custom(size: height)

            let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height - height.cgFloat))
            let customType = PresentationType.custom(width: width, height: heightSize, center: center)

            let presenter = Presentr(presentationType: customType)
            presenter.keyboardTranslationType = .stickToTop

            let newVC = BaseNavigationController()
            let bltCard = BLTCardRootCoordinator(rootVC: newVC)
            var context = BLTCardSearchContext()
            context.connectSuccessed = { [weak self] () in
                guard let `self` = self else { return }
                self.checkPinState()
            }

            if let searchVC = R.storyboard.bltCard.bltCardSearchViewController() {
                let coordinator = BLTCardSearchCoordinator(rootVC: bltCard.rootVC)
                searchVC.coordinator = coordinator
                coordinator.store.dispatch(RouteContextAction(context: context))
                bltCard.rootVC.pushViewController(searchVC, animated: true)

                self.rootVC.topViewController?.customPresentViewController(presenter, viewController: newVC, animated: true, completion: nil)
            }
        }, failed: { (reason) in
            if let failedReason = reason {
                showFailTop(failedReason)
            }
        })
    }

    func pushToMnemonicVC() {
        let mnemonicWordVC = R.storyboard.mnemonic.backupMnemonicWordViewController()
        let coor = BackupMnemonicWordCoordinator(rootVC: self.rootVC)
        mnemonicWordVC?.coordinator = coor
        mnemonicWordVC?.isWookong = true
        self.rootVC.pushViewController(mnemonicWordVC!, animated: true)
    }

    func pushToImportVC() {
        let leadInVC = R.storyboard.leadIn.leadInViewController()!
        let coordinator = LeadInCoordinator(rootVC: self.rootVC)
        leadInVC.coordinator = coordinator
        self.rootVC.pushViewController(leadInVC, animated: true)
    }

    func presentFingerPrinterVC(_ state: BLTCardPINState) {
        confirmFP(self.rootVC) {
            self.handleWookongPair(state)
        }
    }

    func presentPinVC(_ state: BLTCardPINState) {
        confirmPin(self.rootVC) {
            self.handleWookongPair(state)
        }
    }

    func handleWookongPair(_ state: BLTCardPINState) {
        if state == .finishInit {
            self.rootVC.topViewController?.startLoadingOnSelf(false, message: "")
            self.createWookongBioWallet("", success: {
                self.rootVC.topViewController?.endLoading()
                self.dismissVC()
            }, failed: { (reason) in
                self.rootVC.topViewController?.endLoading()
                if let failedReson = reason {
                    showFailTop(failedReson)
                }
            })
        } else if state == .unFinishInit {
            selectBLTInitType(self.rootVC) { [weak self] (isCreate) in
                guard let `self` = self else {return}
                if isCreate {
                    self.pushToMnemonicVC()
                } else {
                    self.pushToImportVC()
                }
            }
        }
    }
}

extension BLTCardEntryCoordinator: BLTCardEntryStateManagerProtocol {
    func switchPageState(_ state: PageState) {
        self.store.dispatch(PageStateAction(state: state))
    }

    func checkPinState() {
        BLTWalletIO.shareInstance()?.checkPinState({ [weak self] (pinState) in
            guard let `self` = self else { return }
            switch pinState {
            case .unInit:
                self.pushToSetWalletVC()
            case .unFinishInit:
                self.checkFPExist({
                    self.presentFingerPrinterVC(.unFinishInit)
                }, failed: {
                    self.presentPinVC(.unFinishInit)
                })
            case .finishInit:
                self.checkFPExist({
                    self.presentFingerPrinterVC(.finishInit)
                }, failed: {
                    self.presentPinVC(.finishInit)
                })
            }
        }, failed: { (reason) in
            if let failedReason = reason {
                showFailTop(failedReason)
            }
        })
    }

    func createWookongBioWallet(_ hint: String,
                                success: @escaping SuccessedComplication,
                                failed: @escaping FailedComplication) {
        importWookongBioWallet(hint, success: success, failed: failed)
    }

    func checkFPExist(_ success: @escaping CompletionCallback,
                      failed: @escaping CompletionCallback) {
        BLTWalletIO.shareInstance()?.getFPList({ (data) in
            if let list = data, list.count > 0 {
                success()
            } else {
                failed()
            }
        }, failed: { (reason) in
            failed()
        })
    }
}
