//
//  BLTCardEntryViewController.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class BLTCardEntryViewController: BaseViewController {
    @IBOutlet weak var contentView: BLTCardEntryView!

	var coordinator: (BLTCardEntryCoordinatorProtocol & BLTCardEntryStateManagerProtocol)?

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
        self.title = R.string.localizable.wookong_title.key.localized()
    }

    func setupData() {

    }

    func setupEvent() {
        contentView.actionView.button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.coordinator?.presentBLTCardSearchVC()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        contentView.clickLabel.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.coordinator?.pushIntroduceVC()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }

    override func configureObserveState() {
        coordinator?.state.pageState.asObservable().subscribe(onNext: { (_) in

        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}
