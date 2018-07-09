//
//  UIView+Extensions.swift
//  EOS
//
//  Created by peng zhu on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

extension UIView {
    var x: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    
    var y: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    
    var width: CGFloat {
        get { return self.frame.size.width }
        set { self.frame.size.width = newValue }
    }
    
    var height: CGFloat {
        get { return self.frame.size.height }
        set { self.frame.size.height = newValue }
    }
    
    var top: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    var right: CGFloat {
        get { return self.frame.origin.x + self.width }
        set { self.frame.origin.x = newValue - self.width }
    }
    var bottom: CGFloat {
        get { return self.frame.origin.y + self.height }
        set { self.frame.origin.y = newValue - self.height }
    }
    var left: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    
    var centerX: CGFloat{
        get { return self.center.x }
        set { self.center = CGPoint(x: newValue,y: self.centerY) }
    }
    
    var centerY: CGFloat {
        get { return self.center.y }
        set { self.center = CGPoint(x: self.centerX,y: newValue) }
    }
    
    var origin: CGPoint {
        set { self.frame.origin = newValue }
        get { return self.frame.origin }
    }
    var size: CGSize {
        set { self.frame.size = newValue }
        get { return self.frame.size }
    }
    
    
    func drawRectShadow(rect: CGRect) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        context.saveGState()
        UIRectClip(rect);
        self.layer.render(in: context)

        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();

        return  newImage;
        
//        log.debug(self.frame.size)
//        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
//        defer {
//            UIGraphicsEndImageContext()
//        }
//        guard let context = UIGraphicsGetCurrentContext() else { return nil }
//        layer.render(in: context)
//        UIRectClip(rect)
//
//        return UIGraphicsGetImageFromCurrentImageContext()
        
    }
}
