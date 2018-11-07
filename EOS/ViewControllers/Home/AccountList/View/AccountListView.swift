//
//  AccountListView.swift
//  EOS
//
//  Created by zhusongyu on 2018/7/23.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

class AccountListView: UIView {

    @IBOutlet weak var tableView: UITableView!

    var didSelect: ObjectCallback?

    var data: [AccountListViewModel]? {
        didSet {
            tableView.reloadData()
        }
    }

    func setUp() {
        let nibString = R.nib.accountTableViewCell.name
        tableView.register(UINib.init(nibName: nibString, bundle: nil), forCellReuseIdentifier: nibString)
        tableView.tableFooterView = UIView()
        updateHeight()
    }

    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIView.noIntrinsicMetric, height: dynamicHeight())
    }

    fileprivate func updateHeight() {
        layoutIfNeeded()
        self.height = dynamicHeight()
        invalidateIntrinsicContentSize()
    }

    fileprivate func dynamicHeight() -> CGFloat {
        let lastView = self.subviews.last?.subviews.last
        return lastView?.bottom ?? 0

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setUp()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setUp()
    }

    fileprivate func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib.init(nibName: nibName, bundle: bundle)
        guard let  view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }

        self.insertSubview(view, at: 0)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

extension AccountListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = data {
            return data.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nibString = R.nib.accountTableViewCell.name
        guard let cell = tableView.dequeueReusableCell(withIdentifier: nibString) as? AccountTableViewCell else {
            return UITableViewCell()
        }

        if let data = data {
            cell.setup(data[indexPath.row], indexPath: indexPath)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.didSelect != nil {
            self.didSelect!(indexPath.row)
        }
    }
}
