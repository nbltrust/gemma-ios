//
//  OverviewView.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class OverviewView: EOSBaseView {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cardView: CardView!
    
    enum Event:String {
        case overviewViewDidClicked
    }

    override var data: Any? {
        didSet {
            
        }
    }

    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        let nibString = R.nib.assetCell.name
        tableView.register(UINib.init(nibName: nibString, bundle: nil), forCellReuseIdentifier: nibString)

    }
    
    func setupSubViewEvent() {
    
    }
    
    @objc override func didClicked() {
        self.next?.sendEventWith(Event.overviewViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}

extension OverviewView: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: AssetCell.self), for: indexPath) as? AssetCell else {
            return UITableViewCell()
        }

        if let data = data as? [AccountListViewModel] {
            cell.setup(data[indexPath.row], indexPath: indexPath)
        }
        return cell
    }
}
