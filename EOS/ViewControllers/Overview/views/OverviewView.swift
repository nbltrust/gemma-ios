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

    var assetDataArray: [AssetViewModel]? {
        didSet {
//            if assetDataArray != nil {
//
//                if let data = firstAssetData {
//                    let isContain = assetDataArray?.contains(where: { (value) -> Bool in
//                        value.name == data.name
//                    })
//                    if isContain == false {
//                        assetDataArray?.insert(data, at: 0)
//                    } else {
//                        assetDataArray?.remove(at: 0)
//                        assetDataArray?.insert(data, at: 0)
//                    }
//                }
                tableView.reloadData()
//            }
        }
    }

    var firstAssetData: AssetViewModel? {
        didSet {
//            if assetDataArray != nil {
//                if let data = firstAssetData {
//                    let isContain = assetDataArray?.contains(where: { (value) -> Bool in
//                        value.name == data.name
//                    })
//                    if isContain == false {
//                        assetDataArray?.insert(data, at: 0)
//                    } else {
//                        assetDataArray?.remove(at: 0)
//                        assetDataArray?.insert(data, at: 0)
//                    }
//                }
                tableView.reloadData()
//            }
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
        var count = 0
        if let _ = firstAssetData {
            count += 1
        }
        if let data = assetDataArray {
            count += data.count
        }
        return count
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
        if indexPath.row == 0 {
            cell.setup(firstAssetData, indexPath: indexPath)
        } else {
            if let data = assetDataArray {
                cell.setup(data[indexPath.row-1], indexPath: indexPath)
            }
        }

        return cell
    }
}
