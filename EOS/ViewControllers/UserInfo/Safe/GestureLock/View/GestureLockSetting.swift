//
//  GestureLockSetting.swift
//  EOS
//
//  Created by peng zhu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

public struct GestureLockSetting {
    static let warningColor = UIColor.scarlet
    
    /*手势预览*/
    static let infoNormalColor = UIColor.cloudyBlue
    
    static let infoNormalBorderWidth: CGFloat = 1.0
    
    static let infoHighlightedColor = UIColor.darkSkyBlueTwo
    
    //间距比例：gap/ViewWidth
    static let infoGapRatio: CGFloat = 0.5
    
    /*手势设置*/
    static let lockNormalColor = UIColor.darkSkyBlueTwo
    
    static let lockNormalBoderWidth: CGFloat = 1.0
    
    static let lockHighlightedColor = UIColor.cornflowerBlueThree
    
    static let lockHighlightedBorderWidth: CGFloat = 2.0
    
    //中心圆比例: gap/ViewWidth
    static let centerRatio: CGFloat = 20 / 64
    
    //间距比例：gap/ViewWidth
    static let lockGapRadio: CGFloat = 40 / 64
}
