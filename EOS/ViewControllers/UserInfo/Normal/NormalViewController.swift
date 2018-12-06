//
//  NormalViewController.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class NormalViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!

    var coordinator: (NormalCoordinatorProtocol & NormalStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.relload()
    }

    override func languageChanged() {
        self.relload()
    }

    func relload() {
        self.title = R.string.localizable.mine_normal.key.localized()
        tableView.reloadData()
    }

    func setupUI() {
        self.title = R.string.localizable.mine_normal.key.localized()
        let customNibName = R.nib.customCell.name
        tableView.register(UINib.init(nibName: customNibName, bundle: nil), forCellReuseIdentifier: customNibName)
        tableView.tableFooterView = UIView.init()
    }

    func titleWithIndexPath(indexPath: IndexPath) -> String? {
        switch indexPath.row {
        case 0:
            return R.string.localizable.normal_language.key.localized()
        case 1:
            return R.string.localizable.normal_asset.key.localized()
        case 2:
            return R.string.localizable.normal_node.key.localized()
        default:
            return nil
        }
    }

    func subTitleWithIndexPath(indexPath: IndexPath) -> String? {
        switch indexPath.row {
        case 0:
            return self.coordinator?.contentWithSender(CustomSettingType.language)
        case 1:
            return self.coordinator?.contentWithSender(CustomSettingType.asset)
        case 2:
            return ""
        default:
            return nil
        }
    }

    override func configureObserveState() {

    }
}

extension NormalViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customNibName = R.nib.customCell.name
        guard let cell = tableView.dequeueReusableCell(withIdentifier: customNibName, for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        cell.title = titleWithIndexPath(indexPath: indexPath) ?? ""
        cell.subTitle = subTitleWithIndexPath(indexPath: indexPath) ?? ""
        cell.cellView.lineViewAlignment = .toTitle
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.coordinator?.openContent(indexPath)
    }
}
