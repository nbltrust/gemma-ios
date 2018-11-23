//
//  AssetDetailViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class AssetDetailViewController: BaseViewController {

    @IBOutlet weak var contentView: AssetDetailView!
    var coordinator: (AssetDetailCoordinatorProtocol & AssetDetailStateManagerProtocol)?
    private(set) var context: AssetDetailContext?
    var data: [String: [PaymentsRecordsViewModel]] = [:]
    var isNoMoreData: Bool = false
    var symbol: String = ""
    var contract: String = ""

	override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    override func refreshViewController() {
    }
    func setupUI() {
        self.title = R.string.localizable.asset_detail.key.localized()
        popGesture = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        popGesture = true
    }
    
    override func leftAction(_ sender: UIButton) {
        self.coordinator?.popVC()
    }

    func setupData() {
        if let name = self.context?.model.name {
            symbol = name
        }
        if let con = self.context?.model.contract {
            contract = con
        }
        self.startLoading()

        self.addPullToRefresh(self.contentView.tableView) {[weak self] (completion) in
            guard let `self` = self else {return}
            self.coordinator?.getDataFromServer(CurrencyManager.shared.getCurrentAccountName(), symbol: self.symbol, contract: self.contract, completion: {[weak self] (success) in
                guard let `self` = self else {return}

                if success {
                    self.data.removeAll()

                    if (self.coordinator?.state.payments)!.count < 10 {
                        self.isNoMoreData = true
                    } else {
                        self.isNoMoreData = false
                    }
                    completion?()
                    self.data = (self.coordinator?.state.data)!
                    self.contentView.adapterModelToAssetDetailView(self.data)
                } else {
                }
                }, isRefresh: true)
            if let name = self.context?.model.name, name != "EOS" {
                self.coordinator?.getTokensWith(CurrencyManager.shared.getCurrentAccountName(), symbol: name)
            } else {
                self.coordinator?.getAccountInfo(CurrencyManager.shared.getCurrentAccountName())
            }
        }

        self.addInfiniteScrolling(self.contentView.tableView) {[weak self] (completion) in
            guard let `self` = self else {return}

            if self.isNoMoreData {
                completion?(true)
                return
            }
            self.coordinator?.getDataFromServer(CurrencyManager.shared.getCurrentAccountName(), symbol: self.symbol, contract: self.contract, completion: { [weak self](_) in
                guard let `self` = self else {return}
                if (self.coordinator?.state.payments.count)! < 10 {
                    self.isNoMoreData = true
                    completion?(true)
                } else {
                    completion?(false)
                }
                self.data = (self.coordinator?.state.data)!
                self.contentView.adapterModelToAssetDetailView(self.data)
                }, isRefresh: false)
        }
    }

    func refreshData() {
        self.coordinator?.getDataFromServer(CurrencyManager.shared.getCurrentAccountName(), symbol: symbol, contract: contract, completion: {[weak self] (success) in
            guard let `self` = self else { return }
            self.endLoading()
            if success {
                self.data.removeAll()
                if (self.coordinator?.state.payments.count)! < 10 {
                    self.isNoMoreData = true
                }
                if (self.coordinator?.state.payments)!.count == 0 {
                    self.contentView.isHidden = true
                } else {
                    self.contentView.isHidden = false
                }

                self.data = (self.coordinator?.state.data)!
                self.contentView.adapterModelToAssetDetailView(self.data)
            }
            }, isRefresh: true)

        if let name = self.context?.model.name, name != "EOS" {
            self.coordinator?.getTokensWith(CurrencyManager.shared.getCurrentAccountName(), symbol: name)
        } else {
            self.coordinator?.getAccountInfo(CurrencyManager.shared.getCurrentAccountName())
        }
    }
    
    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }
            
            if let context = context as? AssetDetailContext {
                self.context = context
                self.contentView.headView.adapterModelToAssetDetailHeadView(context.model)
                if context.model.name != "EOS" {
                    self.contentView.buttonView.isHidden = true
                    self.contentView.buttonViewHeight.constant = 0
                } else {
                    self.contentView.buttonView.isHidden = false
                    self.contentView.buttonViewHeight.constant = 49
                }
            }
        }).disposed(by: disposeBag)
        self.coordinator?.state.info.asObservable().subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            if model.name != "" {
                self.context?.model = model
            }
            self.contentView.headView.adapterModelToAssetDetailHeadView(model)
            if model.name != "EOS" {
                self.contentView.buttonView.isHidden = true
                self.contentView.buttonViewHeight.constant = 0
            } else {
                self.contentView.buttonView.isHidden = false
                self.contentView.buttonViewHeight.constant = 49
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

//extension AssetDetailViewController: UITableViewDataSource, UITableViewDelegate {
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

extension AssetDetailViewController {
    @objc func transferBtnDidClicked(_ data:[String: Any]) {
        if let model = self.context?.model {
            self.coordinator?.pushTransferVC(model)
        }
    }
    @objc func receiptBtnDidClicked(_ data:[String: Any]) {
        if let model = self.context?.model {
            self.coordinator?.pushReceiptVC(model)
        }
    }
    @objc func nodeVodeBtnDidClicked(_ data:[String: Any]) {
        self.coordinator?.pushVoteVC()
    }
    @objc func resourceManagerBtnDidClicked(_ data:[String: Any]) {
        self.coordinator?.pushResourceDetailVC()
    }
    @objc func cellViewDidClicked(_ data:[String: Any]) {
        if let model = data["data"] as? PaymentsRecordsViewModel {
            self.coordinator?.pushPaymentsDetail(data: model)
        }
    }
}

