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
import SwiftyUserDefaults

class WalletViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    var coordinator: (WalletCoordinatorProtocol & WalletStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupData() {

    }

    func reloadData() {
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadData()
    }

    func setupUI() {
        self.title = R.string.localizable.tabbarWallet.key.localized()

        let walletNibString = R.nib.customCell.name
        tableView.register(UINib.init(nibName: walletNibString, bundle: nil), forCellReuseIdentifier: walletNibString)

        let wookongNibString = R.nib.wookongBioCell.name
        tableView.register(UINib.init(nibName: wookongNibString, bundle: nil), forCellReuseIdentifier: wookongNibString)

        configLeftNavButton(R.image.ic_mask_close())
    }

    override func leftAction(_ sender: UIButton) {
        self.coordinator?.dismissVC()
    }

    override func configureObserveState() {

    }

    func titleForIndexPath(_ indexPath: IndexPath) -> String {
        if indexPath.section == 0 {
            return R.string.localizable.current_wallet.key.localized()
        } else {
            if indexPath.row == 0 {
                return R.string.localizable.lead_in.key.localized()
            } else if indexPath.row == 1 {
                return R.string.localizable.create_wallet.key.localized()
            } else if indexPath.row == 2 {
                return R.string.localizable.pair_wookong.key.localized()
            }
        }
        return ""
    }

    func subTitleForIndexpath(_ indexPath: IndexPath) -> String {
        if indexPath.section == 0 {
            return WalletManager.shared.currentWallet()?.name ?? ""
        } else {
            if indexPath.row == 0 {
                return ""
            } else if indexPath.row == 1 {
                return ""
            } else if indexPath.row == 2 {
                return R.string.localizable.pair_wookong_introduce.key.localized()
            }
        }
        return ""
    }
}

extension WalletViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        } else {
            let headView = WalletListHeaderView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
            headView.titleText = R.string.localizable.wallet_manager.key.localized()
            return headView
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        }
        return 44
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return UITableView.automaticDimension
        }
        return 56
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 2 + (WalletManager.shared.existWookongWallet() ? 0 : 1)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            let nibString = R.nib.wookongBioCell.name
            guard let cell = tableView.dequeueReusableCell(withIdentifier: nibString, for: indexPath) as? WookongBioCell else {
                return UITableViewCell()
            }
            cell.title = titleForIndexPath(indexPath)
            cell.subTitle = subTitleForIndexpath(indexPath)
            return cell
        } else {
            let nibString = R.nib.customCell.name
            guard let cell = tableView.dequeueReusableCell(withIdentifier: nibString, for: indexPath) as? CustomCell else {
                return UITableViewCell()
            }
            cell.title = titleForIndexPath(indexPath)
            cell.subTitle = subTitleForIndexpath(indexPath)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.coordinator?.pushToWalletListVC()
        } else {
            switch indexPath.row {
            case 0:self.coordinator?.pushToLeadInWallet()
            case 1:self.coordinator?.pushToEntryVC()
            case 2:self.coordinator?.pushToBLTEntryVC()
            default:
                break
            }
        }

    }
}
