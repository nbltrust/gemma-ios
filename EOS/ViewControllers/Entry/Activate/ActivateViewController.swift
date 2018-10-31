//
//  ActivateViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import XLPagerTabStrip
import SwiftyUserDefaults

class ActivateViewController: ButtonBarPagerTabStripViewController {

	var coordinator: (ActivateCoordinatorProtocol & ActivateStateManagerProtocol)?

    var currencyID: Int64?

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

    override func leftAction(_ sender: UIButton) {
        CurrencyManager.shared.saveAccountNameWith(currencyID, name: nil)
        self.navigationController?.popViewController()
    }

    func setupSetting() {
        self.settings.style.buttonBarBackgroundColor = UIColor.whiteColor
        self.settings.style.buttonBarItemBackgroundColor = UIColor.whiteColor
        self.settings.style.buttonBarItemTitleColor = UIColor.baseColor
        self.settings.style.buttonBarMinimumLineSpacing = 68
        self.settings.style.selectedBarHeight = 1.0
        self.settings.style.buttonBarItemsShouldFillAvailableWidth = true
        self.settings.style.buttonBarItemFont = UIFont.pfScS16
        self.settings.style.buttonBarHeight = 56
        self.settings.style.buttonBarLeftContentInset = 34
        self.settings.style.buttonBarRightContentInset = 34

        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.baseLightColor
            newCell?.label.textColor = UIColor.baseColor
        }
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return (self.coordinator?.pageVCs(currencyID))!
    }

    override func refreshViewController() {

    }

    func setupUI() {
        self.title = R.string.localizable.activate_title.key.localized()
    }

    func setupData() {

    }

    func setupEvent() {

    }

//    override func configureObserveState() {
//        self.coordinator?.state.pageState.asObservable().distinctUntilChanged().subscribe(onNext: {[weak self] (state) in
//            guard let `self` = self else { return }
//            
//            self.endLoading()
//            
//            switch state {
//            case .initial:
//                self.coordinator?.switchPageState(PageState.refresh(type: PageRefreshType.initial))
//                
//            case .loading(let reason):
//                if reason == .initialRefresh {
//                    self.startLoading()
//                }
//                
//            case .refresh(let type):
//                self.coordinator?.switchPageState(.loading(reason: type.mapReason()))
//                
//            case .loadMore(let page):
//                self.coordinator?.switchPageState(.loading(reason: PageLoadReason.manualLoadMore))
//                
//            case .noMore:
////                self.stopInfiniteScrolling(self.tableView, haveNoMore: true)
//                break
//                
//            case .noData:
////                self.view.showNoData(<#title#>, icon: <#imageName#>)
//                break
//                
//            case .normal(let reason):
////                self.view.hiddenNoData()
////
////                if reason == PageLoadReason.manualLoadMore {
////                    self.stopInfiniteScrolling(self.tableView, haveNoMore: false)
////                }
////                else if reason == PageLoadReason.manualRefresh {
////                    self.stopPullRefresh(self.tableView)
////                }
//                break
//                
//            case .error(let error, let reason):
//                self.showToastBox(false, message: error.localizedDescription)
//                
////                if reason == PageLoadReason.manualLoadMore {
////                    self.stopInfiniteScrolling(self.tableView, haveNoMore: false)
////                }
////                else if reason == PageLoadReason.manualRefresh {
////                    self.stopPullRefresh(self.tableView)
////                }
//            }
//        }).disposed(by: disposeBag)
//    }
}

// MARK: - TableViewDelegate

//extension ActivateViewController: UITableViewDataSource, UITableViewDelegate {
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

// MARK: - View Event

extension ActivateViewController {
//    @objc func <#view#>DidClicked(_ data:[String: Any]) {
//        if let addressdata = data["data"] as? <#model#>, let view = data["self"] as? <#view#>  {
//
//        }
//    }

}
