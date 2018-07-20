//
//  NormalContentViewController.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class NormalContentViewController: BaseViewController {

    enum vc_type : Int {
        case language = 0
        case asset
    }
    
    @IBOutlet weak var tableView: UITableView!
    
	var coordinator: (NormalContentCoordinatorProtocol & NormalContentStateManagerProtocol)?

    var type : vc_type = .language
    
    var selectedIndex : Int = 0 {
        didSet {
            self.tableView.reloadData()
        }
    }
    
	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.title = self.type == .language ? R.string.localizable.normal_language() : R.string.localizable.normal_asset()
        self.coordinator?.setData(self.type.rawValue)
        
        let nibString = String.init(describing:NormalContentCell.self)
        self.tableView.register(UINib.init(nibName: nibString, bundle: nil), forCellReuseIdentifier: nibString)
        configRightNavButton(R.string.localizable.normal_save())
    }
    
    override func rightAction(_ sender: UIButton) {
        // 保存操作
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

extension NormalContentViewController {
    @objc func clickCellView(_ sender : [String:Any]) {
        if let index = sender["index"] as? Int {
            self.selectedIndex = index
            // 在这里处理全局设置语言/币种
        }
    }
}

extension NormalContentViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.coordinator?.state.property.data.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let nibString = String.init(describing:NormalContentCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: nibString, for: indexPath) as! NormalContentCell
        cell.selectedIndex = self.selectedIndex
        if let data = self.coordinator?.state.property.data {
            cell.setup(data[indexPath.row], indexPath: indexPath)
            if indexPath.row == data.count - 1{
                cell.cellView.isShowLineView = false
            }
        }
        return cell
    }
}



