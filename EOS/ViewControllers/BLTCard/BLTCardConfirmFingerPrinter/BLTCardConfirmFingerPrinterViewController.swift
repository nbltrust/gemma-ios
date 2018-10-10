//
//  BLTCardConfirmFingerPrinterViewController.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class BLTCardConfirmFingerPrinterViewController: BaseViewController {
    @IBOutlet weak var contentView: BLTCardIntroViewView!
    
	var coordinator: (BLTCardConfirmFingerPrinterCoordinatorProtocol & BLTCardConfirmFingerPrinterStateManagerProtocol)?

    private(set) var context:BLTCardConfirmFingerPrinterContext?
    
	override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupUI()
        setupEvent()
        
        
    }
    
    func test() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func refreshViewController() {
        
    }
    
    func setupUI() {
        var uiModel = BLTCardIntroModel()
        uiModel.title = R.string.localizable.wookong_fp_confirm_title.key.localized()
        uiModel.imageName = R.image.wookong_bio_fingerprint.name
        contentView.adapterModelToBLTCardIntroViewView(uiModel)
        
    }

    func setupData() {
        
    }
    
    func setupEvent() {
        self.startLoading(true)
        guard let context = context else { return }
        self.coordinator?.bltTransferAccounts(context.receiver, amount: context.amount, remark: context.remark, callback: { [weak self] (isSuccess, message) in
            guard let `self` = self else { return }
            if isSuccess {
                self.endLoading()
                self.coordinator?.finishTransfer()
            } else {
                self.showError(message: message)
            }
        })
    }
    
    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }
            
            if let context = context as? BLTCardConfirmFingerPrinterContext {
                self.context = context
                
                if context.iconType == leftIconType.dismiss.rawValue {
                    self.configLeftNavButton(R.image.icTransferClose())
                } else {
                    self.configLeftNavButton(R.image.icBack())
                }
            }
        }).disposed(by: disposeBag)
    }
}

//MARK: - TableViewDelegate

//extension BLTCardConfirmFingerPrinterViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//          let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.<#cell#>.name, for: indexPath) as! <#cell#>
//
//        return cell
//    }
//}


//MARK: - View Event

//extension BLTCardConfirmFingerPrinterViewController {
//    @objc func <#view#>DidClicked(_ data:[String: Any]) {
//        if let addressdata = data["data"] as? <#model#>, let view = data["self"] as? <#view#>  {
//
//        }
//    }
//}

