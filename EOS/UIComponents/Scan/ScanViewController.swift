//
//  ScanViewController.swift
//  EOS
//
//  Created peng zhu on 2018/7/16.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import AVFoundation

class ScanViewController: BaseViewController {

	var coordinator: (ScanCoordinatorProtocol & ScanStateManagerProtocol)?
    var preView: ScanPreviewView?
    var titleLabel: UILabel?
    var subTitle: String?
    
	override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.title = R.string.localizable.scan_title()
        setupUI()
        setupPreviewLayer()
    }
    
    func commonObserveState() {
        coordinator?.subscribe(errorSubscriber) { sub in
            return sub.select { state in state.errorMessage }.skipRepeats({ (old, new) -> Bool in
                return false
            })
        }
        
        coordinator?.subscribe(loadingSubscriber) { sub in
            return sub.select { state in state.isLoading }.skipRepeats({ (old, new) -> Bool in
                return false
            })
        }
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.clear), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupPreviewLayer() {
        if let captureDevice = AVCaptureDevice.default(for: .video)  {
            let session = AVCaptureSession()
            session.sessionPreset = .high
            do{
                try session.addInput(AVCaptureDeviceInput.init(device: captureDevice))
            }catch let error as NSError {
                log.debug(error)
            }
            
            let output = AVCaptureMetadataOutput()
            if session.canAddOutput(output) {
                session.addOutput(output)
                
                let rect = ScanSetting.scanRect
                let size = self.view.bounds.size
                output.rectOfInterest = CGRect(x: rect.origin.y / size.height, y: rect.origin.x / size.width, width: rect.size.height / size.height, height: rect.size.width / size.width)
                output.metadataObjectTypes = output.availableMetadataObjectTypes
                output.setMetadataObjectsDelegate(self as AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue.main)
            }
            
            preView = ScanPreviewView.init(frame: self.view.bounds)
            preView?.session = session
            self.view.layer.addSublayer((preView?.layer)!)
            session.startRunning()
        }
        
        let rect = ScanSetting.scanRect
        titleLabel = UILabel.init(frame: CGRect(x: 0, y: rect.maxY + 29, width: self.view.width, height: 20))
        titleLabel?.textColor = UIColor.whiteTwo
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        titleLabel?.text = subTitle
        self.view.addSubview(titleLabel!)
    }
    
    override func configureObserveState() {
        commonObserveState()
        
    }
}

extension ScanViewController : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            if let obj: AVMetadataMachineReadableCodeObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                self.coordinator?.updateScanResult(result: obj.stringValue!)
            }
        }
    }
}
