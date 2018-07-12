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

class EntryViewController: BaseViewController {
    
    @IBOutlet weak var registerView: RegisterContentView!
    
    @IBOutlet weak var agreeButton: UIButton!
    
    @IBOutlet weak var agreeView: AttributedLabelView!
    
    @IBOutlet weak var creatButton: Button!
    
	var coordinator: (EntryCoordinatorProtocol & EntryStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        //获取公私钥
        WallketManager.shared.createPairKey()
        setupUI()
        setupEvent()
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
        self.coordinator?.checkAgree(agreeButton.isSelected)
    }
    
    func setupUI() {
        let protocolStyle = AttributeStyle("protocol").underlineStyle(.styleSingle).foregroundColor(UIColor.darkSlateBlue)
        let allStyle = AttributeStyle.font(.systemFont(ofSize: 12)).foregroundColor(UIColor.blueyGrey)
        let agreeStr = String(format: "%@ %@", R.string.localizable.agree_title(),R.string.localizable.service_protocol())
        let protocolStr = R.string.localizable.service_protocol()
        let range = agreeStr.range(of: protocolStr)
        let detection = Detection.init(type: .range, style: protocolStyle, range: range!)
        agreeView.attributedText = AttributedText.init(string: agreeStr, detections: [detection], baseStyle: allStyle)
        agreeView.onClick = { attributedView, detection in
            switch detection.type {
            case .link(let url):
                UIApplication.shared.openURL(url)
            default:
                break
            }
        }
        
//        let agreeStyle: Style = Styles.styles[StyleNames.agree.rawValue] as! Style
//        let agreementStyle: Style = Styles.styles[StyleNames.agreement.rawValue] as! Style
//        let agreeGroup = StyleGroup(base: agreeStyle, [StyleNames.agreement.rawValue : agreementStyle])
//        let str = String(format: "%@  <%@>%@</%@>",R.string.localizable.agree_title(),StyleNames.agreement.rawValue, R.string.localizable.service_protocol(),StyleNames.agreement.rawValue)

//        let agreeStyle: Style = Styles.styles[StyleNames.agree.rawValue] as! Style
//        let agreementStyle: Style = Styles.styles[StyleNames.agreement.rawValue] as! Style
//        let agreeGroup = StyleGroup(base: agreeStyle, [StyleNames.agreement.rawValue : agreementStyle])
//        let str = String(format: "%@  <%@>%@</%@>",R.string.localizable.agree_title(),StyleNames.agreement.rawValue, R.string.localizable.service_protocol(),StyleNames.agreement.rawValue)
//        agreeLabel.attributedText = str.set(style: agreeGroup)
    }
    
    func setupEvent() {
        creatButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] tap in
            guard let `self` = self else { return }
            self.coordinator?.createWallet(self.registerView.nameView.textField.text!, password: self.registerView.passwordView.textField.text!, prompt: self.registerView.passwordPromptView.textField.text!, inviteCode: self.registerView.inviteCodeView.textField.text!, completion: {[weak self] (success) in
                
            })
        }).disposed(by: disposeBag)
    }
    
    override func configureObserveState() {
        commonObserveState()
        
        Observable.combineLatest(self.coordinator!.state.property.nameValid.asObservable(),
                                 self.coordinator!.state.property.passwordValid.asObservable(),
                                 self.coordinator!.state.property.comfirmPasswordValid.asObservable(),
                                 self.coordinator!.state.property.inviteCodeValid.asObservable(),
                                 self.coordinator!.state.property.isAgree.asObservable()).map { (arg0) -> Bool in
            return arg0.0 && arg0.1 && arg0.2 && arg0.3 && arg0.4
        }.bind(to: creatButton.isEnabel).disposed(by: disposeBag)
        
    }
}

extension EntryViewController {
    @objc func walletName(_ data: [String : Any]) {
        self.coordinator?.validWalletName(data["content"] as! String)
    }
    
    @objc func walletPassword(_ data: [String : Any]) {
        self.coordinator?.validPassword(data["content"] as! String)
    }
    
    @objc func walletComfirmPassword(_ data: [String : Any]) {
        self.coordinator?.validComfirmPassword(data["content"] as! String, comfirmPassword: self.registerView.passwordView.textField.text!)
    }
    
    @objc func walletInviteCode(_ data: [String : Any]) {
        self.coordinator?.validInviteCode(data["content"] as! String)
    }
    
    @objc func getInviteCode(_ data: [String : Any]) {
        self.coordinator?.getInviteCodeIntroduction()
    }
}
