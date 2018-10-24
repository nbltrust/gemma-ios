//
//  AboutViewController.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class AboutViewController: BaseViewController {

	var coordinator: (AboutCoordinatorProtocol & AboutStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setupUI() {
        self.title = R.string.localizable.mine_about.key.localized()
    }

    override func configureObserveState() {

    }
}

extension AboutViewController {
    @objc func clickCellView(_ sender: [String: Any]) {
        switch sender["index"] as! Int {
        case 0:self.coordinator?.openReleaseNotes()
//        case 1:
        default:
            break
        }
    }
}
