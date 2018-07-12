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

class BaseViewController: UIViewController {
    lazy var errorSubscriber: BlockSubscriber<String?> = BlockSubscriber {[weak self] s in
        guard let `self` = self else { return }
        
    }
    
    lazy var loadingSubscriber: BlockSubscriber<Bool> = BlockSubscriber {[weak self] s in
        guard let `self` = self else { return }
    }
    
    var showWholeNavBg = false
    var navBgImageView:UIImageView?
    var contentView:UIView?

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
        
        let imageView = UIImageView(image: R.image.navigationBg2())
        self.view.insertSubview(imageView, at: 0)
        imageView.top(to: self.view, offset:0)
        imageView.leftToSuperview()
        imageView.rightToSuperview()
        navBgImageView = imageView
        
        if !showWholeNavBg {
            let contentView = UIView()
            contentView.backgroundColor = UIColor.white
            self.view.insertSubview(contentView, at: 1)
            contentView.edgesToDevice(vc: self, insets: .zero, priority: .required, isActive: true, usingSafeArea: true)
            
            self.contentView = contentView
        }
        
        configureObserveState()
    }
    
    func changeBackgroundColor(_ color:UIColor) {
        self.view.backgroundColor = color
        self.contentView?.backgroundColor = color
    }
    
    func hiddenNavBar() {
        self.navigationController?.navigationBar.isHidden = true
        navBgImageView?.isHidden = true
    }
    
    func showNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        navBgImageView?.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func configureObserveState() {
        //    fatalError("must be realize this methods!")
        
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return false
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


