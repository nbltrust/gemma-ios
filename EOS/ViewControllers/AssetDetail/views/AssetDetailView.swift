//
//  AssetDetailView.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class AssetDetailView: EOSBaseView {

    @IBOutlet weak var nodeVodeButton: UIButton!
    @IBOutlet weak var resourceManagerButton: UIButton!
    @IBOutlet weak var headView: AssetDetailHeadView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var buttonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!

    enum Event:String {
        case assetDetailViewDidClicked
        case nodeVodeBtnDidClicked
        case resourceManagerBtnDidClicked
        case cellViewDidClicked
    }

    override var data: Any? {
        didSet {
            if let _ = data as? [String: [PaymentsRecordsViewModel]] {
                self.tableView.reloadData()
            }
        }
    }

    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        let name = String.init(describing: PaymentsRecordsCell.self)
        tableView.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
    
    func setupSubViewEvent() {
        nodeVodeButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.sendEventWith(Event.nodeVodeBtnDidClicked.rawValue, userinfo: [:])
        }).disposed(by: disposeBag)
        resourceManagerButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.sendEventWith(Event.resourceManagerBtnDidClicked.rawValue, userinfo: [:])
        }).disposed(by: disposeBag)
    }
    
    @objc override func didClicked() {
        self.next?.sendEventWith(Event.assetDetailViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}

extension AssetDetailView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = data as? [String: [PaymentsRecordsViewModel]] {
            let keys = Array(data.keys)
            let key = keys[section]
            return data[key]!.count
        }
        return 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if let data = data as? [String: [PaymentsRecordsViewModel]] {
            return data.keys.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = WalletListHeaderView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 36))

        if section == 0 {
            headView.titleText = R.string.localizable.asset.key.localized()
        }
        if let data = data as? [String: [PaymentsRecordsViewModel]] {
            let keys = Array(data.keys)
            let key = keys[section]
            headView.titleText = key

        }
        return headView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = String.init(describing: PaymentsRecordsCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: name, for: indexPath) as? PaymentsRecordsCell else {
            return UITableViewCell()
        }
        if let data = data as? [String: [PaymentsRecordsViewModel]] {
            let keys = Array(data.keys)
            let key = keys[indexPath.section]
            cell.setup(data[key]![indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = data as? [String: [PaymentsRecordsViewModel]] {
            let keys = Array(data.keys)
            let key = keys[indexPath.section]
            self.sendEventWith(Event.cellViewDidClicked.rawValue, userinfo: ["data": data[key]![indexPath.row]])
        }
    }
}
