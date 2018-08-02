//
//  WalletViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class WalletViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var coordinator: (WalletCoordinatorProtocol & WalletStateManagerProtocol)?
    var dataArray: [WalletManagerModel] = []

	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupData() {
        for wallet in WalletManager.shared.wallketList() {
            var model = WalletManagerModel()
            model.name = wallet.name
            model.address = wallet.publicKey
            dataArray.append(model)
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataArray.removeAll()
        setupData()
    }
    
    func setupUI(){
        self.title = R.string.localizable.tabbarWallet()
        
        let homeNibString = R.nib.homeTableCell.identifier
        tableView.register(UINib.init(nibName: homeNibString, bundle: nil), forCellReuseIdentifier: homeNibString)
        
        let walletNibString = R.nib.walletTableViewCell.name
        tableView.register(UINib.init(nibName: walletNibString, bundle: nil), forCellReuseIdentifier: walletNibString)
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

extension WalletViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = WalletListHeaderView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 52))

        if section == 0 {
            headView.titleText = R.string.localizable.have_wallet()
        } else {
            headView.titleText = R.string.localizable.wallet_manager()
        }
        return headView

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (self.coordinator?.createSectionOneDataInfo(data: dataArray).count)!
        } else {
            return (self.coordinator?.createSectionTwoDataInfo().count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let nibString = String.init(describing:type(of: WalletTableViewCell()))
            let cell = tableView.dequeueReusableCell(withIdentifier: nibString, for: indexPath) as! WalletTableViewCell
            
            cell.setup(self.coordinator?.createSectionOneDataInfo(data: dataArray)[indexPath.row], indexPath: indexPath)
            return cell

        } else {
            
            let nibString = String.init(describing:type(of: HomeTableCell()))
            let cell = tableView.dequeueReusableCell(withIdentifier: nibString, for: indexPath) as! HomeTableCell
            
            cell.setup(self.coordinator?.createSectionTwoDataInfo()[indexPath.row], indexPath: indexPath)
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if let wallet = WalletManager.shared.currentWallet(), wallet.publicKey != dataArray[indexPath.row].address {
                self.coordinator?.switchWallet(dataArray[indexPath.row].address)
                self.coordinator?.popToLastVC()
            }
          
        } else {
            switch indexPath.row {
            case 0:self.coordinator?.pushToLeadInWallet()
            case 1:self.coordinator?.pushToEntryVC()
            default:
                break
            }
        }

    }
}

extension WalletViewController {
    @objc func right_event(_ data : [String:Any]) {
        if let index = data["index"] as? String {
            self.coordinator?.pushToWalletManager(data: dataArray[index.int!])
        }
    }
}
