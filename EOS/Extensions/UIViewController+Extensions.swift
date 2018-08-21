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

extension UIViewController {
    func configLeftNavButton(_ image:UIImage?) {
        let leftNavButton = UIButton.init(type: .custom)
        leftNavButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        leftNavButton.setImage(image ?? #imageLiteral(resourceName: "ic_back_24_px"), for: .normal)
        leftNavButton.addTarget(self, action: #selector(leftAction(_:)), for: .touchUpInside)
        leftNavButton.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftNavButton)
    }
    
    func configRightNavButton(_ image:UIImage? = nil) {
        let rightNavButton = UIButton.init(type: .custom)
        rightNavButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        rightNavButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightNavButton.setImage(image ?? #imageLiteral(resourceName: "icSettings24Px"), for: .normal)
        rightNavButton.addTarget(self, action: #selector(rightAction(_:)), for: .touchUpInside)
        rightNavButton.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightNavButton)
    }
    
    func configRightNavButton(_ locali:String) {
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
    func startLoading() {
        startLoadingOnSelf(true)
    }
    
    func startLoadingOnSelf(_ isOn: Bool) {
        if isOn {
            _ = KRProgressHUD.showOn(self)
        }
        KRProgressHUD.set(maskType: .clear)
        KRProgressHUD.set(style: .black)
        KRProgressHUD.set(activityIndicatorViewStyle: .gradationColor(head: UIColor.whiteTwo, tail: UIColor.whiteThree))
        KRProgressHUD.show()
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
    func addPullToRefresh(_ tableView : UITableView,callback:@escaping(((()->Void)?)->Void)){
       
        tableView.es.addPullToRefresh {
            callback({
                tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
            })
        }
        
    }
    
    
    func addInfiniteScrolling(_ tableView : UITableView ,callback:@escaping(((Bool)->())?)->()){
        tableView.es.addInfiniteScrolling {
            
            callback({ isNoMoreData in
                if isNoMoreData {
                    tableView.es.noticeNoMoreData()
                }else{
                    tableView.es.stopLoadingMore()
                }
            })
        }
    }
}


