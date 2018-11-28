//
//  ResourceDetailViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/11/1.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class ResourceDetailViewController: BaseViewController {

	var coordinator: (ResourceDetailCoordinatorProtocol & ResourceDetailStateManagerProtocol)?
    private(set) var context: ResourceDetailContext?
    @IBOutlet weak var contentView: ResourceMortgageView!
    
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
        self.title = R.string.localizable.resource_detail.key.localized()
        if let wallet = WalletManager.shared.currentWallet() {
            if wallet.type == .bluetooth {
                self.contentView.tipsLabel.isHidden = false
            } else {
                self.contentView.tipsLabel.isHidden = true
            }
        }
    }

    func setupData() {
        if let id = CurrencyManager.shared.getCurrentCurrencyID(), let name = CurrencyManager.shared.getAccountNameWith(id) {
            coordinator?.getAccountInfo(name)
        }
    }
    
    func setupEvent() {
        
    }
    
    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }
            
            if let context = context as? ResourceDetailContext {
                self.context = context
            }
            
        }).disposed(by: disposeBag)
        self.coordinator?.state.info.asObservable().subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            if let newModel = model as? ResourceViewModel {
                self.contentView.data = newModel
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

//extension ResourceDetailViewController: UITableViewDataSource, UITableViewDelegate {
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

extension ResourceDetailViewController {
    @objc func delegateViewDidClicked(_ data:[String: Any]) {
        if let model = self.contentView.data as? ResourceViewModel {
            self.coordinator?.pushDelegateVC(model.balance, cpuBalance: model.general[0].delegatedBandwidth, netBalance: model.general[1].delegatedBandwidth)
        }
    }
    @objc func buyRamViewDidClicked(_ data:[String: Any]) {
        self.coordinator?.pushBuyRamVC()
    }
}

