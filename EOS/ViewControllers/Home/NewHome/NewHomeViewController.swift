//
//  NewHomeViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/10/17.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class NewHomeViewController: BaseViewController {

	var coordinator: (NewHomeCoordinatorProtocol & NewHomeStateManagerProtocol)?
    private(set) var context: NewHomeContext?
    
    @IBOutlet weak var contentView: NewHomeView!
    
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
        //测试数据
        var array: [NewHomeViewModel] = []
        for _ in 0...3 {
            var model = NewHomeViewModel()
            model.currencyImg = R.image.eosBg()!
            model.account = "nbltrust"
            model.balance = "0.0000"
            model.currency = "EOS"
            model.currencyIcon = "http://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=tup&step_word=&hs=0&pn=2&spn=0&di=174209992220&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&istype=0&ie=utf-8&oe=utf-8&in=&cl=2&lm=-1&st=undefined&cs=266253535%2C2688670012&os=2527543112%2C2836803760&simid=3356443065%2C250398293&adpicid=0&lpn=0&ln=1788&fr=&fmq=1539836114404_R&fm=&ic=undefined&s=undefined&se=&sme=&tab=0&width=undefined&height=undefined&face=undefined&ist=&jit=&cg=&bdtype=0&oriquery=&objurl=http%3A%2F%2Ffa.topitme.com%2Fa%2Fa2%2F8a%2F1130147841d058aa2al.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bp5rtp_z%26e3B4jAzdH3Fk65w1%3Fpyrj%3Dwsk74%26t1%3D8baa89d&gsm=0&rpstart=0&rpnum=0&islist=&querylist="
            model.otherBalance = "≈ ¥ 4,000,000.000"
//            model.tokenArray = ["","","","",""]
            model.tokens = "+ 4 tokens"
            model.unit = "EOS"
            array.append(model)
        }
        self.contentView.data = array
        //
    }

    func setupData() {
        
    }
    
    func setupEvent() {
        
    }
    
    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }
            
            if let context = context as? NewHomeContext {
                self.context = context
            }
            
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

//MARK: - TableViewDelegate

//extension NewHomeViewController: UITableViewDataSource, UITableViewDelegate {
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

//extension NewHomeViewController {
//    @objc func <#view#>DidClicked(_ data:[String: Any]) {
//        if let addressdata = data["data"] as? <#model#>, let view = data["self"] as? <#view#>  {
//
//        }
//    }
//}

