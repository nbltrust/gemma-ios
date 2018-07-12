//
//  EntryGuideViewController.swift
//  EOS
//
//  Created peng zhu on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class EntryGuideViewController: BaseViewController {

    @IBOutlet weak var createView: Button!
    
    @IBOutlet weak var recoverView: Button!
    
    var coordinator: (EntryGuideCoordinatorProtocol & EntryGuideStateManagerProtocol)?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavBar()
    }
    
	override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupEvent()
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
    
    func setupUI() {
        self.view.backgroundColor = UIColor.darkSlateBlue
    }
    
    func setupEvent() {
        createView.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] touch in
            guard let `self` = self else { return }
            self.coordinator?.pushToCreateWalletVC()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        recoverView.button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] touch in
            guard let `self` = self else { return }
            self.coordinator?.pushToRecoverFromCopyVC()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    override func configureObserveState() {
        commonObserveState()
        
    }
}
