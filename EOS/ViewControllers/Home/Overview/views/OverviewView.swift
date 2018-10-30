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
        
    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        let nib = R.nib.
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
        <#code#>
    }
}
