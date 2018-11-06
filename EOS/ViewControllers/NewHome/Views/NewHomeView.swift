//
//  NewHomeView.swift
//  EOS
//
//  Created zhusongyu on 2018/10/17.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class NewHomeView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBarView: NavBarView!
    

    enum Event: String {
        case newHomeViewDidClicked
        case cellDidClicked
    }
    
    var data: Any? {
        didSet {
            self.tableView.reloadData()
        }
    }
    func setup() {
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        let string = R.nib.newHomeTableCell.name
        tableView.register(UINib.init(nibName: string, bundle: nil), forCellReuseIdentifier: string)
    }
    
    func setupSubViewEvent() {
    
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIView.noIntrinsicMetric,height: dynamicHeight())
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
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setup()
    }
    
    fileprivate func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib.init(nibName: nibName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

extension NewHomeView: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = data as? [NewHomeViewModel] {
            return data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let data = data as? [NewHomeViewModel] {
            if data[indexPath.row].tokenArray.count == 0 {
                return 178 + 30
            }
            return 212 + 30
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nibString = R.nib.newHomeTableCell.name
        guard let cell = tableView.dequeueReusableCell(withIdentifier: nibString, for: indexPath) as? NewHomeTableCell else {
            return UITableViewCell()
        }
        cell.setup(self.data, indexPath: indexPath)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = data as? [NewHomeViewModel] {
            let model = data[indexPath.row]
            self.next?.sendEventWith(Event.cellDidClicked.rawValue, userinfo: ["data": model])
        }
    }
    
}
