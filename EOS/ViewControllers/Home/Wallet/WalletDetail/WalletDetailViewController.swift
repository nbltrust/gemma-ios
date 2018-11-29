//
//  WalletDetailViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/10/12.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class WalletDetailViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    var coordinator: (WalletDetailCoordinatorProtocol & WalletDetailStateManagerProtocol)?
    private(set) var context: WalletDetailContext?
    var model: Wallet!

    var batteryInfo: BLTBatteryInfo?

	override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupEvent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadUI()
    }

    override func refreshViewController() {

    }

    func reloadUI() {
        self.title = self.model.name
    }

    func setupUI() {
        let customNibName = R.nib.customCell.name
        tableView.register(UINib.init(nibName: customNibName, bundle: nil), forCellReuseIdentifier: customNibName)

        let footView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 84))

        let formatTitle = R.string.localizable.format.key.localized()
        let btn = Button.init(frame: CGRect.init(x: 35, y: 40, width: footView.width - 70, height: 44))
        btn.btnBorderColor = UIColor.warningColor
        btn.title = formatTitle
        btn.style = ButtonStyle.border.rawValue
        btn.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.coordinator?.formmat()
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        footView.addSubview(btn)

        tableView.tableFooterView = footView
    }

    func setupData() {
        self.title = self.model.name
    }

    func setupEvent() {
        BLTWalletIO.shareInstance()?.batteryInfoUpdated = { [weak self] (info) in
            guard let `self` = self else { return }
            self.batteryInfo = info
            self.tableView.reloadData()
        }
    }

    func titleWithIndexPath(_ indexPath: IndexPath) -> String {
        if indexPath.row == 0 {
            return R.string.localizable.name.key.localized()
        } else {
            return R.string.localizable.battery.key.localized()
        }
    }

    func subtitleWithIndexPath(_ indexPath: IndexPath) -> String {
        if indexPath.row == 0 {
            return model.name
        } else {
            return batteryNumberInfo(batteryInfo)
        }
    }

    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }

            if let context = context as? WalletDetailContext {
                self.context = context
            }

        }).disposed(by: disposeBag)
    }
}

extension WalletDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nibString = R.nib.customCell.name
        let reuseCell = tableView.dequeueReusableCell(withIdentifier: nibString, for: indexPath)
        guard let cell = reuseCell as? CustomCell else {
            return UITableViewCell()
        }
        cell.title = titleWithIndexPath(indexPath)
        cell.subTitle = subtitleWithIndexPath(indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.coordinator?.pushToChangeWalletName(model: model)
        }
    }
}
