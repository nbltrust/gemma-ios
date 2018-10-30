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

    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.interactivePopGestureRecognizer?.delegate = self

        self.navigationBar.shadowImage = UIImage()
        setupNav()

        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.baseColor]
        if #available(iOS 11.0, *) {
            self.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.baseColor]
        }
        self.navigationBar.tintColor = UIColor.rightItemColor

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
            viewController.configLeftNavButton(nil)
            super.pushViewController(viewController, animated: animated)
        } else {
            super.pushViewController(viewController, animated: animated)
        }
    }

    @discardableResult
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if self.children.count == 2 {
            let vc = self.children[1]
            vc.hidesBottomBarWhenPushed = false
        } else {
            let count = self.children.count - 2
            let vc = self.children[count]
            vc.hidesBottomBarWhenPushed = true
        }
        return super.popToViewController(viewController, animated: animated)
    }

}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        // Ignore interactive pop gesture when there is only one view controller on the navigation stack
        if viewControllers.count <= 1 {
            return false
        }
        return true
    }
}
