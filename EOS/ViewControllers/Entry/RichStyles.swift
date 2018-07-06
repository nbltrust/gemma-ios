//
//  RichStyles.swift
//  EOS
//
//  Created by koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import SwiftRichString

enum StyleNames:String {
    case introduce
    case agree
    case agreement
}

class RichStyle {
    init() {
        let introduce_style = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 14.0)
            $0.color = UIColor.steel
            $0.lineSpacing = 4.0
        }
        Styles.register(StyleNames.introduce.rawValue, style: introduce_style)
        
        let agree_style = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 12.0)
            $0.color = UIColor.blueyGrey
        }
        Styles.register(StyleNames.agree.rawValue, style: agree_style)
        
        let agreement_style = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 12.0)
            $0.color = UIColor.darkSlateBlue
            $0.underline = (.styleSingle,UIColor.darkSlateBlue)
        }
        Styles.register(StyleNames.agreement.rawValue, style: agreement_style)
      }
}
