//
//  CameraViewController.swift
//  Moody
//
//  Created by Carl on 2022/8/15.
//

import UIKit
import AVFoundation

@objc protocol CameraViewControllerDelegate {
    func didCapture(_ image: UIImage)
}

class CameraViewController: UIViewController {
    lazy var tipLabel: UILabel = {
        let tipLabel = UILabel()
        tipLabel.font = UIFont.systemFont(ofSize: 16)
        tipLabel.textColor = .white
        tipLabel.textAlignment = .center
        return tipLabel
    }()
    
    var authorized: Bool = false {
        didSet {
            tipLabel.text = authorized ? "CameraView.tapToCapture" : "CameraView.needAccess"
        }
    }
    
    weak var delegate: CameraViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        session = CaptureSession(delegate: self)
        setup(for: session.createPreviewLayer())
        
        view.addSubview(self.tipLabel)
        tipLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view).offset(-24)
            make.centerX.equalTo(view)
        }
        updateAuthorizationStatus()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(snap))
        view.addGestureRecognizer(recognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        session.stop()
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.previewLayer?.frame = view.bounds
    }
    
    @objc func snap(_ recognizer: UITapGestureRecognizer) {
        session.captureImage()
    }
    
    func setup(for previewLayer: AVCaptureVideoPreviewLayer) {
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.insertSublayer(previewLayer, at: 0)
        self.previewLayer = previewLayer
    }
    
    // MARK: Private
    fileprivate var session: CaptureSession!
    fileprivate var imagePicker: UIImagePickerController?
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer?
    
    fileprivate var readyToSnap: Bool {
        return session.isAuthorized
    }
    
    fileprivate func updateAuthorizationStatus() {
        authorized = readyToSnap
    }
}

extension CameraViewController: CaptureSessionDelegate {
    func captureSessionDidCapture(_ image: UIImage?) {
        guard let image = image else { return }
        self.delegate.didCapture(image)
    }
    
    func captureSessionDidChangeAuthorizationStatus(authorized: Bool) {
        updateAuthorizationStatus()
    }
}
