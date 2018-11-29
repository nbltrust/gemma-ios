//
//  BLTCardSearchViewController.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class BLTCardSearchViewController: BaseViewController {

	var coordinator: (BLTCardSearchCoordinatorProtocol & BLTCardSearchStateManagerProtocol)?

    @IBOutlet weak var deviceTable: UITableView!

    var indicatorView: UIActivityIndicatorView?

    private(set) var context: BLTCardSearchContext?

	override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupData()
        setupEvent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func refreshViewController() {

    }

    func setupUI() {
        configLeftNavButton(R.image.ic_mask_close())

        let nibString = R.nib.bltDeviceCell.identifier
        deviceTable.register(UINib.init(nibName: nibString, bundle: nil), forCellReuseIdentifier: nibString)
    }

    override func leftAction(_ sender: UIButton) {
        self.coordinator?.dismissSearchVC()
    }

    override func rightAction(_ sender: UIButton) {
        clearDevice()
        self.searchDevice()
    }

    func clearDevice() {
        self.coordinator?.clearDevice()
        deviceTable.reloadData()
    }

    func setupData() {
        BLTWalletIO.shareInstance()?.didSearchDevice = {[weak self] device in
            guard let `self` = self else { return }
            self.coordinator?.searchedADevice(device!)
            self.deviceTable.reloadData()
        }
        searchDevice()
    }

    func reloadRightItem(_ isStoped: Bool) {
        if isStoped {
            configRightNavButton(R.string.localizable.wookong_retry.key)
            indicatorView?.stopAnimating()
        } else {
            if indicatorView == nil {
                indicatorView = UIActivityIndicatorView(style: .gray)
                indicatorView?.hidesWhenStopped = true
            }
            configRightCustomView(indicatorView!)
            indicatorView?.startAnimating()
        }
    }

    func searchDevice() {
        reloadRightItem(false)
        BLTWalletIO.shareInstance().searchBLTCard({ [weak self] in
            guard let `self` = self else { return }
            self.reloadRightItem(true)
        })
    }

    func setupEvent() {

    }

    func modelWithDevice(device: BLTDevice) -> LineView.LineViewModel {
        return LineView.LineViewModel.init(name: device.name,
                                           content: "",
                                           imageName: R.image.icTabArrow.name,
                                           nameStyle: LineViewStyleNames.normalName,
                                           contentStyle: LineViewStyleNames.normalContent,
                                           isBadge: false,
                                           contentLineNumber: 0,
                                           isShowLineView: false)
    }

    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }

            if let context = context as? BLTCardSearchContext {
                self.context = context
            }

        }).disposed(by: disposeBag)
    }
}

// MARK: - TableViewDelegate

extension BLTCardSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let devices = self.coordinator?.state.devices {
            return devices.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nibString = String.init(describing: type(of: BLTDeviceCell()))
        let reuseCell = tableView.dequeueReusableCell(withIdentifier: nibString, for: indexPath)
        guard let cell = reuseCell  as? BLTDeviceCell else {
            return UITableViewCell()
        }
        if let devices = self.coordinator?.state.devices {
            let device = devices[indexPath.row]
            cell.deviceName = device.name
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? BLTDeviceCell
        tableView.isUserInteractionEnabled = false
        cell?.startLoading()
        cell?.contentView.backgroundColor = UIColor.borderColor
        if let devices = self.coordinator?.state.devices {
            let device = devices[indexPath.row]
            self.coordinator?.connectDevice(device, success: { [weak self] in
                guard let `self` = self else { return }
                tableView.isUserInteractionEnabled = true
                cell?.endLoading()
                BLTWalletIO.shareInstance()?.selectDevice = device
                self.navigationController?.dismiss(animated: true) {
                    if self.context?.connectSuccessed != nil {
                        self.context?.connectSuccessed!()
                    }
                }
            }, failed: { [weak self] (reason) in
                guard let `self` = self else { return }
                tableView.isUserInteractionEnabled = true
                cell?.endLoading()
                if let failedReason = reason {
                    self.showError(message: failedReason)
                }
            })
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.whiteColor
    }
}
