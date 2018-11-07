//
//  BannerColor.swift
//  EOS
//
//  Created by koofrank on 2018/8/3.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import NotificationBanner

class BannerColor: BannerColorsProtocol {
    internal func color(for style: BannerStyle) -> UIColor {
        switch style {
        case .danger:   // Your custom .danger color
            return UIColor.warningColor
        case .info:     // Your custom .info color
            return UIColor.warningColor
        case .none:     // Your custom .none color
            return UIColor.warningColor
        case .success:  // Your custom .success color
            return UIColor.successedColor
        case .warning:  // Your custom .warning color
            return UIColor.warningColor
        }
    }
}
