//
//  NewHomeView.swift
//  EOS
//
//  Created zhusongyu on 2018/10/17.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class NewHomeView: EOSBaseView {
    
    @IBOutlet weak var tableView: UITableView!
    
    enum Event:String {
        case NewHomeViewDidClicked
    }
    
    override var data: Any? {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        let string = R.nib.newHomeTableCell.name
        tableView.register(UINib.init(nibName: string, bundle: nil), forCellReuseIdentifier: string)
    }
    
    func setupSubViewEvent() {
    
    }
    
    @objc override func didClicked() {
        self.next?.sendEventWith(Event.NewHomeViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}

extension NewHomeView: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = data as? [NewHomeViewModel] {
            return data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nibString = R.nib.newHomeTableCell.name
        let cell = tableView.dequeueReusableCell(withIdentifier: nibString, for: indexPath) as! NewHomeTableCell
        cell.setup(self.data, indexPath: indexPath)
        
        return cell
    }
    
    
}
