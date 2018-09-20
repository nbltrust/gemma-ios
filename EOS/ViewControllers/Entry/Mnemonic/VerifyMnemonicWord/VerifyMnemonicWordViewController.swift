//
//  VerifyMnemonicWordViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class VerifyMnemonicWordViewController: BaseViewController {

    @IBOutlet weak var contentView: VerifyMnemonicWordView!
    
    var coordinator: (VerifyMnemonicWordCoordinatorProtocol & VerifyMnemonicWordStateManagerProtocol)?
    
    var seeds: [String] = []
    
    var checkStr: String = ""
    
    private var tempSeeds: [String] = []

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
        self.title = R.string.localizable.verify_mnemonic_title.key.localized()
    }

    func setupData() {
        shuffleSeeds()
        contentView.setPoolArray(self.tempSeeds)
    }
    
    func shuffleSeeds() {
        tempSeeds = seeds
//        tempSeeds = shuffleArray(arr: seeds)
    }
    
    func shuffleArray(arr:[String]) -> [String] {
        var data:[String] = arr
        for i in 1..<arr.count {
            let index:Int = Int(arc4random()) % i
            if index != i {
                data.swapAt(i, index)
            }
        }
        return data
    }
    
    func setupEvent() {
        
    }
    
    override func configureObserveState() {

    }
}

//MARK: - View Event
extension VerifyMnemonicWordViewController {
    @objc func VerifyMnemonicWord(_ data:[String: Any]) {
        if let selectValues = data["data"] as? [String]  {
            if selectValues.count == seeds.count {
                if let isValid = self.coordinator?.validSequence(seeds, compairDatas: selectValues), isValid {
                    showSuccess(message: R.string.localizable.wookong_mnemonic_ver_successed.key.localized())
                    self.coordinator?.checkSeed(checkStr, success: { [weak self] in
                        guard let `self` = self else { return }
                        self.coordinator?.checkFeedSuccessed()
                    }, failed: { [weak self] (reason) in
                        guard let `self` = self else { return }
                        if let failedReason = reason {
                            self.showError(message: failedReason)
                        }
                    })
                } else {
                    showError(message: R.string.localizable.wookong_mnemonic_ver_failed.key.localized())
                }
            }
        }
    }
}

