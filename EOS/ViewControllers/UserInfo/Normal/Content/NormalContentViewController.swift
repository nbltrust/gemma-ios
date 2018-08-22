//
//  NormalContentViewController.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class NormalContentViewController: BaseViewController {
    
    @IBOutlet weak var containerView: ContainerNormalCellView!
    
	var coordinator: (NormalContentCoordinatorProtocol & NormalContentStateManagerProtocol)?

    var type : CustomSettingType = .language
    
    var selectedIndex : Int = 0
    
	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.title = self.coordinator?.titleWithIndex(type)
        self.containerView.data = self.coordinator?.settingDatas(type)
        if let coordinator = self.coordinator {
            self.selectedIndex = coordinator.selectedIndex(type)
        }
        self.containerView.selectedIndex = selectedIndex
        configRightNavButton(R.string.localizable.normal_save.key.localized())
    }
    
    override func rightAction(_ sender: UIButton) {
        self.coordinator?.setSelectIndex(type, index: selectedIndex)
        self.coordinator?.popVC()
    }

    override func configureObserveState() {
    }
}

extension NormalContentViewController {
    
    @objc func selectedSetting(_ sender : [String:Any]) {
        log.debug(sender)
        if let index = sender["index"] as? Int {
            self.selectedIndex = index
        }
    }
}




