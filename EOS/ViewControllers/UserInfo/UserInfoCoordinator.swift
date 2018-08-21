//
//  UserInfoCoordinator.swift
//  EOS
//
//  Created koofrank on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import MessageUI
import SwiftyUserDefaults

protocol UserInfoCoordinatorProtocol {
    func openNormalSetting()
    func openSafeSetting()
    func openHelpSetting(delegate:Any)
    func openServersSetting()
    func openAboutSetting()
}

protocol UserInfoStateManagerProtocol {
    var state: UserInfoState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<UserInfoState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class UserInfoCoordinator: UserInfoRootCoordinator {
    
    lazy var creator = UserInfoPropertyActionCreate()
    
    var store = Store<UserInfoState>(
        reducer: UserInfoReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension UserInfoCoordinator: UserInfoCoordinatorProtocol {
    
    func openNormalSetting() {
        if let vc = R.storyboard.userInfo.normalViewController() {
            vc.coordinator = NormalCoordinator(rootVC: self.rootVC)
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
    func openSafeSetting() {
        if let vc = R.storyboard.userInfo.safeViewController() {
            vc.coordinator = SafeCoordinator(rootVC: self.rootVC)
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
    func openHelpSetting(delegate:Any) {
        //首先要判断设备具不具备发送邮件功能
        if MFMailComposeViewController.canSendMail(){
            let controller = MFMailComposeViewController()
            //设置代理
            controller.mailComposeDelegate = delegate as? MFMailComposeViewControllerDelegate
            //设置主题
            controller.setSubject("Gemma feedback")
            //设置收件人
            controller.setToRecipients(["support@nbltrust.com"])
            //设置抄送人
//            controller.setCcRecipients(["b1@hangge.com","b2@hangge.com"])
//            //设置密送人
//            controller.setBccRecipients(["c1@hangge.com","c2@hangge.com"])
            
            //添加图片附件
            //            var path = NSBundle.mainBundle().pathForResource("hangge.png", ofType: "")
            //            var myData = NSData(contentsOfFile: path!)
            //            controller.addAttachmentData(myData, mimeType: "image/png", fileName: "swift.png")
            
            //设置邮件正文内容（支持html）
//            controller.setMessageBody("我是邮件正文", isHTML: false)
            
            //打开界面
            self.rootVC.present(controller, animated: true, completion: nil)
        }else{
            self.rootVC.showError(message: R.string.localizable.no_support_mail())
        }

    }
    func openServersSetting() {
        let vc = BaseWebViewController()
        let language = Defaults[.language]
        if language == "en" {
            vc.url = H5AddressConfiguration.HELP_EN_URL
        } else if language == "zh-Hans" {
            vc.url = H5AddressConfiguration.HELP_CN_URL
        } else {
            
            vc.url = H5AddressConfiguration.HELP_EN_URL
        }
        vc.title = R.string.localizable.mine_server()
        self.rootVC.pushViewController(vc, animated: true)
    }
    func openAboutSetting() {
        if let vc = R.storyboard.userInfo.aboutViewController() {
            vc.coordinator = AboutCoordinator(rootVC: self.rootVC)
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}

extension UserInfoCoordinator: UserInfoStateManagerProtocol {
    var state: UserInfoState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<UserInfoState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
