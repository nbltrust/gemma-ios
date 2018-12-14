//
//  NormalCurrencyListViewController.swift
//  EOS
//
//  Created peng zhu on 2018/12/6.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import SwiftyUserDefaults

class NormalCurrencyListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    var coordinator: (NormalCurrencyListCoordinatorProtocol & NormalCurrencyListStateManagerProtocol)?
    private(set) var context: NormalCurrencyListContext?

    var currencyData: [CurrencyType] = []

	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTable()
    }

    func setupUI() {
        self.title = R.string.localizable.normal_node.key.localized()
        let customNibName = R.nib.customCell.name
        tableView.register(UINib.init(nibName: customNibName, bundle: nil), forCellReuseIdentifier: customNibName)
        tableView.tableFooterView = UIView.init()
    }

    func setupData() {
        currencyData = SupportCurrency.data
        reloadTable()
    }

    func reloadTable() {
        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
    }

    func titleWithIndexPath(_ indexPath: IndexPath) -> String {
        let type = currencyData[indexPath.row]
        switch type {
        case .EOS:
            return R.string.localizable.node_eos.key.localized()
        default:
            return ""
        }
    }

    func subTitleWithIndexPath(_ indexPath: IndexPath) -> String {
        let type = currencyData[indexPath.row]
        switch type {
        case .EOS:
            return EOSBaseURLNodesConfiguration.values[Defaults[.currentEOSURLNode]]
        default:
            return ""
        }
    }

    func iconWithIndexPath(_ indexPath: IndexPath) -> UIImage? {
        let type = currencyData[indexPath.row]
        switch type {
        case .EOS:
            return R.image.eos24()
        default:
            return nil
        }
    }

    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }
            if let context = context as? NormalCurrencyListContext {
                self.context = context
            }
        }).disposed(by: disposeBag)
    }
}

extension NormalCurrencyListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SupportCurrency.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customNibName = R.nib.customCell.name
        guard let cell = tableView.dequeueReusableCell(withIdentifier: customNibName, for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        cell.title = titleWithIndexPath(indexPath)
        cell.subTitle = subTitleWithIndexPath(indexPath)
        cell.icon = iconWithIndexPath(indexPath)
        cell.cellView.leftIconSpacing = 19
        cell.cellView.lineViewAlignment = .toTitle
        cell.cellView.titleGapWithSubTitle = 40
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.coordinator?.pushToContenVC(currencyData[indexPath.row])
    }
}
