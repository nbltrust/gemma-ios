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
import NotificationBanner
import Device
import SwiftyUserDefaults

class HomeViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeaderView: HomeHeaderView!
    var headImageView: UIImageView?

    var coordinator: (HomeCoordinatorProtocol & HomeStateManagerProtocol)?

    var data: Any?
    var currencyID: Int64?
    
	override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = true

        setupUI()
    }

    override func refreshViewController() {
        if let wallet = WalletManager.shared.currentWallet() {
            if wallet.creatStatus != WalletCreatStatus.creatSuccessed.rawValue {
                self.coordinator?.checkAccount()
            }
            WalletManager.shared.fetchAccount { (_) in
                self.coordinator?.getAccountInfo(WalletManager.shared.getAccount())
            }
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

//        self.coordinator?.getCurrentFromLocal()
        self.tableView.reloadData()
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
        self.navigationController?.navigationBar.alpha = 1
    }

    func setupUI() {
        self.navigationItem.title = "GEMMA"
        self.configRightNavButton(R.image.walletAdd())
        let nibString = R.nib.homeTableCell.identifier
        tableView.register(UINib.init(nibName: nibString, bundle: nil), forCellReuseIdentifier: nibString)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
//        self.automaticallyAdjustsScrollViewInsets = true 
    }

    func updateUI() {
        if WalletManager.shared.accountNames.count <= 1 {
            tableHeaderView.nameAndImg.nameRightImgView.isHidden = true
        } else {
            tableHeaderView.nameAndImg.nameRightImgView.isHidden = false
        }

        if let wallet = WalletManager.shared.currentWallet() {
            if let walletBackuped = wallet.isBackUp, walletBackuped {
                tableHeaderView.backupLabelViewIsHidden = true
            } else {
                tableHeaderView.backupLabelViewIsHidden = false
            }
        } else {
            tableHeaderView.backupLabelViewIsHidden = true
        }
    }

    override func rightAction(_ sender: UIButton) {
        self.coordinator?.pushWallet()
    }

    override func configureObserveState() {

        coordinator?.state.property.info.asObservable().subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            if model.account == WalletManager.shared.getAccount() {
                self.tableHeaderView.data = model
                self.updateUI()

                self.tableHeaderView.layoutIfNeeded()

                self.tableView.tableHeaderView?.height = self.tableHeaderView.height
                self.tableView.reloadData()
            }

        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        coordinator?.state.property.model.asObservable().subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            self.tableHeaderView.data = model
            self.updateUI()

            self.tableHeaderView.layoutIfNeeded()

            self.tableView.tableHeaderView?.height = self.tableHeaderView.height
            self.tableView.reloadData()
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = (self.coordinator?.createDataInfo().count)!
        if self.coordinator?.isBluetoothWallet() ?? false {
            count += 1
        }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nibString = String.init(describing: type(of: HomeTableCell()))
        guard let cell = tableView.dequeueReusableCell(withIdentifier: nibString, for: indexPath) as? HomeTableCell else {
            return UITableViewCell()
        }
        let isBluetooth = self.coordinator?.isBluetoothWallet() ?? false
        if indexPath.row == 0 && isBluetooth {
            cell.setup(self.coordinator?.bluetoothDataInfo(), indexPath: indexPath)
            cell.homeCellView.leftImg.isHidden = false
            cell.homeCellView.leftImg.image = R.image.ic_wookong()
        } else {
            cell.homeCellView.leftImg.isHidden = true
            cell.setup(self.coordinator?.createDataInfo()[indexPath.row - (isBluetooth ? 1: 0)], indexPath: indexPath)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let isBluetooth = self.coordinator?.isBluetoothWallet() ?? false
        if isBluetooth {
            self.coordinator?.handleBluetoothDevice()
            if indexPath.row == 0 {
                if !(BLTWalletIO.shareInstance()?.isConnection() ?? false) {
                    connectBLTCard { [weak self] in
                        guard let `self` = self else { return }
                        self.tableView.beginUpdates()
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                        self.tableView.endUpdates()
                    }
                }
            }
        }
        let actionIndex = indexPath.row - (isBluetooth ? 1: 0)
        switch (actionIndex) {
        case 0:self.coordinator?.pushPayment()
        case 1:self.coordinator?.pushVoteVC()
        case 2:self.coordinator?.pushBuyRamVC()
        case 3:self.coordinator?.pushResourceMortgageVC()
        default:
            break
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offsetY = 0

        if Device.version() == Version.iPhoneX {
            offsetY = -40
        } else {
            offsetY = -20
        }

        if scrollView.contentOffset.y > offsetY.cgFloat {
            if let nav = self.navigationController as? BaseNavigationController {
                nav.navStyle = .common
                let model = WalletManager.shared.getAccountModelsWithAccountName(name: WalletManager.shared.getAccount())
                self.navigationItem.title = model?.accountName
                self.navigationController?.navigationBar.alpha = (scrollView.contentOffset.y - offsetY.cgFloat) / 44
            }
        } else {
            if let nav = self.navigationController as? BaseNavigationController {
                nav.navStyle = .clear
            }
            self.navigationController?.navigationBar.alpha = 1
            self.navigationItem.title = "GEMMA"
        }
    }
}

extension HomeViewController {
    @objc func accountlist(_ data: [String: Any]) {
        self.coordinator?.pushAccountList {

        }
    }
    @objc func backupEvent(_ data: [String: Any]) {
        self.coordinator?.pushBackupVC()
    }

    @objc func cpuevent(_ data: [String: Any]) {
        self.coordinator?.pushResourceMortgageVC()
    }
    @objc func netevent(_ data: [String: Any]) {
        self.coordinator?.pushResourceMortgageVC()
    }
    @objc func ramevent(_ data: [String: Any]) {
        self.coordinator?.pushBuyRamVC()
    }
}
