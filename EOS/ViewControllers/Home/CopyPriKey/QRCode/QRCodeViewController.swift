//
//  QRCodeViewController.swift
//  EOS
//
//  Created peng zhu on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import XLPagerTabStrip

class QRCodeViewController: BaseViewController, IndicatorInfoProvider {

    var coordinator: (QRCodeCoordinatorProtocol & QRCodeStateManagerProtocol)?

    @IBOutlet weak var qrCodeView: QRCodeView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configureObserveState() {

    }
}

extension QRCodeViewController {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(stringLiteral: R.string.localizable.qrcode_title.key.localized())
    }
}
