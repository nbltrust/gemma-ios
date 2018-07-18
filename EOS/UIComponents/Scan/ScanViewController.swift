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
    var output: AVCaptureMetadataOutput?
    var session: AVCaptureSession?
    var preView: ScanPreviewView?
    
	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == AVAuthorizationStatus.authorized {
            if let captureDevice = AVCaptureDevice.default(for: .audio)  {
                session = AVCaptureSession()
                
                do{
                    try session?.addInput(AVCaptureDeviceInput.init(device: captureDevice))
                }catch let error as NSError {
                    log.debug(error)
                }
                
                output = AVCaptureMetadataOutput()
                if (session?.canAddOutput(output!))! {
                    session?.addOutput(output!)
                    
                    let rect = ScanSetting.scanRect
                    let size = self.view.bounds.size
                    output?.rectOfInterest = CGRect(x: rect.origin.y / size.height, y: rect.origin.x / size.width, width: rect.size.height / size.height, height: rect.size.width / size.width)
                    output?.metadataObjectTypes = output?.availableMetadataObjectTypes
                    output?.setMetadataObjectsDelegate(self as AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue.main)
                }
                
                preView = ScanPreviewView.init(frame: self.view.bounds)
                preView?.session = session
                self.view.addSubview(preView!)
                session?.startRunning()
            }
        } else {
            AVCaptureDevice.requestAccess(for: .video) { (can) in
                log.debug("can")
            }
            log.debug("camera close")
        }
        
    }
    
    override func configureObserveState() {
        commonObserveState()
        
    }
}

extension ScanViewController : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
    }
}
