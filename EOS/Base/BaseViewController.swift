//
//  BaseViewController.swift
//  EOS
//
//  Created by koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift
import RxSwift
import RxCocoa
import Localize_Swift

class BaseViewController: UIViewController {
    var isNavBarShadowHidden: Bool = false {
        didSet {
            if isNavBarShadowHidden {
                navigationController?.navigationBar.shadowImage = UIImage()
            } else {
                navigationController?.navigationBar.shadowImage = UIImage()
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDswicoder: NSCoder) {
        super.init(coder: aDswicoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showNavBar()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.extendedLayoutIncludesOpaqueBars = true
        
//        if #available(iOS 11.0, *) {
//            navigationController?.navigationBar.prefersLargeTitles = false
//            navigationItem.largeTitleDisplayMode = .never
//        }
        
        
        self.view.backgroundColor = UIColor.white

        configureObserveState()
        
        observeLanguage()
    }
    
    func observeLanguage() {
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil, queue: nil) {[weak self] (notifi) in
            guard let `self` = self else { return }
            self.languageChanged()
        }
    }
    
    func hiddenNavBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func showNavBar() {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showNavBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func languageChanged() {
        
    }
    
    func configureObserveState() {
        //    fatalError("must be realize this methods!")
        
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    func changeNavBar(isUserInteractionEnabled: Bool) {
        self.navigationController?.navigationBar.rx.observe(Bool.self, "isUserInteractionEnabled").subscribe(onNext: { [weak self] (enabled) in
            guard let `self` = self else { return }
            
            if self.navigationController?.visibleViewController != self {
                return
            }
            //      print("Change Change Change")
            if isUserInteractionEnabled {
                self.navigationController?.navigationBar.isUserInteractionEnabled = true
                self.navigationController?.navigationBar.subviews.forEach({ (view) in
                    view.isUserInteractionEnabled = true
                })
            } else {
                self.navigationController?.navigationBar.isUserInteractionEnabled = false
                self.navigationController?.navigationBar.subviews.forEach({ (view) in
                    view.isUserInteractionEnabled = false
                })
            }
            
        }).disposed(by: disposeBag)
    }

  
    
    deinit {
        print("dealloc: \(self)")
    }
}


