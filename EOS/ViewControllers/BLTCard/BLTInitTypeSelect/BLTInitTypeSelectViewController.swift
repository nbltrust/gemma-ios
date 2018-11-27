//
//  BLTInitTypeSelectViewController.swift
//  EOS
//
//  Created peng zhu on 2018/11/27.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class BLTInitTypeSelectViewController: BaseViewController {
    @IBOutlet weak var creatView: Button!

    @IBOutlet weak var importView: Button!

    var coordinator: (BLTInitTypeSelectCoordinatorProtocol & BLTInitTypeSelectStateManagerProtocol)?

    private(set) var context: BLTInitTypeSelectContext?

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
    }

    func setupData() {
    }

    func setupEvent() {
        creatView.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.coordinator?.dismissNav({
                if self.context?.isCreateCallback != nil {
                    self.context?.isCreateCallback!(true)
                }
            })
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        importView.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.coordinator?.dismissNav({
                if self.context?.isCreateCallback != nil {
                    self.context?.isCreateCallback!(false)
                }
            })
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }

    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }
            if let context = context as? BLTInitTypeSelectContext {
                self.context = context
            }
        }).disposed(by: disposeBag)
    }
}
