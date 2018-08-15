//
//  SelectedVoteViewController.swift
//  EOS
//
//  Created peng zhu on 2018/8/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class SelectedVoteViewController: BaseViewController {
    @IBOutlet weak var voteTable: UITableView!
    
	var coordinator: (SelectedVoteCoordinatorProtocol & SelectedVoteStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.coordinator?.loadDatas()
        voteTable.reloadData()
    }
    
    func setupUI() {
        updateTitle()
        
        let nibString = R.nib.nodeSelCell.identifier
        voteTable.register(UINib.init(nibName: nibString, bundle: nil), forCellReuseIdentifier: nibString)
        voteTable.separatorStyle = .none
        voteTable.allowsMultipleSelection = true
        
        let tableHeadView = UIView()
        tableHeadView.height = 23
        voteTable.tableHeaderView = tableHeadView
        
        let tableFootView = UIView()
        voteTable.tableFooterView = tableFootView
    }
    
    func updateTitle() {
        var count = 0
        if let dataCount = self.coordinator?.state.property.datas.count {
            count = dataCount
        }
        self.title = R.string.localizable.selected_node() + "(" + count.string + "/30)"
        
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

extension SelectedVoteViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.coordinator?.state.property.datas.count)!
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let count = tableView.indexPathsForSelectedRows?.count {
            return count < 30 ? indexPath : nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nibString = String.init(describing:type(of: NodeSelCell()))
        let cell = tableView.dequeueReusableCell(withIdentifier: nibString, for: indexPath) as! NodeSelCell
        cell.setupNode((self.coordinator?.state.property.datas[indexPath.row])!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

    }
}

