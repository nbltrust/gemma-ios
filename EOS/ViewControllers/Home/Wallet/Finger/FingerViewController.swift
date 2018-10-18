//
//  FingerViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/10/12.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class FingerViewController: BaseViewController {

	var coordinator: (FingerCoordinatorProtocol & FingerStateManagerProtocol)?
    private(set) var context: FingerContext?
    
    @IBOutlet weak var contentView: FingerView!
    var model = WalletManagerModel()
    
    var fpList: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFPList()
    }
    
    override func refreshViewController() {
        
    }
    
    func setupUI() {
        self.title = R.string.localizable.fingerprint_password.key.localized()
    }

    func setupData() {
        contentView.adapterModelToFingerView(self.model)
    }
    
    func setupEvent() {
    }
    
    func getFPList() {
        self.coordinator?.getFPList({ [weak self] (fpData) in
            guard let `self` = self else { return }
            if let list = fpData as? [String] {
                self.handleFPList(list)
            }
            }, failed: { [weak self] (reason) in
                guard let `self` = self else { return }
                if let failedReason = reason {
                    self.showError(message: failedReason)
                }
        })
    }
    
    func handleFPList(_ list: [String]) {
        fpList = list
        var tempList: [String] = []
        
        for index in fpList {
            tempList.append(WalletManager.shared.fingerName(model, index: Int(index) ?? 0))
        }
        self.contentView.dataArray = tempList
    }
    
    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }
            
            if let context = context as? FingerContext {
                self.context = context
            }
            
        }).disposed(by: disposeBag)
    }
}

//MARK: - TableViewDelegate

//extension FingerViewController: UITableViewDataSource, UITableViewDelegate {
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

extension FingerViewController {
    @objc func ChangePwdDidClicked(_ data:[String: Any]) {
        
    }
    @objc func ChangeFingerNameDidClicked(_ data:[String: Any]) {
        let index: Int = data["index"] as! Int
        self.coordinator?.pushToManagerFingerVC(model: model, index: Int(fpList[index]) ?? 0)
    }
    @objc func AddFingerDidClicked(_ data:[String: Any]) {
        self.coordinator?.pushToENtroFingerVC()
    }
}

