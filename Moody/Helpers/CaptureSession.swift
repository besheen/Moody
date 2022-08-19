//
//  CaptureSession.swift
//  Moody
//
//  Created by Carl on 2022/8/16.
//

import UIKit
import AVFoundation

@objc protocol CaptureSessionDelegate {
    func captureSessionDidChangeAuthorizationStatus(authorized: Bool)
    func captureSessionDidCapture(_ image: UIImage?)
}

class CaptureSession: NSObject {
    var isAuthorized: Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    
    var isReady: Bool {
        return !session.inputs.isEmpty
    }
    
    init(delegate: CaptureSessionDelegate) {
        self.delegate = delegate
        super.init()
        if isAuthorized {
            setup()
        } else {
            requestAuthorization()
        }
    }
    
    func start() {
        queue.async {
            self.session.startRunning()
        }
    }
    
    func stop() {
        queue.async {
            self.session.stopRunning()
        }
    }
    
    func createPreviewLayer() -> AVCaptureVideoPreviewLayer {
        return AVCaptureVideoPreviewLayer(session: session)
    }
    
    func captureImage() {
        queue.async {
            self.photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }
    }
    
    // MARK: Private
    fileprivate let session = AVCaptureSession()
    fileprivate var photoOutput: AVCapturePhotoOutput!
    fileprivate let queue = DispatchQueue(label: "moody.capture-queue")
    fileprivate weak var delegate: CaptureSessionDelegate!
    
    fileprivate func setup() {
        session.sessionPreset = AVCaptureSession.Preset.photo
        let discovery = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        if let camera = discovery.devices.first {
            let input = try! AVCaptureDeviceInput(device: camera)
            if session.canAddInput(input) {
                session.addInput(input)
            }
        }
        
        photoOutput = AVCapturePhotoOutput()
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }
    }
    
    fileprivate func requestAuthorization() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { authorized in
            DispatchQueue.main.async {
                self.delegate.captureSessionDidChangeAuthorizationStatus(authorized: authorized)
                guard authorized else { return }
                self.setup()
            }
        }
    }
}

extension CaptureSession: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let image = photo.fileDataRepresentation().flatMap( UIImage.init )
        DispatchQueue.main.async {
            self.delegate.captureSessionDidCapture(image)
        }
    }
}
