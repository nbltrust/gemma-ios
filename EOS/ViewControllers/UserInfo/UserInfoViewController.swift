//
//  UserInfoViewController.swift
//  EOS
//
//  Created koofrank on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import MessageUI

class UserInfoViewController: BaseViewController {
    
    @IBOutlet weak var customView: NormalCellView!
    
    @IBOutlet weak var safeView: NormalCellView!
    
    @IBOutlet weak var feedbackView: NormalCellView!
    
    @IBOutlet weak var protocolView: NormalCellView!
    
    @IBOutlet weak var aboutView: NormalCellView!
    
    var coordinator: (UserInfoCoordinatorProtocol & UserInfoStateManagerProtocol)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupUI()
    }
    
    override func languageChanged() {
        super.languageChanged()
        reload()
    }
    
    func reload() {
        setupUI()
        customView.reload()
        safeView.reload()
        feedbackView.reload()
        protocolView.reload()
        aboutView.reload()
    }
    
    func setupUI() {
        self.title = R.string.localizable.mine_title.key.localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func commonObserveState() {
        coordinator?.subscribe(errorSubscriber) { sub in
            return sub.select { state in state.errorMessage }.skipRepeats({ (old, new) -> Bool in
                return false
            })
        }
        
        coordinator?.subscribe(loadingSubscriber) { sub in
            return sub.select { state in state.isLoading }.skipRepeats({ (old, new) -> Bool in
                return false
            })
        }
    }
    
    override func configureObserveState() {
        commonObserveState()
        
    }
}

extension UserInfoViewController {
    @objc func clickCellView(_ sender:[String:Any]) {
        switch sender["index"] as! Int {
        case 0:self.coordinator?.openNormalSetting()
        case 1:self.coordinator?.openSafeSetting()
        case 2:self.coordinator?.openHelpSetting(delegate: self)
        case 3:self.coordinator?.openServersSetting()
        case 4:self.coordinator?.openAboutSetting()
        default:
            break
        }
    }
}

extension UserInfoViewController:MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)

        switch result.rawValue{
        case MFMailComposeResult.sent.rawValue:
            print("邮件已发送")
        case MFMailComposeResult.cancelled.rawValue:
            print("邮件已取消")
        case MFMailComposeResult.saved.rawValue:
            print("邮件已保存")
        case MFMailComposeResult.failed.rawValue:
            print("邮件发送失败")
        default:
            print("邮件没有发送")
            break
        }
    }
}

