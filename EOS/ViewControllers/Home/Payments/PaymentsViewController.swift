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
    var lastPosition = 0
    
	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()


        
    }
    
    func setupUI(){
        
        let name = String.init(describing:PaymentsRecordsCell.self)
        
        tableView.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
        tableView.delegate = self
        tableView.dataSource = self
        self.coordinator?.getDataFromServer(WallketManager.shared.getAccount(), showNum: "10", lastPosition: lastPosition.string, completion: {[weak self] (success) in
            guard let `self` = self else { return }
            self.data = (self.coordinator?.state.property.data)!
            
            self.tableView.reloadData()

        })

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
        self.coordinator?.pushPaymentsDetail(data: data[indexPath.row])
    }
    
}


