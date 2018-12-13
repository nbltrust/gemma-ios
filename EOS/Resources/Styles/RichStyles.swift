//
//  RichStyles.swift
//  EOS
//
//  Created by koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import SwiftRichString
import Localize_Swift

enum StyleNames: String {
    case introduce
    case agree
    case agreement
    case comfirmContent
    case activate
    case clickLine
}

enum LineViewStyleNames: String {
    case normalName
    case selectName
    case normalContent
    case transferConfirm
    case confirmName
    case ramPrice
}

extension Style {
    func setupLineHeight(_ lineHeight: CGFloat, fontHeight: CGFloat) {
        self.maximumLineHeight = lineHeight
        self.minimumLineHeight = lineHeight
        self.baselineOffset = labelBaselineOffset(lineHeight, fontHeight: lineHeight)
    }
}

class RichStyle {
    static var shared = RichStyle()

    func start() {

    }

    init() {
        changeStyle()

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: LCLLanguageChangeNotification), object: nil, queue: nil, using: {_ in
            self.start()
            self.changeStyle()
        })

        let introduceStyle = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 14.0)
            $0.color = UIColor.introductionColor
            $0.lineSpacing = 4.0
        }
        Styles.register(StyleNames.introduce.rawValue, style: introduceStyle)

        let agreeStyle = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 14.0)
            $0.color = UIColor.placeholderColor
        }
        Styles.register(StyleNames.agree.rawValue, style: agreeStyle)

        let agreementStyle = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 14.0)
            $0.color = UIColor.baseColor
            $0.underline = (.single, UIColor.introductionColor)
        }
        Styles.register(StyleNames.agreement.rawValue, style: agreementStyle)

        let comfirmContentStyle = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 14.0)
            $0.color = UIColor.baseColor
            $0.lineSpacing = 8.0
        }
        Styles.register(StyleNames.comfirmContent.rawValue, style: comfirmContentStyle)

        let checkStyle = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 12.0)
            $0.color = UIColor.baseColor
            $0.underline = (.single, UIColor.baseColor)
        }
        Styles.register(StyleNames.agreement.rawValue, style: checkStyle)

        initLineViewStyle()
        initActivateLabelStyle()
        initClickLineLabelStyle()
    }

    func changeStyle() {

    }

    //PingFangSC-Regular_12_#F7F8FAFF_20
    func constructStyle(_ fontSize: CGFloat = 12, color: UIColor = UIColor.white, lineHeight: CGFloat = 20, font: SystemFonts = SystemFonts.PingFangSC_Regular) {
        let style = Style {
            let realfont = font.font(size: fontSize)
            $0.font = realfont
            $0.color = color

            $0.setupLineHeight(lineHeight, fontHeight: realfont.lineHeight)
        }

        Styles.register("\(font.rawValue)_\(fontSize)_\(color.hexString)_\(lineHeight)", style: style)
    }

    func tagText(_ nestText: String, fontSize: CGFloat = 12, color: UIColor = UIColor.white, lineHeight: CGFloat = 20, font: SystemFonts = SystemFonts.PingFangSC_Regular) -> String {
        let tag = "\(font.rawValue)_\(fontSize)_\(color.hexString)_\(lineHeight)"

        if !StylesManager.shared.styles.keys.contains(tag) {
            constructStyle(fontSize, color: color, lineHeight: lineHeight, font: font)
        }
        return "<\(tag)>" + nestText + "</\(tag)>"
    }

    func initLineViewStyle() {
        let nameStyle = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 16.0)
            $0.color = UIColor.baseColor
        }
        Styles.register(LineViewStyleNames.normalName.rawValue, style: nameStyle)

        let selectNameStyle = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 16.0)
            $0.color = UIColor.baseColor
        }
        Styles.register(LineViewStyleNames.selectName.rawValue, style: selectNameStyle)

        let contentStyle = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 16.0)
            $0.color = UIColor.placeholderColor
        }
        Styles.register(LineViewStyleNames.normalContent.rawValue, style: contentStyle)

        let confirmStyle = Style {
            $0.font = SystemFonts.PingFangSC_Semibold.font(size: 16.0)
            $0.color = UIColor.baseColor
        }
        Styles.register(LineViewStyleNames.transferConfirm.rawValue, style: confirmStyle)

        let confirmNameStyle = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 14.0)
            $0.color = UIColor.baseLightColor
        }
        Styles.register(LineViewStyleNames.confirmName.rawValue, style: confirmNameStyle)

        let ramPriceStyle = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 12.0)
            $0.color = UIColor.introductionColor
        }
        Styles.register(LineViewStyleNames.ramPrice.rawValue, style: ramPriceStyle)
    }

    func initClickLineLabelStyle() {
        let underLine = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 14.0)
            $0.underline = (.single, UIColor.introductionColor)
            $0.color = UIColor.introductionColor
            $0.alignment = .center
        }

        StylesManager.shared.register(StyleNames.clickLine.rawValue, style: underLine)
    }

    func initActivateLabelStyle() {
        let base = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 16.0)
            $0.color = UIColor.introductionColor
        }
        //
        //        let bluey_grey = Style {
        //            $0.color = UIColor.blueyGrey
        //        }

        let cornFlowerBlue = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 16.0)
            $0.color = UIColor.highlightColor
        }

        let cornFlowerBlueUnderline = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 16.0)
            $0.color = UIColor.highlightColor
            $0.underline = (.single, UIColor.highlightColor)
            $0.alignment = .center
//            $0.linkURL = NetworkConfiguration.DAppSinUpEOS
        }

        let myGroup = StyleGroup(base: base, ["corn_flower_blue_underline": cornFlowerBlueUnderline, "corn_flower_blue": cornFlowerBlue])
        StylesManager.shared.register(StyleNames.activate.rawValue, style: myGroup)
    }
}
