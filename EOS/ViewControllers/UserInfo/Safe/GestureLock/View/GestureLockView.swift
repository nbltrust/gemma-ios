//
//  GestureLockView.swift
//  EOS
//
//  Created by peng zhu on 2018/7/16.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

protocol GestureLockViewDelegate: NSObjectProtocol {
    func gestureLockViewDidTouchesEnd(_ lockView: GestureLockView)
}

class GestureLockView: UIView {

    open weak var delegate: GestureLockViewDelegate?

    open var locked = false

    private var itemLayers: [GestureItemLayer] = []

    private var selectedItemLayers: [GestureItemLayer] = []

    private var mainPath = UIBezierPath()

    private var interval: TimeInterval = 0

    private(set) var password = ""

    private var lastLocation = CGPoint(x: 0, y: 0)

    private var shapeLayer: CAShapeLayer? {
        return layer as? CAShapeLayer
    }

    open var itemSizes: (width: CGFloat, gap: CGFloat, centerRadius: CGFloat) = (64, 40, 10) {
        didSet {
            setNeedsLayout()
        }
    }

    override open class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupLayer()
    }

    fileprivate func setupLayer() {
        self.shapeLayer?.lineCap = CAShapeLayerLineCap.round
        self.shapeLayer?.lineJoin = CAShapeLayerLineJoin.round
        self.shapeLayer?.fillColor = UIColor.clear.cgColor
        self.shapeLayer?.strokeColor = GestureLockSetting.lockHighlightedColor.cgColor
        self.shapeLayer?.lineWidth = GestureLockSetting.lockHighlightedBorderWidth
    }

    fileprivate func setupUI() {
        for _ in 0 ..< 9 {
            let itemLayer = GestureItemLayer()
            itemLayers.append(itemLayer)
            layer.addSublayer(itemLayer)
        }

        reSizeLayer()
    }

    func reSizeLayer() {
        if itemLayers.count > 0 {
            let marginX = (frame.width - itemSizes.width.adapt() * 3 - itemSizes.gap.adapt() * 2) / 2
            let marginY = (frame.height - itemSizes.width.adapt() * 3 - itemSizes.gap.adapt() * 2) / 2

            for (idx, sublayer) in itemLayers.enumerated() {
                let row = CGFloat(idx % 3)
                let col = CGFloat(idx / 3)
                let originX = (itemSizes.width.adapt() + itemSizes.gap.adapt()) * row + marginX
                let originY = (itemSizes.width.adapt() + itemSizes.gap.adapt()) * col + marginY
                sublayer.index = idx
                sublayer.centerRadio = itemSizes.centerRadius
                sublayer.width = itemSizes.width.adapt()
                sublayer.origin = CGPoint(x: originX, y: originY)
            }
        }
    }

    public func showSelectedItems(_ passwordStr: String) {
        for char in passwordStr {
            itemLayers[Int("\(char)")!].status = .highlighted
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        reSizeLayer()
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        processTouch(touches)
    }

    override open func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        processTouch(touches)
    }

    override open func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
        touchesEnd()
    }

    override open func touchesCancelled(_: Set<UITouch>?, with _: UIEvent?) {
        touchesEnd()
    }

    private func processTouch(_ touches: Set<UITouch>) {
        let location = touches.first!.location(in: self)
        guard let itemLayer = itemLayer(with: location) else {
            return
        }
        if selectedItemLayers.contains(itemLayer) {
            return
        }
        selectedItemLayers.append(itemLayer)
        password += itemLayer.index.description
        itemLayer.status = locked ? .locked : .highlighted
        drawLine()
    }

    private func touchesEnd() {
        self.isUserInteractionEnabled = false
        delegate?.gestureLockViewDidTouchesEnd(self)
        delay(1.0) {
            self.reset()
        }
    }

    func delay(_ interval: TimeInterval, handle: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: handle)
    }

    private func itemLayer(with touchLocation: CGPoint) -> GestureItemLayer? {
        for subLayer in itemLayers {
            if !subLayer.frame.contains(touchLocation) {
                continue
            }
            return subLayer
        }
        return nil
    }

    private func drawLine() {

        if selectedItemLayers.isEmpty { return }

        for (idx, itemlayer) in selectedItemLayers.enumerated() {
            let directPoint = itemlayer.position
            if idx == 0 {
                lastLocation = directPoint
                mainPath.move(to: directPoint)
            } else {
                let lastItemlayer = selectedItemLayers[idx - 1]
                lastItemlayer.dirAngle = angleBetweenLines(lastLocation, endPoint: directPoint)
                mainPath.addLine(to: directPoint)
                lastLocation = directPoint
            }
        }
        shapeLayer?.path = mainPath.cgPath
    }

    private func angleBetweenLines(_ startPoint: CGPoint, endPoint: CGPoint) -> CGFloat {
        let xPoint = CGPoint(x: startPoint.x + 100, y: startPoint.y)
        let endX = endPoint.x - startPoint.x
        let endY = endPoint.y - startPoint.y
        let startX = xPoint.x - startPoint.x
        let startY = xPoint.y - startPoint.y
        var rads = acos(((endX * startX) + (endY * startY)) / ((sqrt(endX * endX + endY * endY)) * (sqrt(startX * startX + startY * startY))))
        if startPoint.y > endPoint.y {
            rads = 2 * CGFloat.pi - rads
        }
        return rads
    }

    public func warn() {
        interval = 1
        selectedItemLayers.forEach { $0.status = .warning }
        shapeLayer?.strokeColor = GestureLockSetting.warningColor.cgColor
    }

    public func reset() {
        self.isUserInteractionEnabled = true
        interval = 0
        shapeLayer?.strokeColor = locked ? GestureLockSetting.warningColor.cgColor : GestureLockSetting.lockHighlightedColor.cgColor
        selectedItemLayers.forEach { $0.status = .normal }
        selectedItemLayers.removeAll()
        mainPath.removeAllPoints()
        shapeLayer?.path = mainPath.cgPath
        password = ""
        drawLine()
    }

}
