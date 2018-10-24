//
//  UIViewController+Extensions.swift
//  EOS
//
//  Created by koofrank on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ESPullToRefresh
import KRProgressHUD
import UINavigationItem_Margin

extension UIViewController {
    func configLeftNavButton(_ image: UIImage?) {
        let leftNavButton = UIButton.init(type: .custom)
        leftNavButton.frame = CGRect(x: 0, y: 0, width: 48, height: 24)
        leftNavButton.setImage(image ?? #imageLiteral(resourceName: "ic_back_24_px"), for: .normal)
        leftNavButton.addTarget(self, action: #selector(leftAction(_:)), for: .touchUpInside)
        leftNavButton.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftNavButton)
        self.navigationItem.leftMargin = 0
    }

    func configRightNavButton(_ image: UIImage? = nil) {
        let rightNavButton = UIButton.init(type: .custom)
        rightNavButton.frame = CGRect(x: 0, y: 0, width: 48, height: 24)
        rightNavButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightNavButton.setImage(image ?? #imageLiteral(resourceName: "icSettings24Px"), for: .normal)
        rightNavButton.addTarget(self, action: #selector(rightAction(_:)), for: .touchUpInside)
        rightNavButton.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightNavButton)
        self.navigationItem.rightMargin = 0
    }

    func configRightCustomView(_ view: UIView) {
        view.width = 48
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: view)
        self.navigationItem.rightMargin = 0
    }

    func configRightNavButton(_ locali: String) {
        let rightNavButton = UIButton.init(type: .custom)
        rightNavButton.frame = CGRect(x: 0, y: 0, width: 58, height: 24)
        rightNavButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightNavButton.locali = locali
        rightNavButton.setTitleColor(.white, for: .normal)
        rightNavButton.addTarget(self, action: #selector(rightAction(_:)), for: .touchUpInside)
        rightNavButton.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightNavButton)
    }

    @objc open func leftAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @objc open func rightAction(_ sender: UIButton) {

    }
}

extension UIViewController {
    func startLoading(_ isClearBg: Bool? = nil) {
        startLoadingOnSelf(true, message: "", isClearBg: isClearBg)
    }

    func startLoadingWithMessage(message: String) {
        startLoadingOnSelf(true, message: message)
    }

    func startLoadingOnSelf(_ isOn: Bool, message: String, isClearBg: Bool? = nil) {
        if isOn {
            _ = KRProgressHUD.showOn(self)
        }
        if let isClear = isClearBg, isClear {
            KRProgressHUD.set(maskType: .custom(color: UIColor.clear))
        } else {
            KRProgressHUD.set(maskType: .custom(color: UIColor.black40))
        }
        KRProgressHUD.set(style: .custom(background: UIColor.white, text: UIColor.cornflowerBlueTwo, icon: UIColor.cornflowerBlueTwo))
        KRProgressHUD.set(activityIndicatorViewColors: [UIColor.cornflowerBlueTwo, UIColor.cornflowerBlueTwo])
        if message == "" {
            KRProgressHUD.show()
        } else {
            KRProgressHUD.show(withMessage: message, completion: nil)
        }
    }

    func endLoading() {
        KRProgressHUD.dismiss()
    }

    func showError(message: String) {
        showFailTop(message)
    }

    func showSuccess(message: String) {
        showSuccessTop(message)
    }

    @objc func refreshViewController() {

    }
}

extension UIViewController {
    func addPullToRefresh(_ tableView: UITableView, callback:@escaping(((()->Void)?)->Void)) {

        tableView.es.addPullToRefresh {
            callback({
                tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
            })
        }

    }

    func addInfiniteScrolling(_ tableView: UITableView, callback:@escaping(((Bool)->Void)?)->Void) {
        tableView.es.addInfiniteScrolling {

            callback({ isNoMoreData in
                if isNoMoreData {
                    tableView.es.noticeNoMoreData()
                } else {
                    tableView.es.stopLoadingMore()
                }
            })
        }
    }
}
