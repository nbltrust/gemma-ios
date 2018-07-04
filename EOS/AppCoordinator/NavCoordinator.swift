//
//  NavCoordinator.swift
//  EOS
//
//  Created by koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

protocol NavProtocol {
    func openWebVC(url:URL)
}

class NavCoordinator:NavProtocol {
    
    weak var rootVC: BaseNavigationController!
    
    init(rootVC: BaseNavigationController) {
        self.rootVC = rootVC
    }
    
    func start()  {
        
    }
}

extension NavCoordinator {
    func openWebVC(url:URL) {
        let web = BaseWebViewController()
        web.url = url
        
        self.rootVC.pushViewController(web, animated: true)
    }
    
}
