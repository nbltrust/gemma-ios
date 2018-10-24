//
//  UIView+Extensions.swift
//  EOS
//
//  Created by peng zhu on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import TinyConstraints

extension UIView {

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

    var centerX: CGFloat {
        get { return self.center.x }
        set { self.center = CGPoint(x: newValue, y: self.centerY) }
    }

    var centerY: CGFloat {
        get { return self.center.y }
        set { self.center = CGPoint(x: self.centerX, y: newValue) }
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
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.saveGState()
        UIRectClip(rect)
        self.layer.render(in: context)

        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return  newImage

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

extension UIView {
    public func edgesToDevice(vc: UIViewController,
                              insets: TinyEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                              priority: LayoutPriority = .required,
                              isActive: Bool = true,
                              usingSafeArea: Bool = false) {
        if #available(iOS 11.0, *) {
            edgesToSuperview(insets: insets, priority: priority, isActive: isActive, usingSafeArea: usingSafeArea)
        } else {
            prepareForLayout()
            let constraints = [
                topAnchor.constraint(equalTo: vc.topLayoutGuide.bottomAnchor, constant: insets.top).with(priority),
                leadingAnchor.constraint(equalTo: superview!.leadingAnchor, constant: insets.left).with(priority),
                bottomAnchor.constraint(equalTo: vc.bottomLayoutGuide.topAnchor, constant: insets.bottom).with(priority),
                trailingAnchor.constraint(equalTo: superview!.trailingAnchor, constant: insets.right).with(priority)
            ]

            if isActive {
                Constraint.activate(constraints)
            }
        }

    }

    public func topToDevice( _ vc: UIViewController,
                             offset: CGFloat = 0,
                             relation: ConstraintRelation = .equal,
                             priority: LayoutPriority = .required,
                             isActive: Bool = true,
                             usingSafeArea: Bool = false) -> Constraint {
        if #available(iOS 11.0, *) {
            return topToSuperview(nil, offset: offset, relation: relation, priority: priority, isActive: isActive, usingSafeArea: usingSafeArea)
        } else {
            prepareForLayout()

            switch relation {
            case .equal: return topAnchor.constraint(equalTo: vc.topLayoutGuide.bottomAnchor, constant: offset).with(priority).set(active: isActive)
            case .equalOrLess: return topAnchor.constraint(lessThanOrEqualTo: vc.topLayoutGuide.bottomAnchor, constant: offset).with(priority).set(active: isActive)
            case .equalOrGreater: return topAnchor.constraint(greaterThanOrEqualTo: vc.topLayoutGuide.bottomAnchor, constant: offset).with(priority).set(active: isActive)
            }
        }
    }
}

extension UIView {
    var noDataView: WithNoDataView? {
        get {
            if let nodata = self.subviews.last as? WithNoDataView {
                return nodata
            }
            return nil
        }
        set {
            if let newValue = newValue {
                self.addSubview(newValue)
            }
        }
    }

    func showNoData(_ noticeWord: String, icon: String) {
        if let _ = self.noDataView {
            self.noDataView?.noticeWord = noticeWord
            self.noDataView?.iconName = icon
        } else {
            let nodata = WithNoDataView(frame: self.bounds)
            self.noDataView = nodata
            self.noDataView?.noticeWord = noticeWord
            self.noDataView?.iconName = icon
        }
    }

    func showNoData(_ noticeWord: String) {
        if let _ = self.noDataView {
            self.noDataView?.noticeWord = noticeWord
        } else {
            let nodata = WithNoDataView(frame: self.bounds)
            self.noDataView = nodata
            self.noDataView?.noticeWord = noticeWord
            self.noDataView?.noticeContairner.constant = -64
        }
    }
    func hiddenNoData() {
        if let _ = self.noDataView {
            self.noDataView!.removeFromSuperview()
            self.noDataView = nil
        }
    }
}
