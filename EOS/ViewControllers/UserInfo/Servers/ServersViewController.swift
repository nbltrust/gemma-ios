//
//  ServersViewController.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class ServersViewController: BaseViewController {

	var coordinator: (ServersCoordinatorProtocol & ServersStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setupUI() {
        self.title = R.string.localizable.mine_server.key.localized()
    }

    
    override func configureObserveState() {
        
    }
}
