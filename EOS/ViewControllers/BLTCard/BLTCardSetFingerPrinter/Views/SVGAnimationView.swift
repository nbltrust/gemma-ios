//
//  SVGAnimationView.swift
//  EOS
//
//  Created by peng zhu on 2018/9/25.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit

class SVGAnimationView: EOSBaseView {

    var baseLayer: CAShapeLayer?

    var animationLayer: CAShapeLayer?

    var progressData: (currentIndex: Int, successed: Bool) = (0, false) {
        didSet {
            updateProgress()
        }
    }

    private let mainPath = UIBezierPath()

    private let animationPath = UIBezierPath()

    fileprivate var proFiles: [String] = ["f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8", "f9", "f10", "f11", "f12", "f13", "f14"]

    fileprivate var startFile = "f_start"

    fileprivate var endFile = "f_end"

    override func setup() {
        baseLayer = CAShapeLayer()
        baseLayer?.bounds = self.bounds
        self.layer.addSublayer(baseLayer!)

        animationLayer = CAShapeLayer()
        animationLayer?.bounds = self.bounds
        self.layer.addSublayer(animationLayer!)

        changeToStart()
    }

    func changeToStart() {
        mainPath.removeAllPoints()
        let paths = pathsWithFile(startFile)
        paths.forEach { (path) in
            mainPath.append(UIBezierPath(cgPath: path.cgPath))
            mainPath.stroke()
            baseLayer?.path = mainPath.cgPath
        }
    }

    func changeToEnd() {
        mainPath.removeAllPoints()
        let paths = pathsWithFile(endFile)
        paths.forEach { (path) in
            mainPath.append(path)
        }
        baseLayer?.path = mainPath.cgPath
    }

    func pathsWithFile(_ file: String) -> [SVGBezierPath] {
        let svgURL = Bundle.main.url(forResource: file, withExtension: "svg")!
        let paths = SVGBezierPath.pathsFromSVG(at: svgURL)
        return paths
    }

    func updateProgress() {
        if progressData.currentIndex > 0 {
            let index = progressData.currentIndex - 1 - (!progressData.successed ? 1 : 0)
            let paths = pathsWithFile(proFiles[max(0, min(proFiles.count - 1, index))])
            if progressData.successed {
                paths.forEach { (path) in
                    animationPath.append(UIBezierPath(cgPath: path.cgPath))
                }
                UIView.animate(withDuration: 1.0, animations: {
                    self.animationLayer?.path = self.animationPath.cgPath
                }) { (complication) in
                    if complication {
                        self.animationPath.removeAllPoints()
                        self.animationLayer?.path = self.animationPath.cgPath
                        paths.forEach({ (path) in
                            self.mainPath.append(UIBezierPath(cgPath: path.cgPath))
                        })
                        self.baseLayer?.path = self.mainPath.cgPath
                    }
                }
            } else {
                paths.forEach { (path) in
                    animationPath.append(UIBezierPath(cgPath: path.cgPath))
                }
                UIView.animate(withDuration: 1.0, animations: {
                    self.animationLayer?.path = self.animationPath.cgPath
                }) { (complication) in
                    if complication {
                        self.animationPath.removeAllPoints()
                        UIView.animate(withDuration: 1.0, animations: {
                            self.animationLayer?.path = self.animationPath.cgPath
                        })
                    }
                }
            }
        }
    }

}
