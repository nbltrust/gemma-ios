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
    @IBOutlet weak var headView: OverHeadView!

    enum Event:String {
        case overviewViewDidClicked
        case cellDidClicked
    }

    var cardData: Any? {
        didSet {
            if let newdata = cardData as? NewHomeViewModel {
                tableView.reloadData()

                if newdata.tokenArray.count == 0 {
                    tableView.tableHeaderView?.height = 292 + 70
                } else {
                    tableView.tableHeaderView?.height = 326 + 70
                }
            }
        }
    }

    var assetData: [AssetViewModel] = [AssetViewModel()] {
        didSet {
            tableView.reloadData()
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
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = WalletListHeaderView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 36))

        if section == 0 {
            headView.titleText = R.string.localizable.asset.key.localized()
        }
        return headView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: AssetCell.self), for: indexPath) as? AssetCell else {
            return UITableViewCell()
        }

        cell.setup(assetData[indexPath.row], indexPath: indexPath)
        return cell
    }
}
