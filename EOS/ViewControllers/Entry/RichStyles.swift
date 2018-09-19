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
    case comfirmContent
    case activate
}

enum LineViewStyleNames:String {
    case normal_name
    case select_name
    case normal_content
    case transfer_confirm
    case confirm_name
}

extension Style {
    func setupLineHeight(_ lineHeight:CGFloat, fontHeight:CGFloat) {
        self.maximumLineHeight = lineHeight
        self.minimumLineHeight = lineHeight
        self.baselineOffset = labelBaselineOffset(lineHeight, fontHeight: lineHeight)
    }
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
            $0.underline = (.single,UIColor.darkSlateBlue)
        }
        Styles.register(StyleNames.agreement.rawValue, style: agreement_style)
        
        let comfirmContent_style = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 14.0)
            $0.color = UIColor.blueyGrey
            $0.lineSpacing = 8.0
        }
        Styles.register(StyleNames.comfirmContent.rawValue, style: comfirmContent_style)
        
        let check_style = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 12.0)
            $0.color = UIColor.darkSlateBlue
            $0.underline = (.single,UIColor.darkSlateBlue)
        }
        Styles.register(StyleNames.agreement.rawValue, style: check_style)
        
        initLineViewStyle()
        initActivateLabelStyle()
      }
    
    func initLineViewStyle(){
        let name_style = Style{
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 14.0)
            $0.color = UIColor.darkSlateBlue
        }
        Styles.register(LineViewStyleNames.normal_name.rawValue, style: name_style)
        
        let select_name_style = Style{
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 14.0)
            $0.color = UIColor.whiteTwo
        }
        Styles.register(LineViewStyleNames.select_name.rawValue, style: select_name_style)
        
        let content_style = Style{
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 14.0)
            $0.color = UIColor.cloudyBlue
        }
        Styles.register(LineViewStyleNames.normal_content.rawValue, style: content_style)
        
        let confirm_style = Style{
            $0.font = SystemFonts.PingFangSC_Semibold.font(size: 16.0)
            $0.color = UIColor.darkSlateBlue
        }
        Styles.register(LineViewStyleNames.transfer_confirm.rawValue, style: confirm_style)

        let confirm_name_style = Style{
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 14.0)
            $0.color = UIColor.steel
        }
        Styles.register(LineViewStyleNames.confirm_name.rawValue, style: confirm_name_style)
    }
    
    func initActivateLabelStyle() {
        let base = Style{
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 12.0)
            $0.color = UIColor.blueyGrey
        }
//
//        let bluey_grey = Style {
//            $0.color = UIColor.blueyGrey
//        }
        
        let corn_flower_blue = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 12.0)
            $0.color = UIColor.cornflowerBlue
        }
        
        let corn_flower_blue_underline = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 12.0)
            $0.color = UIColor.cornflowerBlue
            $0.underline = (.single, UIColor.cornflowerBlue)
            $0.alignment = .center
        }
        
        let myGroup = StyleGroup(base: base, ["corn_flower_blue_underline":corn_flower_blue_underline,"corn_flower_blue":corn_flower_blue])
        StylesManager.shared.register(StyleNames.activate.rawValue, style: myGroup)
    }
}
