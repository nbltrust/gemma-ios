//
//  EntryViewController.swift
//  EOS
//
//  Created koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import SwiftRichString

class EntryViewController: BaseViewController {
    
    @IBOutlet weak var registerView: RegisterContentView!
    
    @IBOutlet weak var agreeButton: UIButton!
    
    @IBOutlet weak var agreeLabel: UILabel!
    
    
	var coordinator: (EntryCoordinatorProtocol & EntryStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
    
    @IBAction func agreeAction(_ sender: Any) {
        agreeButton.isSelected = !agreeButton.isSelected
    }
    
    func setupUI() {
        let agreeStyle: Style = Styles.styles[StyleNames.agree.rawValue] as! Style
        let agreementStyle: Style = Styles.styles[StyleNames.agreement.rawValue] as! Style
        let agreeGroup = StyleGroup(base: agreeStyle, [StyleNames.agreement.rawValue : agreementStyle])
        let str = String(format: "%@  <%@>%@</%@>",R.string.localizable.agree_title(),StyleNames.agreement.rawValue, R.string.localizable.service_protocol(),StyleNames.agreement.rawValue)
        agreeLabel.attributedText = str.set(style: agreeGroup)
    }
    
    func validWalletName(name: String) -> Bool {
        let regex = "^[0-9a-z]{12}+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with:name)
    }
    
    func validPassword(password: String) -> Bool {
        let regex = "^[0-9a-zA-Z]{12}+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with:password)
    }
    
    func validComfirmPassword(password: String) -> Bool {
        return true
    }
    
    override func configureObserveState() {
        commonObserveState()
        
    }
}
