//
//  MnemonicContentViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/9/14.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import NBLCommonModule
//import seed39_ios_golang
import Seed39

class MnemonicContentViewController: BaseViewController {

	var coordinator: (MnemonicContentCoordinatorProtocol & MnemonicContentStateManagerProtocol)?

    @IBOutlet weak var contentView: MnemonicContentView!
    
    var seeds: [String] = []
    
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
        self.title = R.string.localizable.backup_mnemonic_title.key.localized()
    }

    func setupData() {
        Broadcaster.notify(EntryStateManagerProtocol.self) { (coor) in
            let model = coor.state.property.model
            if model?.type == .HD {
                let mnemonic = Seed39NewMnemonic()
                if let array = mnemonic?.components(separatedBy: " ") {
                    self.coordinator?.setSeeds((array, mnemonic ?? ""))
                    self.contentView.setMnemonicWordArray(array)
                }
            } else if model?.type == .bluetooth {
                self.coordinator?.getSeeds({ [weak self] (datas,checkStr) in
                    guard let `self` = self else { return }
                    if let tempDatas = datas as? [String],let check = checkStr {
                        DispatchQueue.main.sync {
                            self.seeds = tempDatas
                            self.coordinator?.setSeeds((tempDatas, check))
                            self.contentView.setMnemonicWordArray(self.seeds)
                        }
                    }
                    }, failed: { [weak self] (reason) in
                        guard let `self` = self else { return }
                        if let failedReason = reason {
                            self.showError(message: failedReason)
                        }
                })
            }
        }
    }
    
    func setupEvent() {
        
    }
    
    override func configureObserveState() {
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
    }
}

//MARK: - TableViewDelegate

//extension MnemonicContentViewController: UITableViewDataSource, UITableViewDelegate {
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

extension MnemonicContentViewController {
//    @objc func <#view#>DidClicked(_ data:[String: Any]) {
//        if let addressdata = data["data"] as? <#model#>, let view = data["self"] as? <#view#>  {
//
//        }
//    }
    @objc func copied(_ data:[String: Any]) {
        self.coordinator?.pushToVerifyMnemonicVC()
    }
}

