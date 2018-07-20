//
//  SafeViewController.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class SafeViewController: BaseViewController {

	var coordinator: (SafeCoordinatorProtocol & SafeStateManagerProtocol)?

    @IBOutlet weak var faceView: SafeLineView!
    @IBOutlet weak var fingerView: SafeLineView!
    @IBOutlet weak var gestureView: SafeLineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    func setupUI() {
        self.title = R.string.localizable.mine_safesetting()
    }
    
    func reloadSubViews(_ sender : Int) {
        let views = [self.faceView,self.fingerView,self.gestureView]
        
        for index in 0...views.count - 1 {
            if sender == index {
                views[sender]?.safeSwitch.isOn = true
            }else{
                views[sender]?.safeSwitch.isOn = false
            }
        }
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

extension SafeViewController {
    @objc func clickCellView(_ sender : [String:Any]) {
        if let index = sender["index"] as? Int {
            // 存储解锁方式

            let views = [self.faceView,self.fingerView,self.gestureView]
            if index <= views.count-1 {
                if views[index]?.safeSwitch.isOn == true {
                    return
                }
                reloadSubViews(index)
            }else {
                // open 手势解锁密码
            }
        }
    }
}
