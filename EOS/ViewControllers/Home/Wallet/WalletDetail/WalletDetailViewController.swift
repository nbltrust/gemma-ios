//
//  WalletDetailViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/10/12.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class WalletDetailViewController: BaseViewController {

    @IBOutlet weak var contentView: WalletDetailView!
    var coordinator: (WalletDetailCoordinatorProtocol & WalletDetailStateManagerProtocol)?
    private(set) var context: WalletDetailContext?
    var model = WalletManagerModel()

	override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupEvent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
    }

    override func refreshViewController() {

    }

    func setupUI() {

    }

    func setupData() {
        contentView.data = self.model
        contentView.adapterModelToWalletDetailView(self.model)
        self.title = self.model.name
    }

    func setupEvent() {

    }

    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }

            if let context = context as? WalletDetailContext {
                self.context = context
            }

        }).disposed(by: disposeBag)

        self.contentView.disConnectBtn.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.coordinator?.cancelPair()
        }).disposed(by: disposeBag)

        self.contentView.formatBtn.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.coordinator?.formmat()
        }).disposed(by: disposeBag)
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

// MARK: - TableViewDelegate

//extension WalletDetailViewController: UITableViewDataSource, UITableViewDelegate {
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

extension WalletDetailViewController {
    @objc func nameDidClicked(_ data: [String: Any]) {
        let model: WalletManagerModel = data["model"] as! WalletManagerModel
        self.coordinator?.pushToChangeWalletName(model: model)
    }
}
