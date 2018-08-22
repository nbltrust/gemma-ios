//
//  NormalViewController.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class NormalViewController: BaseViewController {

	var coordinator: (NormalCoordinatorProtocol & NormalStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.title = R.string.localizable.mine_normal.key.localized()
    }
    
    override func configureObserveState() {
        
    }
}

extension NormalViewController {
    @objc func clickCellView(_ sender:[String:Any]) {
        let index = sender["index"] as! Int
        self.coordinator?.openContent(index)
    }
}

