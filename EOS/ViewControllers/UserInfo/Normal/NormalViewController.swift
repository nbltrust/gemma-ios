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
    @IBOutlet weak var languageCell: NormalCellView!

    @IBOutlet weak var coinUnitCell: NormalCellView!

    @IBOutlet weak var nodeCell: NormalCellView!

    var coordinator: (NormalCoordinatorProtocol & NormalStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        setupViewSize()
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
        setupUI()
        languageCell.reload()
        coinUnitCell.reload()
        nodeCell.reload()
    }

    func setupUI() {
        self.title = R.string.localizable.mine_normal.key.localized()
        languageCell.content.text = self.coordinator?.contentWithSender(CustomSettingType.language)
        coinUnitCell.content.text = self.coordinator?.contentWithSender(CustomSettingType.asset)
        nodeCell.content.text = self.coordinator?.contentWithSender(CustomSettingType.node)
    }

    func setupViewSize () {
        languageCell.content.font = UIFont.systemFont(ofSize: 14)
        languageCell.content.textColor = Color.blueyGrey
        coinUnitCell.content.font = UIFont.systemFont(ofSize: 14)
        coinUnitCell.content.textColor = Color.blueyGrey
        nodeCell.content.font = UIFont.systemFont(ofSize: 14)
        nodeCell.content.textColor = Color.blueyGrey
    }

    override func configureObserveState() {

    }
}

extension NormalViewController {
    @objc func clickCellView(_ sender: [String: Any]) {
        let index = sender["index"] as! Int
        self.coordinator?.openContent(index)
    }
}
