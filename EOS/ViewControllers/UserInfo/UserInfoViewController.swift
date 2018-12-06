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
import MessageUI

class UserInfoViewController: BaseViewController {

    @IBOutlet weak var settingTable: UITableView!

    lazy var tableHeadView: TableTitleHeadView = {
        let headView = TableTitleHeadView.init(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 54))
        headView.title = R.string.localizable.mine_title.key.localized()
        return headView
    }()

    lazy var navTitleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.mine_title.key.localized()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.baseColor
        return label
    }()

    var coordinator: (UserInfoCoordinatorProtocol & UserInfoStateManagerProtocol)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func languageChanged() {
        super.languageChanged()
        reloadUI()
    }

    func reloadUI() {
        let settingText = R.string.localizable.mine_title.key.localized()
        navTitleLabel.text = settingText
        tableHeadView.title = settingText
        settingTable.reloadData()
    }

    func setupUI() {
        self.navigationItem.titleView?.isHidden = true

        self.navigationItem.titleView = navTitleLabel

        configLeftNavButton(R.image.ic_mask_close())

        settingTable.tableHeaderView = tableHeadView

        let customNibName = R.nib.customCell.name
        settingTable.register(UINib.init(nibName: customNibName, bundle: nil), forCellReuseIdentifier: customNibName)
        settingTable.tableFooterView = UIView.init()
    }

    override func leftAction(_ sender: UIButton) {
        self.coordinator?.dismissVC()
    }

    override func configureObserveState() {

    }

    func titleWithIndexPath(_ indexPath: IndexPath) -> String {
        switch indexPath.row {
        case 0:
            return R.string.localizable.mine_normal.key.localized()
        case 1:
            return R.string.localizable.mine_safesetting.key.localized()
        case 2:
            return R.string.localizable.mine_help.key.localized()
        case 3:
            return R.string.localizable.mine_server.key.localized()
        case 4:
            return R.string.localizable.mine_about.key.localized()
        default:
            return ""
        }
    }

    func iconWithIndexPath(_ indexPath: IndexPath) -> UIImage? {
        switch indexPath.row {
        case 0:
            return R.image.ic_tab_currency()
        case 1:
            return R.image.ic_tab_safe()
        case 2:
            return R.image.ic_tab_help()
        case 3:
            return R.image.ic_tab_service()
        case 4:
            return R.image.ic_tab_about()
        default:
            return nil
        }
    }
}

extension UserInfoViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)

        switch result.rawValue {
        case MFMailComposeResult.sent.rawValue:
            print("邮件已发送")
        case MFMailComposeResult.cancelled.rawValue:
            print("邮件已取消")
        case MFMailComposeResult.saved.rawValue:
            print("邮件已保存")
        case MFMailComposeResult.failed.rawValue:
            print("邮件发送失败")
        default:
            print("邮件没有发送")
        }
    }
}

extension UserInfoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = 41
        if scrollView.contentOffset.y > offsetY.cgFloat {
            self.navigationItem.titleView?.isHidden = false
        } else {
            self.navigationItem.titleView?.isHidden = true
        }
    }
}

extension UserInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customNibName = R.nib.customCell.name
        guard let cell = tableView.dequeueReusableCell(withIdentifier: customNibName, for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        cell.title = titleWithIndexPath(indexPath)
        cell.subTitle = ""
        cell.cellView.leftIconSpacing = 19
        cell.icon = iconWithIndexPath(indexPath)
        cell.cellView.lineViewAlignment = .toTitle
        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            self.coordinator?.openNormalSetting()
        case 1:
            self.coordinator?.openSafeSetting()
        case 2:
            self.coordinator?.openHelpSetting()
        case 3:
            self.coordinator?.openServersSetting()
        case 4:
            self.coordinator?.openAboutSetting()
        default:
            break
        }

    }
}
