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
        coordinator?.getAccountInfo(WallketManager.shared.getAccount())
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
        
        coordinator?.state.property.info.asObservable().subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}

extension ResourceMortgageViewController {
    @objc func mortgage(_ data: [String:Any]) {
        let btnTitle: String = data["btntitle"] as! String
        
        var model = ConfirmViewModel()
        model.recever = WallketManager.shared.getAccount()
        model.amount = "123"
        model.remark = "sxsxsdw\nxsxsoxmo"
        
        if btnTitle == R.string.localizable.mortgage() {
            model.buttonTitle = R.string.localizable.confirm_mortgage()
        } else {
            model.buttonTitle = R.string.localizable.confirm_relieve_mortgage()
        }
        self.coordinator?.presentMortgageConfirmVC(data: model)

    }
}


