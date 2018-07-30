//
//  ResourceMortgageViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/7/24.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class ResourceMortgageViewController: BaseViewController {

	var coordinator: (ResourceMortgageCoordinatorProtocol & ResourceMortgageStateManagerProtocol)?

    @IBOutlet weak var contentView: ResourceMortgageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.title = R.string.localizable.resource_manager()

        let general = [GeneralCellView.GeneralViewModel(name: R.string.localizable.cpu(), eos: "0.100 EOS", leftSub: "已用0.100ms", rightSub: "总量10.29ms", lineHidden: false, progress: 0.5),GeneralCellView.GeneralViewModel(name: R.string.localizable.cpu(), eos: "0.100 EOS", leftSub: "已用0.100ms", rightSub: "总量10.29ms", lineHidden: false, progress: 0.8)]
        
        let page = PageViewModel(balance: "0.01 EOS", leftText: R.string.localizable.mortgage_resource(), rightText: R.string.localizable.cancel_mortgage(), operationLeft: [OperationViewModel(title: R.string.localizable.mortgage_cpu(), placeholder: R.string.localizable.mortgage_placeholder(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: true, isSecureTextEntry: false),OperationViewModel(title: R.string.localizable.mortgage_net(), placeholder: R.string.localizable.mortgage_placeholder(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: true, isSecureTextEntry: false)], operationRight: [OperationViewModel(title: R.string.localizable.cpu(), placeholder: R.string.localizable.mortgage_cancel_placeholder(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: true, isSecureTextEntry: false),OperationViewModel(title: R.string.localizable.net(), placeholder: R.string.localizable.mortgage_cancel_placeholder(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: true, isSecureTextEntry: false)])
        contentView.data = ResourceViewModel(general: general, page: page)
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

extension ResourceMortgageViewController {
    @objc func mortgage(_ data: [String:Any]) {
        let btnTitle: String = data["btntitle"] as! String
        if btnTitle == R.string.localizable.mortgage() {
            self.coordinator?.presentMortgageConfirmVC(toAccount: WallketManager.shared.getAccount(), money: "123", remark: "xsnixsnxisxnasxiaxanx")
        } else {
            
        }
    }
}


