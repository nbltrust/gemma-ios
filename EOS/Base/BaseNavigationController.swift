//
//  BaseNavigationController.swift
//  EOS
//
//  Created by koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

enum NavStyle: Int {
    case common = 1
    case white
    case clear
}

class BaseNavigationController: UINavigationController {
    var navStyle: NavStyle = .common {
        didSet {
            self.setupNav()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.interactivePopGestureRecognizer?.delegate = self
        
        self.navigationBar.shadowImage = UIImage()
        setupNav()

        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17),NSAttributedStringKey.foregroundColor:UIColor.whiteTwo]
        if #available(iOS 11.0, *) {
            self.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.whiteTwo]
        }
        self.navigationBar.tintColor = UIColor.whiteTwo
        
        //    self.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "ic_arrow_back_16px")
        //    self.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "ic_arrow_back_16px")
        
    }
    
    func setupNav() {
        if navStyle == .clear {
            let image = UIImage.init(color: UIColor.clear)
            self.navigationBar.setBackgroundImage(image, for: .default)
            self.navigationBar.isTranslucent = true
        } else if navStyle == .white {
            let image = UIImage.init(color: UIColor.white)
            self.navigationBar.setBackgroundImage(image, for: .default)
            self.navigationBar.isTranslucent = false
        } else {
            self.navigationBar.setBackgroundImage(navBgImage(), for: .default)
            self.navigationBar.isTranslucent = false
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count != 0 {
            viewController.hidesBottomBarWhenPushed = true
            super.pushViewController(viewController, animated: true)
        }
        else {
            super.pushViewController(viewController, animated: true)
        }
    }
    
    @discardableResult
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if self.childViewControllers.count == 2 {
            let vc = self.childViewControllers[1]
            vc.hidesBottomBarWhenPushed = false
        } else {
            let count = self.childViewControllers.count - 2
            let vc = self.childViewControllers[count]
            vc.hidesBottomBarWhenPushed = true
        }
        return super.popToViewController(viewController, animated: animated)
    }
 
}

extension BaseNavigationController: UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        // Ignore interactive pop gesture when there is only one view controller on the navigation stack
        if viewControllers.count <= 1 {
            return false
        }
        return true
    }
}
