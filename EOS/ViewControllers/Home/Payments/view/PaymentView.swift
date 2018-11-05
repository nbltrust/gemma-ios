//
//  PaymentView.swift
//  EOS
//
//  Created zhusongyu on 2018/11/5.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class PaymentView: EOSBaseView {

    @IBOutlet weak var tableView: UITableView!

    enum Event:String {
        case paymentViewDidClicked

    }

    override var data: Any? {
        didSet {
            if let _ = data as? [PaymentsRecordsViewModel] {
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
    
    }
    
    @objc override func didClicked() {
        self.next?.sendEventWith(Event.paymentViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}

extension PaymentView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = data as? [PaymentsRecordsViewModel] {
            return data.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = String.init(describing: PaymentsRecordsCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: name, for: indexPath) as? PaymentsRecordsCell else {
            return UITableViewCell()
        }
        if let data = data as? [PaymentsRecordsViewModel] {
            cell.setup(data[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        self.coordinator?.pushPaymentsDetail(data: PaymentsRecordsViewModel())
        if let data = data as? [PaymentsRecordsViewModel] {
//            self.next?.sendEventWith(<#T##name: String##String#>, userinfo: <#T##[String : Any]#>)
        }
//        self.coordinator?.pushPaymentsDetail(data: data[indexPath.row])
    }

}
