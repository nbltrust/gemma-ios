//
//  UserInfoViewController.swift
//  EOS
//
//  Created koofrank on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class UserInfoViewController: BaseViewController {

	var coordinator: (UserInfoCoordinatorProtocol & UserInfoStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var content: UITextView!
    
    @IBAction func showCypher(_ sender: Any) {
        if let pass = password.text, pass.count > 0, let cypher = WallketManager.shared.getCachedPriKey(pass) {
            content.text = cypher
        }
        else {
            content.text = "获取失败"
        }
    }
    
    override func configureObserveState() {
        commonObserveState()
        
    }
}
