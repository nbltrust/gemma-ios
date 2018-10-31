//
//  LeadInEntryViewController.swift
//  EOS
//
//  Created peng zhu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import XLPagerTabStrip

class LeadInEntryViewController: ButtonBarPagerTabStripViewController {

	var coordinator: (LeadInEntryCoordinatorProtocol & LeadInEntryStateManagerProtocol)?
    private(set) var context: LeadInEntryContext?
    
	override func viewDidLoad() {
        setupSetting()
        super.viewDidLoad()
        
        setupData()
        setupUI()
        setupEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func refreshViewController() {
        
    }

    func setupSetting() {
        self.settings.style.buttonBarBackgroundColor = UIColor.whiteColor
        self.settings.style.buttonBarItemBackgroundColor = UIColor.clear
        self.settings.style.buttonBarItemTitleColor = UIColor.baseColor
        self.settings.style.buttonBarMinimumLineSpacing = 0
        self.settings.style.selectedBarHeight = 1.0
        self.settings.style.buttonBarItemsShouldFillAvailableWidth = true
        self.settings.style.buttonBarItemFont = UIFont.pfScS16
        self.settings.style.buttonBarHeight = 56
        self.settings.style.buttonBarLeftContentInset = 20
        self.settings.style.buttonBarRightContentInset = 20

        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.subTitleColor
            newCell?.label.textColor = UIColor.baseColor
        }
    }

    func setupUI() {
        self.title = R.string.localizable.lead_in.key.localized()

        addGapView()

        configRightNavButton(R.image.ic_notify_scan())
    }

    override func rightAction(_ sender: UIButton) {
        
    }

    func setupData() {

    }

    func setupEvent() {
        
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let mnemonicVC = R.storyboard.leadIn.leadInMnemonicViewController()!
        let leadInKeyVC = R.storyboard.leadIn.leadInKeyViewController()!
        return [mnemonicVC, leadInKeyVC]
    }
}
