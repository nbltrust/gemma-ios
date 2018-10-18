//
//  FingerView.swift
//  EOS
//
//  Created zhusongyu on 2018/10/12.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class FingerView: EOSBaseView {
    
    @IBOutlet weak var tableView: UITableView!
    
    enum Event:String {
        case FingerViewDidClicked
        case ChangePwdDidClicked
        case AddFingerDidClicked
        case ChangeFingerNameDidClicked
    }
    
    var dataArray : [String] = [] {
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
        let walletNibString = R.nib.homeTableCell.name
        tableView.register(UINib.init(nibName: walletNibString, bundle: nil), forCellReuseIdentifier: walletNibString)
        tableView.tableFooterView = UIView.init()
    }
    
    func setupSubViewEvent() {
    
    }
    
    @objc override func didClicked() {
        self.next?.sendEventWith(Event.FingerViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
    
    func modelWithIndexPath(_ indexPath: IndexPath) -> LineView.LineViewModel {
        if indexPath.section == 0 {
            if indexPath.row < dataArray.count {
                return lineModelWithName(dataArray[indexPath.row])
            } else {
                return lineModelWithName(R.string.localizable.add_finger.key.localized())
            }
        } else {
            return lineModelWithName(R.string.localizable.change_password.key.localized())
        }
    }
    
    func lineModelWithName(_ name: String) -> LineView.LineViewModel {
        return LineView.LineViewModel.init(name: name,
                                           content: "",
                                           image_name: R.image.icArrow.name,
                                           name_style: LineViewStyleNames.normal_name,
                                           content_style: LineViewStyleNames.normal_content,
                                           isBadge: false,
                                           content_line_number: 1,
                                           isShowLineView: false)
    }
}

extension FingerView : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section == 0 {
            let headView = WalletListHeaderView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 52))
            headView.titleText = R.string.localizable.finger.key.localized()
            return headView
        }
        let headView = WalletListHeaderView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 24))
        return headView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 52
        }
        return 24
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return min(dataArray.count + 1, 3)
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nibString = String.init(describing:type(of: HomeTableCell()))
        let cell = tableView.dequeueReusableCell(withIdentifier: nibString, for: indexPath) as! HomeTableCell
        cell.setup(modelWithIndexPath(indexPath), indexPath: indexPath)
        if indexPath.section == 0 && indexPath.row == dataArray.count {
            cell.homeCellView.leftImg.image = R.image.if_ic_fingerprint_48_px_3669427()
        } else {
            cell.homeCellView.leftImg.image = nil
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == dataArray.count {
                self.next?.sendEventWith(Event.AddFingerDidClicked.rawValue, userinfo: [:])
            } else {
                self.next?.sendEventWith(Event.ChangeFingerNameDidClicked.rawValue, userinfo: ["index": indexPath.row])
            }
        } else {
            self.next?.sendEventWith(Event.ChangePwdDidClicked.rawValue, userinfo: [:])
        }
        
    }
}
