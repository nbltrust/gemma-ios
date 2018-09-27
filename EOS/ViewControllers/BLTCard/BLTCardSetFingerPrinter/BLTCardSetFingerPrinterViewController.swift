//
//  BLTCardSetFingerPrinterViewController.swift
//  EOS
//
//  Created peng zhu on 2018/9/25.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import SwifterSwift

class BLTCardSetFingerPrinterViewController: BaseViewController {

    @IBOutlet weak var fpView: UIWebView!
    
    @IBOutlet weak var fpWidth: NSLayoutConstraint!
    
    @IBOutlet weak var fpHeight: NSLayoutConstraint!
    
    var coordinator: (BLTCardSetFingerPrinterCoordinatorProtocol & BLTCardSetFingerPrinterStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupUI()
        setupEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func refreshViewController() {
        
    }
    
    func setupUI() {
        self.title = R.string.localizable.wookong_set_fp.key.localized()
        
        setupFPView()
    
        configRightNavButton(R.string.localizable.wookong_jump.key.localized())
    }
    
    override func rightAction(_ sender: UIButton) {
        self.coordinator?.dismissVC()
    }
    
    func setupFPView() {
        fpView.scrollView.isScrollEnabled = false
        fpView.backgroundColor = UIColor.clear
        fpView.isOpaque = false

        if let path = Bundle.main.path(forResource: "finger", ofType: "html") {
            let url = URL.init(fileURLWithPath: path)
            fpView.loadRequest(URLRequest.init(url: url))
        }
    }
    
    func nextStep() {
        fpView.stringByEvaluatingJavaScript(from: "next()")
    }
    
    func prevStep() {
        nextStep()
        SwifterSwift.delay(milliseconds: 500) {
            self.fpView.stringByEvaluatingJavaScript(from: "prev()")
        }
    }
    
    func done() {
        fpView.stringByEvaluatingJavaScript(from: "done()")
        showSuccess(message: R.string.localizable.wookong_set_fp_success.key.localized())
        self.coordinator?.dismissVC()
    }

    func setupData() {
        
    }
    
    func setupEvent() {
        self.coordinator?.enrollFingerPrinter({ [weak self] (state) in
            guard let `self` = self else { return }
            if state == FingerPrinterState.good {
                self.nextStep()
            } else {
                self.prevStep()
            }
        }, success: { [weak self] in
            guard let `self` = self else { return }
            self.done()
        }, failed: { [weak self]  (reason) in
            guard let `self` = self else { return }
            if let failedReason = reason {
                self.showError(message: failedReason)
            }
        })
    }
    
    override func configureObserveState() {
        
    }
}


extension BLTCardSetFingerPrinterViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.sizeToFit()
        fpWidth.constant = webView.width
        fpHeight.constant = webView.height
        self.view.updateConstraintsIfNeeded()
    }
}
