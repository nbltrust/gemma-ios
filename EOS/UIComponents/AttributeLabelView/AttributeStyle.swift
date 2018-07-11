//
//  Created by Pavel Sharanda on 21.02.17.
//  Copyright © 2017 psharanda. All rights reserved.
//

import Foundation

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

#if os(macOS)
    public typealias Font = NSFont
    public typealias Color = NSColor
#else
    public typealias Font = UIFont
    public typealias Color = UIColor
#endif

public enum StyleType {
    case normal
    case disabled
    case highlighted
}

// workaround for https://github.com/psharanda/Atributika/issues/27
#if swift(>=4.1)
    extension NSAttributedStringKey: Equatable { }
	extension NSAttributedStringKey: Hashable { }
#endif

public struct AttributeStyle {
    
    public let name: String
    
    public var attributes: [NSAttributedStringKey: Any] {
        return typedAttributes[.normal] ?? [:]
    }
    
    public var highlightedAttributes: [NSAttributedStringKey: Any] {
        var attrs = attributes
        
        typedAttributes[.highlighted]?.forEach { key, value in
            attrs.updateValue(value, forKey: key)
        }
        
        return attrs
    }
    
    public var disabledAttributes: [NSAttributedStringKey: Any] {
        var attrs = attributes
        
        typedAttributes[.disabled]?.forEach { key, value in
            attrs.updateValue(value, forKey: key)
        }
        
        return attrs
    }
    
    public let typedAttributes: [StyleType: [NSAttributedStringKey: Any]]
    
    public init(_ name: String = "", _ attributes: [NSAttributedStringKey: Any] = [:], _ type: StyleType = .normal) {
        self.name = name
        typedAttributes = [type: attributes]
    }
    
    public init(_ name: String = "", _ typedAttributes: [StyleType: [NSAttributedStringKey: Any]] = [:]) {
        self.name = name
        self.typedAttributes = typedAttributes
    }
    
    public init(_ name: String, AttributeStyle: AttributeStyle) {
        self.name = name
        self.typedAttributes = AttributeStyle.typedAttributes
    }
    
    public func named(_ name: String) -> AttributeStyle {
        return AttributeStyle(name, AttributeStyle: self)
    }
    
    public func merged(with style: AttributeStyle) -> AttributeStyle {
        var attrs = typedAttributes
    
        style.typedAttributes.forEach { type, attributes in
            attributes.forEach { key, value in
                attrs[type, default: [:]].updateValue(value, forKey: key)
            }
        }
        
        return AttributeStyle(name, attrs)
    }
    
    public func font(_ value: Font, _ type: StyleType = .normal) -> AttributeStyle {
        return merged(with: AttributeStyle.font(value, type))
    }
    
    public func paragraphStyle(_ value: NSParagraphStyle, _ type: StyleType = .normal) -> AttributeStyle {
        return merged(with: AttributeStyle.paragraphStyle(value, type))
    }
    
    public func foregroundColor(_ value: Color, _ type: StyleType = .normal) -> AttributeStyle {
        return merged(with: AttributeStyle.foregroundColor(value, type))
    }
    
    public func backgroundColor(_ value: Color, _ type: StyleType = .normal) -> AttributeStyle {
        return merged(with: AttributeStyle.backgroundColor(value, type))
    }
    
    public func ligature(_ value: Int, _ type: StyleType = .normal) -> AttributeStyle {
        return merged(with: AttributeStyle.ligature(value, type))
    }
    
    public func kern(_ value: Float, _ type: StyleType = .normal) -> AttributeStyle {
        return merged(with: AttributeStyle.kern(value, type))
    }
    
    public func strikethroughStyle(_ value: NSUnderlineStyle, _ type: StyleType = .normal) -> AttributeStyle {
        return merged(with: AttributeStyle.strikethroughStyle(value, type))
    }
    
    public func strikethroughColor(_ value: Color, _ type: StyleType = .normal) -> AttributeStyle {
        return merged(with: AttributeStyle.strikethroughColor(value, type))
    }
    
    public func underlineStyle(_ value: NSUnderlineStyle, _ type: StyleType = .normal) -> AttributeStyle {
        return merged(with: AttributeStyle.underlineStyle(value, type))
    }
    
    func underlineColor(_ value: Color, _ type: StyleType = .normal) -> AttributeStyle {
        return merged(with: AttributeStyle.underlineColor(value, type))
    }
    
    public func strokeColor(_ value: Color, _ type: StyleType = .normal) -> AttributeStyle {
        return merged(with: AttributeStyle.strokeColor(value, type))
    }
    
    public func strokeWidth(_ value: Float, _ type: StyleType = .normal) -> AttributeStyle {
        return merged(with: AttributeStyle.strokeWidth(value, type))
    }
    
    #if !os(watchOS)
    public func shadow(_ value: NSShadow, _ type: StyleType = .normal) -> AttributeStyle {
        return merged(with: AttributeStyle.shadow(value, type))
    }
    #endif
    
    public func textEffect(_ value: String, _ type: StyleType = .normal) -> AttributeStyle {
        return merged(with: AttributeStyle.textEffect(value, type))
    }
    
    #if !os(watchOS)
    public func attachment(_ value: NSTextAttachment, _ type: StyleType = .normal) -> AttributeStyle {
        return merged(with: AttributeStyle.attachment(value, type))
    }
    #endif
    
    public func link(_ value: URL, _ type: StyleType = .normal) -> AttributeStyle {
        return merged(with: AttributeStyle.link(value, type))
    }
    
    public func link(_ value: String, _ type: StyleType = .normal) -> AttributeStyle {
        return merged(with: AttributeStyle.link(value, type))
    }
    
    public func baselineOffset(_ value: Float, _ type: StyleType = .normal) -> AttributeStyle {
        return merged(with: AttributeStyle.baselineOffset(value, type))
    }
    
    public func obliqueness(_ value: Float, _ type: StyleType = .normal) -> AttributeStyle {
        return merged(with: AttributeStyle.obliqueness(value, type))
    }
    
    public func expansion(_ value: Float, _ type: StyleType = .normal) -> AttributeStyle {
        return merged(with: AttributeStyle.expansion(value, type))
    }
    
    public func writingDirection(_ value: NSWritingDirection, _ type: StyleType = .normal) -> AttributeStyle {
        return merged(with: AttributeStyle.writingDirection(value, type))
    }
    
    
    public static func font(_ value: Font, _ type: StyleType = .normal) -> AttributeStyle {
        return AttributeStyle("", [NSAttributedStringKey.font: value], type)
    }
    
    public static func paragraphStyle(_ value: NSParagraphStyle, _ type: StyleType = .normal) -> AttributeStyle {
        return AttributeStyle("", [NSAttributedStringKey.paragraphStyle: value], type)
    }
    
    public static func foregroundColor(_ value: Color, _ type: StyleType = .normal) -> AttributeStyle {
        return AttributeStyle("", [NSAttributedStringKey.foregroundColor: value], type)
    }
    
    public static func backgroundColor(_ value: Color, _ type: StyleType = .normal) -> AttributeStyle {
        return AttributeStyle("", [NSAttributedStringKey.backgroundColor: value], type)
    }
    
    public static func ligature(_ value: Int, _ type: StyleType = .normal) -> AttributeStyle {
        return AttributeStyle("", [NSAttributedStringKey.ligature: value], type)
    }
    
    public static func kern(_ value: Float, _ type: StyleType = .normal) -> AttributeStyle {
        return AttributeStyle("", [NSAttributedStringKey.kern: value], type)
    }
    
    public static func strikethroughStyle(_ value: NSUnderlineStyle, _ type: StyleType = .normal) -> AttributeStyle {
        return AttributeStyle("", [NSAttributedStringKey.strikethroughStyle : value.rawValue], type)
    }
    
    public static func strikethroughColor(_ value: Color, _ type: StyleType = .normal) -> AttributeStyle {
        return AttributeStyle("", [NSAttributedStringKey.strikethroughColor: value], type)
    }
    
    public static func underlineStyle(_ value: NSUnderlineStyle, _ type: StyleType = .normal) -> AttributeStyle {
        return AttributeStyle("", [NSAttributedStringKey.underlineStyle : value.rawValue], type)
    }
    
    public static func underlineColor(_ value: Color, _ type: StyleType = .normal) -> AttributeStyle {
        return AttributeStyle("", [NSAttributedStringKey.underlineColor: value], type)
    }
    
    public static func strokeColor(_ value: Color, _ type: StyleType = .normal) -> AttributeStyle {
        return AttributeStyle("", [NSAttributedStringKey.strokeColor: value], type)
    }
    
    public static func strokeWidth(_ value: Float, _ type: StyleType = .normal) -> AttributeStyle {
        return AttributeStyle("", [NSAttributedStringKey.strokeWidth: value], type)
    }
    
    #if !os(watchOS)
    public static func shadow(_ value: NSShadow, _ type: StyleType = .normal) -> AttributeStyle {
        return AttributeStyle("", [NSAttributedStringKey.shadow: value], type)
    }
    #endif
    
    public static func textEffect(_ value: String, _ type: StyleType = .normal) -> AttributeStyle {
        return AttributeStyle("", [NSAttributedStringKey.textEffect: value], type)
    }
    
    #if !os(watchOS)
    public static func attachment(_ value: NSTextAttachment, _ type: StyleType = .normal) -> AttributeStyle {
        return AttributeStyle("", [NSAttributedStringKey.attachment: value], type)
    }
    #endif
    
    public static func link(_ value: URL, _ type: StyleType = .normal) -> AttributeStyle {
        return AttributeStyle("", [NSAttributedStringKey.link: value], type)
    }
    
    public static func link(_ value: String, _ type: StyleType = .normal) -> AttributeStyle {
        return AttributeStyle("", [NSAttributedStringKey.link: value], type)
    }
    
    public static func baselineOffset(_ value: Float, _ type: StyleType = .normal) -> AttributeStyle {
        return AttributeStyle("", [NSAttributedStringKey.baselineOffset: value], type)
    }
    
    public static func obliqueness(_ value: Float, _ type: StyleType = .normal) -> AttributeStyle {
        return AttributeStyle("", [NSAttributedStringKey.obliqueness: value], type)
    }
    
    public static func expansion(_ value: Float, _ type: StyleType = .normal) -> AttributeStyle {
        return AttributeStyle("", [NSAttributedStringKey.expansion: value], type)
    }
    
    public static func writingDirection(_ value: NSWritingDirection, _ type: StyleType = .normal) -> AttributeStyle {
        return AttributeStyle("", [NSAttributedStringKey.writingDirection: value.rawValue], type)
    }
}
