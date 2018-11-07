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
import KRProgressHUD

class LeadInEntryViewController: ButtonBarPagerTabStripViewController {

	var coordinator: (LeadInEntryCoordinatorProtocol & LeadInEntryStateManagerProtocol)?
    private(set) var context: LeadInEntryContext?
    
	override func viewDidLoad() {
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
    
    func setupUI() {
        self.settings.style.buttonBarBackgroundColor = UIColor.whiteTwo
        self.settings.style.buttonBarItemBackgroundColor = UIColor.whiteTwo
        self.settings.style.buttonBarItemTitleColor = UIColor.darkSlateBlue
        self.settings.style.buttonBarMinimumLineSpacing = 68
        self.settings.style.selectedBarHeight = 1.0
        self.settings.style.buttonBarItemsShouldFillAvailableWidth = true
        self.settings.style.buttonBarItemFont = UIFont.pfScS16
        self.settings.style.buttonBarHeight = 56
        self.settings.style.buttonBarLeftContentInset = 20
        self.settings.style.buttonBarRightContentInset = 20

        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.blueyGrey
            newCell?.label.textColor = UIColor.darkSlateBlue
        }
    }

    func setupData() {
        
    }
    
    func setupEvent() {
        
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let priKeyVC = R.storyboard.home.priKeyViewController()!
        let qrcodeVC = R.storyboard.home.qrCodeViewController()!
        return [priKeyVC, qrcodeVC]
    }

}

//MARK: - TableViewDelegate

//extension LeadInEntryViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//          let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.<#cell#>.name, for: indexPath) as! <#cell#>
//
//        return cell
//    }
//}


//MARK: - View Event

//extension LeadInEntryViewController {
//    @objc func <#view#>DidClicked(_ data:[String: Any]) {
//        if let addressdata = data["data"] as? <#model#>, let view = data["self"] as? <#view#>  {
//
//        }
//    }
//}

