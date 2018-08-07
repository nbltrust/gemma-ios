//
//  PaymentsViewController.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/10.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import ESPullToRefresh


class PaymentsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var coordinator: (PaymentsCoordinatorProtocol & PaymentsStateManagerProtocol)?
    var data = [PaymentsRecordsViewModel]()
    var isNoMoreData : Bool = false
    
	override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupEvent()
    }
    
    func setupUI(){
        self.title = R.string.localizable.payments_history()
        let name = String.init(describing:PaymentsRecordsCell.self)
        tableView.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }

    
    func setupEvent() {
        self.startLoading()

        self.coordinator?.getDataFromServer(WalletManager.shared.getAccount(),completion: {[weak self] (success) in
            guard let `self` = self else { return }
            
            if success {
                self.endLoading()
                self.data.removeAll()
                if (self.coordinator?.state.property.data)!.count < 10 {
                    self.isNoMoreData = true
                }
                self.data += (self.coordinator?.state.property.data)!
                self.tableView.reloadData()
            }
            else {
                self.showError(message: R.string.localizable.request_failed())
            }
            
            }, isRefresh:true)
        
        self.addPullToRefresh(self.tableView) {[weak self] (completion) in
            guard let `self` = self else {return}

            self.coordinator?.getDataFromServer(WalletManager.shared.getAccount(),completion: {[weak self] (success) in
                guard let `self` = self else {return}
                
                if success {
                    self.data.removeAll()
                    if (self.coordinator?.state.property.data)!.count < 10 {
                        self.isNoMoreData = true
                    }else{
                        self.isNoMoreData = false
                    }
                    completion?()
                    self.data += (self.coordinator?.state.property.data)!
                    self.tableView.reloadData()
                }
                else {
                    self.showError(message: R.string.localizable.request_failed())
                }
            },isRefresh: true)
        }
        
        self.addInfiniteScrolling(self.tableView) {[weak self] (completion) in
            guard let `self` = self else {return}

            if self.isNoMoreData {
                completion?(true)
                return
            }
            self.coordinator?.getDataFromServer(WalletManager.shared.getAccount(), completion: { [weak self](success) in
                guard let `self` = self else {return}
                if (self.coordinator?.state.property.data.count)! < 10 {
                    self.isNoMoreData = true
                    completion?(true)
                }else{
                    completion?(false)
                }
                self.data += (self.coordinator?.state.property.data)!
                self.tableView.reloadData()
            },isRefresh: false)
        }
    }
    
    func commonObserveState() {
        coordinator?.subscribe(errorSubscriber) { sub in
            return sub.select { state in state.errorMessage }.skipRepeats({ (old, new) -> Bool in
                return false
            })
        }
        
        coordinator?.subscribe(loadingSubscriber) { sub in
            return sub.select { state in state.isLoading }.skipRepeats({ (old, new) -> Bool in
                return false
            })
        }
        
        
    }
    
    override func configureObserveState() {
        commonObserveState()
        
        
    }
    
    
}

extension PaymentsViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = String.init(describing:PaymentsRecordsCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: name, for: indexPath) as! PaymentsRecordsCell
        cell.setup(data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.coordinator?.pushPaymentsDetail(data: PaymentsRecordsViewModel())
      
        self.coordinator?.pushPaymentsDetail(data: data[indexPath.row])
    }
    
}


