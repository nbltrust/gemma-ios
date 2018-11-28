//
//  CopyPriKeyViewController.swift
//  EOS
//
//  Created peng zhu on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import XLPagerTabStrip
import KRProgressHUD

class CopyPriKeyViewController: ButtonBarPagerTabStripViewController {

	var coordinator: (CopyPriKeyCoordinatorProtocol & CopyPriKeyStateManagerProtocol)?
    var prikey = ""
	override func viewDidLoad() {
        setupSetting()
        super.viewDidLoad()
        self.title = R.string.localizable.copy_priKey_title.key.localized()
        self.coordinator?.showAlertMessage()
    }

    func setupSetting() {
        self.settings.style.buttonBarBackgroundColor = UIColor.whiteColor
        self.settings.style.buttonBarItemBackgroundColor = UIColor.whiteColor
        self.settings.style.buttonBarItemTitleColor = UIColor.baseColor
        self.settings.style.buttonBarMinimumLineSpacing = 68
        self.settings.style.selectedBarHeight = 1.0
        self.settings.style.buttonBarItemsShouldFillAvailableWidth = true
        self.settings.style.buttonBarItemFont = UIFont.pfScS18
        self.settings.style.buttonBarHeight = 56
        self.settings.style.buttonBarLeftContentInset = 34
        self.settings.style.buttonBarRightContentInset = 34

        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.subTitleColor
            newCell?.label.textColor = UIColor.baseColor
        }
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let priKeyVC = R.storyboard.home.priKeyViewController()!
        let qrcodeVC = R.storyboard.home.qrCodeViewController()!
        return [priKeyVC, qrcodeVC]
    }
}

extension CopyPriKeyViewController {
    @objc func savedKeySafely(_ data: [String: Any]) {
        self.coordinator?.popVC()
    }
}
