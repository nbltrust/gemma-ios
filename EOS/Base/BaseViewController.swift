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
    
    var table:UITableView?
    var leftNavButton: UIButton?
    var rightNavButton: UIButton?
    
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
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .never
        }
        
        
        configureObserveState()
        
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
    
    
    func startLoading() {
      
    }
    
 
    
    func endLoading() {
    }
    
    func endLoading(_ after:TimeInterval) {
    }
    
    func configLeftNavButton(_ image:UIImage?) {
        leftNavButton = UIButton.init(type: .custom)
        leftNavButton?.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        leftNavButton?.setImage(image ?? #imageLiteral(resourceName: "ic_view_list_24px"), for: .normal)
        leftNavButton?.addTarget(self, action: #selector(leftAction(_:)), for: .touchUpInside)
        leftNavButton?.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftNavButton!)
    }
    
    func configRightNavButton(_ image:UIImage? = nil) {
        rightNavButton = UIButton.init(type: .custom)
        rightNavButton?.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        rightNavButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightNavButton?.setImage(image ?? #imageLiteral(resourceName: "icSettings24Px"), for: .normal)
        rightNavButton?.addTarget(self, action: #selector(rightAction(_:)), for: .touchUpInside)
        rightNavButton?.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightNavButton!)
    }
    
    func configRightNavButton(_ locali:String) {
        rightNavButton = UIButton.init(type: .custom)
        rightNavButton?.frame = CGRect(x: 0, y: 0, width: 58, height: 24)
        rightNavButton?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightNavButton?.locali = locali
        rightNavButton?.setTitleColor(.steel, for: .normal)
        rightNavButton?.addTarget(self, action: #selector(rightAction(_:)), for: .touchUpInside)
        rightNavButton?.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightNavButton!)
    }
    
    @objc open func leftAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc open func rightAction(_ sender: UIButton) {
        
    }
    
    deinit {
        print("dealloc: \(self)")
    }
}
