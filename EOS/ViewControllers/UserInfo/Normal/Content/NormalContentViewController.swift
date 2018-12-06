//
//  NormalContentViewController.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class NormalContentViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

	var coordinator: (NormalContentCoordinatorProtocol & NormalContentStateManagerProtocol)?

    var type: CustomSettingType = .language

    var selectedIndex: Int = 0

	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        self.title = self.coordinator?.titleWithIndex(type)
        if let coordinator = self.coordinator {
            self.selectedIndex = coordinator.selectedIndex(type)
        }
        configRightNavButton(R.string.localizable.normal_save.key.localized())

        let customNibName = R.nib.currencyCheckCell.name
        tableView.register(UINib.init(nibName: customNibName, bundle: nil), forCellReuseIdentifier: customNibName)
        tableView.tableFooterView = UIView()
    }

    func reloadTable() {
        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
    }

    override func rightAction(_ sender: UIButton) {
        self.coordinator?.setSelectIndex(type, index: selectedIndex)
        self.coordinator?.popVC()
    }

    func titleWithIndexPath(indexPath: IndexPath) -> String? {
        return self.coordinator?.settingDatas(type)[indexPath.row]
    }

    override func configureObserveState() {
    }
}

extension NormalContentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.coordinator?.settingDatas(type).count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellName = R.nib.currencyCheckCell.name
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? CurrencyCheckCell else {
            return UITableViewCell()
        }
        cell.title = titleWithIndexPath(indexPath: indexPath) ?? ""
        cell.isChoosed = indexPath.row == selectedIndex
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedIndex = indexPath.row
        reloadTable()
    }
}
