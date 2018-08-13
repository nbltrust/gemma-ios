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
    var captusession: AVCaptureSession?
    
    
	override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        checkCameraAuth()
    }
    
    func checkCameraAuth() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            if status == .notDetermined {
                AVCaptureDevice.requestAccess(for: .video) {[weak self] (authorized) in
                    guard let `self` = self else { return }
                    self.loadScanView()
                }
            } else if status == .authorized {
                self.loadScanView()
            } else {
                self.loadScanView()
                self.showAlert(title: R.string.localizable.prompt(), message: R.string.localizable.guide_open_camera(), buttonTitles: [R.string.localizable.got_it()])
            }
        } else {
            self.loadScanView()
            self.showAlert(title: R.string.localizable.prompt(), message: R.string.localizable.unsupport_camera(), buttonTitles: [R.string.localizable.got_it()])
        }
    }
    
    func loadScanView() {
        loadLabel()
        initSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    func loadLabel() {
        self.title = R.string.localizable.scan_title()
        self.configLeftNavButton(nil)
        let rect = ScanSetting.scanRect
        titleLabel = UILabel.init(frame: CGRect(x: 0, y: rect.maxY + 29, width: self.view.width, height: 20))
        if let label = titleLabel  {
            label.textColor = UIColor.whiteTwo
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = subTitle
            self.view.addSubview(label)
        }
    }
    
    func setupPreviewLayer() {
        preView = ScanPreviewView.init(frame: self.view.bounds)
        if let previewView = preView {
            previewView.session = captusession
            self.view.layer.insertSublayer(previewView.layer, at: 0)
        }
    }
    
    func initSession() {
        let size = self.view.bounds.size
        DispatchQueue.global().async {
            let session = AVCaptureSession()
            session.sessionPreset = .high
            self.addInput(session)
            self.addOutput(session, size: size)
            session.startRunning()
        
            DispatchQueue.main.async {
                self.captusession = session
                self.setupPreviewLayer()
            }
        }
       
    }
    
    func addInput(_ session: AVCaptureSession) {
        if let captureDevice = AVCaptureDevice.default(for: .video) {
            do{
                try session.addInput(AVCaptureDeviceInput.init(device: captureDevice))
            }catch let error as NSError {
                log.error(error)
            }
        }
    }
    
    func addOutput(_ session: AVCaptureSession, size:CGSize) {
        let output = AVCaptureMetadataOutput()
        if session.canAddOutput(output) {
            session.addOutput(output)
            
            let rect = ScanSetting.scanRect
            output.rectOfInterest = CGRect(x: rect.origin.y / size.height, y: rect.origin.x / size.width, width: rect.size.height / size.height, height: rect.size.width / size.width)
            output.metadataObjectTypes = output.availableMetadataObjectTypes
            output.setMetadataObjectsDelegate(self as AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue.main)
        }
    }
    
    override func leftAction(_ sender: UIButton) {
        self.coordinator?.dismissVC()
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
