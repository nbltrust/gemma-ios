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

    enum vc_type : Int {
        case language = 0
        case asset
        case node
    }
    
    @IBOutlet weak var containerView: ContainerNormalCellView!
    
	var coordinator: (NormalContentCoordinatorProtocol & NormalContentStateManagerProtocol)?

    var type : vc_type = .language
    
    var selectedIndex : Int = 0 {
        didSet {

        }
    }
    
	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        if self.type == .language {
            self.title = R.string.localizable.normal_language()
        } else if (self.type == .asset) {
            self.title = R.string.localizable.normal_asset()
        } else if (self.type == .node) {
            self.title = R.string.localizable.normal_node()
        }
        self.coordinator?.setData(self.type.rawValue){ [weak self] (data) in
            self?.containerView.selectedIndex = 0
            self?.containerView.data = data
        }
        configRightNavButton(R.string.localizable.normal_save())
    }
    
    override func rightAction(_ sender: UIButton) {
        // 保存操作
    }
    
    func commonObserveState() {
        coordinator?.subscribe(errorSubscriber) { sub in
            return sub.select { state in state.errorMessage }.skipRepeats({ (old, new) -> Bool in
                return false
            })
        }
        
        coordinator?.subscribe(loadingSubscriber) { sub in
            return sub.select { state in state.isLoading }.skipRepeats({ (old, new) -> Bool in
                return false
            })
        }
    }
    
    override func configureObserveState() {
        commonObserveState()
    }
}

extension NormalContentViewController {
    
    @objc func selectedSetting(_ sender : [String:Any]) {
        if let index = sender["index"] as? Int {
            self.selectedIndex = index
        }
    }
}




