//
//  OverviewViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import SwiftyUserDefaults

class OverviewViewController: BaseViewController {

	var coordinator: (OverviewCoordinatorProtocol & OverviewStateManagerProtocol)?
    private(set) var context: OverviewContext?
    @IBOutlet weak var contentView: OverviewView!
    
    var currencyID: Int64?

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
        self.coordinator?.pushAccountList {

        }
    }
    
    func setupUI() {
        let view = AccountSwitchView()
        var model = AccountSwitchModel()
        model.name = CurrencyManager.shared.getCurrentAccountName()
        model.more = CurrencyManager.shared.getCurrentAccountNames().count > 1
        view.adapterModelToAccountSwitchView(model)
        configRightCustomView(view)
    }

    func setupData() {
        if let name = CurrencyManager.shared.getAccountNameWith(currencyID) {
            self.coordinator?.getTokensWith(name)
            coordinator?.getAccountInfo(name)
        }
    }
    
    func setupEvent() {
        
    }
    
    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }
            
            if let context = context as? OverviewContext {
                self.context = context
            }
            
        }).disposed(by: disposeBag)

        self.coordinator?.state.info.asObservable().subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            if let newModel = model as? NewHomeViewModel, newModel.id != 0 {
                self.contentView.adapterCardModelToOverviewView(newModel)
            }

            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        self.coordinator?.state.tokens.asObservable().subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            if let newModel = model as? [AssetViewModel] {
                self.contentView.adapterModelToOverviewView(newModel)
            }

            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
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
//            case .normal(_):
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
//            case .error(_, _):
////                self.showToastBox(false, message: error.localizedDescription)
//                
////                if reason == PageLoadReason.manualLoadMore {
////                    self.stopInfiniteScrolling(self.tableView, haveNoMore: false)
////                }
////                else if reason == PageLoadReason.manualRefresh {
////                    self.stopPullRefresh(self.tableView)
////                }
//                break
//            }
//        }).disposed(by: disposeBag)
    }
}

//MARK: - TableViewDelegate

//extension OverviewViewController: UITableViewDataSource, UITableViewDelegate {
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

extension OverviewViewController {
    @objc func assetsViewDidClicked(_ data:[String: Any]) {
        if let model = data["data"] as? AssetViewModel {
            self.coordinator?.pushToDetailVC(model)
        }
    }
    @objc func accountSwitchViewDidClicked(_ data:[String: Any]) {
        self.coordinator?.pushAccountList({
            
        })
    }

}

