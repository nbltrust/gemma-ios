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
    
	override func viewDidLoad() {
        setupSetting()
        super.viewDidLoad()
        self.title = R.string.localizable.copy_priKey_title()
    }
    
    func setupSetting() {
        self.settings.style.buttonBarBackgroundColor = UIColor.whiteTwo
        self.settings.style.buttonBarItemBackgroundColor = UIColor.whiteTwo
        self.settings.style.buttonBarItemTitleColor = UIColor.darkSlateBlue
        self.settings.style.buttonBarMinimumLineSpacing = 68
        self.settings.style.selectedBarHeight = 1.0
        self.settings.style.buttonBarItemsShouldFillAvailableWidth = true
        self.settings.style.buttonBarItemFont = UIFont.pfScS16
        self.settings.style.buttonBarHeight = 56
        self.settings.style.buttonBarLeftContentInset = 34
        self.settings.style.buttonBarRightContentInset = 34
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.blueyGrey
            newCell?.label.textColor = UIColor.darkSlateBlue
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let priKeyVC = R.storyboard.home.priKeyViewController()!
        let qrcodeVC = R.storyboard.home.qrCodeViewController()!
        return [priKeyVC, qrcodeVC]
    }
}
