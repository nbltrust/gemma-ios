//
//  HomeViewController.swift
//  EOS
//
//  Created koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import HandyJSON
import SwiftyJSON
import NotificationBannerSwift

class HomeViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeaderView: HomeHeaderView!
    var headImageView: UIImageView?
    
    var coordinator: (HomeCoordinatorProtocol & HomeStateManagerProtocol)?
    
    var data : Any?
	override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = true

        setupUI()
    }
    
    override func refreshViewController() {
        WalletManager.shared.FetchAccount { (account) in
            self.coordinator?.getAccountInfo(WalletManager.shared.getAccount())
        }
    }
    
    func setupBgImage() {
        if headImageView == nil {
            headImageView = UIImageView()
            headImageView!.image = navBgImage()
            self.view.insertSubview(headImageView!, at: 0)
            headImageView!.top(to: self.view)
            headImageView!.left(to: self.view)
            headImageView!.right(to: self.view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let nav = self.navigationController as? BaseNavigationController {
            nav.navStyle = .clear
        }
        setupBgImage()
        refreshViewController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let nav = self.navigationController as? BaseNavigationController {
            nav.navStyle = .common
        }

    }
    
    func setupUI(){
        if let nav = self.navigationController as? BaseNavigationController {
            nav.navStyle = .clear
        }
        
        self.configRightNavButton(R.image.walletAdd())
        let nibString = R.nib.homeTableCell.identifier
        tableView.register(UINib.init(nibName: nibString, bundle: nil), forCellReuseIdentifier: nibString)
        self.automaticallyAdjustsScrollViewInsets = true
    }
    
    func updateUI() {
        if WalletManager.shared.account_names.count <= 1 {
            tableHeaderView.nameAndImg.nameRightImgView.isHidden = true
        } else {
            tableHeaderView.nameAndImg.nameRightImgView.isHidden = false
        }
        
        if let wallket = WalletManager.shared.currentWallet() {
            if wallket.isBackUp {
                tableHeaderView.backupLabelViewIsHidden = true
            }
            else {
                tableHeaderView.backupLabelViewIsHidden = false
            }
            
            self.coordinator?.checkAccount({ (show) in
                if show {
                    showWarning(R.string.localizable.red_warning())
                }
                else {
                    
                }
            })
        }
        else {
            tableHeaderView.backupLabelViewIsHidden = true
        }
    }
    
    override func rightAction(_ sender: UIButton) {
        self.coordinator?.pushWallet()
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
            self.tableHeaderView.data = model
            self.updateUI()

            self.tableHeaderView.layoutIfNeeded()
            
            self.tableView.tableHeaderView?.height = self.tableHeaderView.height
            self.tableView.reloadData()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}
extension HomeViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.coordinator?.createDataInfo().count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nibString = String.init(describing:type(of: HomeTableCell()))
        let cell = tableView.dequeueReusableCell(withIdentifier: nibString, for: indexPath) as! HomeTableCell
        
        cell.setup(self.coordinator?.createDataInfo()[indexPath.row], indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:self.coordinator?.pushPayment()
        case 1:self.coordinator?.pushVoteVC()
        case 2:self.coordinator?.pushDealRAMVC()
        case 3:self.coordinator?.pushResourceMortgageVC()
        default:
            break
        }
    }
}

extension HomeViewController {
    @objc func accountlist(_ data: [String:Any]) {
        self.coordinator?.pushAccountList()
    }
    @objc func backupEvent(_ data: [String:Any]) {
        self.coordinator?.pushBackupVC()
    }
    
}
