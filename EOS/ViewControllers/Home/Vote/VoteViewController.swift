//
//  VoteViewController.swift
//  EOS
//
//  Created peng zhu on 2018/8/8.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class VoteViewController: BaseViewController {
    @IBOutlet weak var voteTable: UITableView!
    
    @IBOutlet weak var footView: VoteFootView!
    
    var coordinator: (VoteCoordinatorProtocol & VoteStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
        loadVoteNodeList()
        self.coordinator?.getAccountInfo()
    }
    
    func setupUI() {
        self.title = R.string.localizable.vote_title()
        
        let nibString = R.nib.nodeCell.identifier
        voteTable.register(UINib.init(nibName: nibString, bundle: nil), forCellReuseIdentifier: nibString)
        voteTable.separatorStyle = .none
        voteTable.allowsMultipleSelection = true
        
        let tableHeadView = UIView()
        tableHeadView.height = 23
        voteTable.tableHeaderView = tableHeadView
        
        let tableFootView = UIView()
        tableFootView.height = 60
        voteTable.tableFooterView = tableFootView
    }
    
    func setupEvent() {
        self.addPullToRefresh(self.voteTable) {[weak self] (completion) in
            guard let `self` = self else {return}
            self.coordinator?.loadVoteList({[weak self] (success) in
                if success {
                    guard let `self` = self else { return }
                    self.voteTable.reloadData()
                    self.updateCount()
                    completion?()
                }
            })
        }
        
        footView.statusView.leftLabel.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] tap in
            guard let `self` = self else { return }
            if let count = self.voteTable.indexPathsForSelectedRows?.count {
                if count > 0 {
                    self.coordinator?.pushSelectedVote()
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func loadVoteNodeList() {
        self.startLoading()
        self.coordinator?.loadVoteList({[weak self] (success) in
            guard let `self` = self else { return }
            if success {
                self.voteTable.reloadData()
            }
            self.endLoading()
        })
    }
    
    func updateCount() {
        if let count = voteTable.indexPathsForSelectedRows?.count {
            footView.statusView.selCount = count
        } else {
            footView.statusView.selCount = 0
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
        
        coordinator?.state.property.delagatedInfo.asObservable().subscribe(onNext: {[weak self] (info) in
            guard let `self` = self else { return }
            if let info = info {
                self.footView.subTitleLabel.text = info.delagetedAmount.string + " " + R.string.localizable.eos()
                self.footView.statusView.highlighted = info.delagetedAmount > 0
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    override func configureObserveState() {
        commonObserveState()
        
    }
}

extension VoteViewController: UITableViewDelegate,UITableViewDataSource {
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
        let nibString = String.init(describing:type(of: NodeCell()))
        let cell = tableView.dequeueReusableCell(withIdentifier: nibString, for: indexPath) as! NodeCell
        cell.setupNode((self.coordinator?.state.property.datas[indexPath.row])!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateCount()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        updateCount()
    }
}
