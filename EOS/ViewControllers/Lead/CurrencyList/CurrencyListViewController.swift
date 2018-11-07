//
//  CurrencyListViewController.swift
//  EOS
//
//  Created peng zhu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class CurrencyListViewController: BaseViewController {

    @IBOutlet weak var currencyTableView: UITableView!

	var coordinator: (CurrencyListCoordinatorProtocol & CurrencyListStateManagerProtocol)?
    
    private(set) var context: CurrencyListContext?
    
	override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupUI()
        setupEvent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func refreshViewController() {

    }

    func setupUI() {
        self.title = R.string.localizable.currency_title.key.localized()

        currencyTableView.tableFooterView = UIView()
        currencyTableView.register(UINib.init(nibName: R.nib.currencyCheckCell.name, bundle: nil), forCellReuseIdentifier: R.nib.currencyCheckCell.name)
    }

    func setupData() {

    }

    func setupEvent() {

    }

    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }

            if let context = context as? CurrencyListContext {
                self.context = context
            }

        }).disposed(by: disposeBag)
    }

}

//MARK: - TableViewDelegate
extension CurrencyListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SupportCurrency.data.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellName = R.nib.currencyCheckCell.name
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? CurrencyCheckCell else {
            return UITableViewCell()
        }

        let type = SupportCurrency.data[indexPath.row]
        cell.title = type.des
        cell.isChoosed = self.context?.selectedCurrency == type

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let context = self.coordinator?.state.context.value as? CurrencyListContext else { return }
        context.currencySelectResult.value?(SupportCurrency.data[indexPath.row])
        currencyTableView.reloadData()
        self.coordinator?.popVC()
    }
}
