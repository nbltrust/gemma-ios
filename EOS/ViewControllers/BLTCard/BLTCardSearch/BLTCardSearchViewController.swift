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

    var BLTIO: BLTWalletIO?

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
        configLeftNavButton(R.image.icTransferClose())

        let nibString = R.nib.bltDeviceCell.identifier
        deviceTable.register(UINib.init(nibName: nibString, bundle: nil), forCellReuseIdentifier: nibString)

        indicatorView = UIActivityIndicatorView(style: .gray)
        indicatorView?.hidesWhenStopped = false
        configRightCustomView(indicatorView!)
    }

    override func leftAction(_ sender: UIButton) {
        self.coordinator?.dismissSearchVC()
    }

    override func rightAction(_ sender: UIButton) {
        if BLTIO != nil {
            searchDevice()
        }
    }

    func setupData() {
        BLTIO = BLTWalletIO.shareInstance()
        BLTIO?.didSearchDevice = {[weak self] device in
            guard let `self` = self else { return }
            self.coordinator?.searchedADevice(device!)
            self.deviceTable.reloadData()
        }
        searchDevice()
    }

    func searchDevice() {
        indicatorView?.startAnimating()
        self.startLoading(true)
        BLTIO?.searchBLTCard({ [weak self] in
            guard let `self` = self else { return }
            self.endLoading()
            self.indicatorView?.stopAnimating()
        })
    }

    func setupEvent() {

    }

    func modelWithDevice(device: BLTDevice) -> LineView.LineViewModel {
        return LineView.LineViewModel.init(name: device.name,
                                           content: "",
                                           imageName: R.image.icArrow.name,
                                           nameStyle: LineViewStyleNames.normalName,
                                           contentStyle: LineViewStyleNames.normalContent,
                                           isBadge: false,
                                           contentLineNumber: 0,
                                           isShowLineView: false)
    }

    override func configureObserveState() {
        coordinator?.state.pageState.asObservable().subscribe(onNext: { (_) in

        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: nibString, for: indexPath) as? BLTDeviceCell else {
            return UITableViewCell()
        }
        if let devices = self.coordinator?.state.devices {
            cell.setup(modelWithDevice(device: devices[indexPath.row]), indexPath: indexPath)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let devices = self.coordinator?.state.devices {
            let device = devices[indexPath.row]
            self.coordinator?.connectDevice(device, success: { [weak self] in
                guard let `self` = self else { return }
                BLTWalletIO.shareInstance()?.selectDevice = device
                self.coordinator?.pushAfterDeviceConnected()
            }, failed: { [weak self] (reason) in
                guard let `self` = self else { return }
                if let failedReason = reason {
                    self.showError(message: failedReason)
                }
            })
        }
    }
}

// MARK: - View Event

//extension BLTCardSearchViewController {
//    @objc func <#view#>DidClicked(_ data:[String: Any]) {
//        if let addressdata = data["data"] as? <#model#>, let view = data["self"] as? <#view#>  {
//
//        }
//    }
//}
