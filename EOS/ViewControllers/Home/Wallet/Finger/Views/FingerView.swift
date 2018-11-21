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

    enum Event: String {
        case fingerViewDidClicked
        case changePwdDidClicked
        case addFingerDidClicked
        case changeFingerNameDidClicked
    }

    var dataArray: [String] = [] {
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
        let customNibName = R.nib.customCell.name
        tableView.register(UINib.init(nibName: customNibName, bundle: nil), forCellReuseIdentifier: customNibName)
        tableView.tableFooterView = UIView.init()
    }

    func setupSubViewEvent() {

    }

    @objc override func didClicked() {
        self.next?.sendEventWith(Event.fingerViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }

    func titleWithIndexPath(_ indexPath: IndexPath) -> String {
        if indexPath.section == 0 {
            if indexPath.row < dataArray.count {
                return dataArray[indexPath.row]
            } else {
                return R.string.localizable.add_finger.key.localized()
            }
        } else {
            return R.string.localizable.change_password.key.localized()
        }
    }
}

extension FingerView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let fingerTitle = R.string.localizable.finger.key.localized()
        let passwordTitle = R.string.localizable.wookong_password.key.localized()
        let headView = WalletListHeaderView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 52))
        headView.titleText = section == 0 ? fingerTitle : passwordTitle
        return headView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
        let customNibName = R.nib.customCell.name
        guard let cell = tableView.dequeueReusableCell(withIdentifier: customNibName, for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        cell.title = titleWithIndexPath(indexPath)
        cell.subTitle = ""
        if indexPath.section == 0 && indexPath.row == dataArray.count {
            cell.cellView.leftIconSpacing = 15
            cell.cellView.iconImage = R.image.ic_fingerprint()
        } else {
            cell.cellView.iconImage = nil
        }
        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == dataArray.count {
                self.next?.sendEventWith(Event.addFingerDidClicked.rawValue, userinfo: [:])
            } else {
                self.next?.sendEventWith(Event.changeFingerNameDidClicked.rawValue, userinfo: ["index": indexPath.row])
            }
        } else {
            self.next?.sendEventWith(Event.changePwdDidClicked.rawValue, userinfo: [:])
        }

    }
}
