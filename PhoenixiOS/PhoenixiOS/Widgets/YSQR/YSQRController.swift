//
//  YSQRController.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/15.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import CoreImage

class YSQRController: YSBaseController {

    private var captureDevice: AVCaptureDevice!
    private var captureSession: AVCaptureSession!
    private var captureDeviceInput: AVCaptureDeviceInput!
    private var captureDeviceOutput: AVCaptureMovieFileOutput!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var dataOutPut: AVCaptureVideoDataOutput!

    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd1280x720

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill;

//        if #available(iOS 10.0, *) {
        captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
////            captureDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.back)
//        } else {
//            return
//        }

        captureDeviceInput = try! AVCaptureDeviceInput(device: captureDevice)

        if captureSession.canAddInput(captureDeviceInput) {
            captureSession.addInput(captureDeviceInput)
            captureSession.commitConfiguration()
            startRunning()
        }
        captureSession.beginConfiguration()

        previewLayer.frame = view.bounds
        previewLayer.backgroundColor = UIColor.yellow.cgColor
        view.layer.addSublayer(previewLayer)

        dataOutput()
    }

    private func dataOutput() {
        dataOutPut = AVCaptureVideoDataOutput()
        dataOutPut.alwaysDiscardsLateVideoFrames = true
        if captureSession.canAddOutput(dataOutPut) {
            captureSession.addOutput(dataOutPut)
            captureSession.commitConfiguration()
            startRunning()
        }
        dataOutPut.setSampleBufferDelegate(self, queue: DispatchQueue.global())
    }

    @objc private func startRunning() {
        if Thread.current.isMainThread {
            self.captureSession.startRunning()
        } else {
            perform(#selector(startRunning), on: Thread.main, with: nil, waitUntilDone: false)
        }
    }

    @objc private func stopRunning() {
        if Thread.current.isMainThread {
            self.captureSession.startRunning()
        } else {
            perform(#selector(stopRunning), on: Thread.main, with: nil, waitUntilDone: false)
        }
    }

    @objc private func stopCaptrue() {

    }

    deinit {
//        stopRunning()
    }
}

extension YSBaseController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("out")
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        if #available(iOS 9.0, *) {
            let ciImage = CIImage(cvImageBuffer: pixelBuffer)
            let temporaryContext = CIContext(options: nil)
            guard let videoImage = temporaryContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))) else { return }

            do {
                let params = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
                let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: temporaryContext, options: params)
                let features = detector?.features(in: ciImage, options: params)
                features?.forEach({ (feature) in
                    if let qr = feature as? CIQRCodeFeature {
                        let message = qr.messageString
                        YSToast.instance.showToast(message as! NSString, sync: false)
                    } else {
                        print(feature.type)
                    }
                })

            }

            let image = UIImage(cgImage: videoImage)

            DispatchQueue.main.async {
                self.view.subviews.forEach({ (v) in
                    v.removeFromSuperview()
                })
                let imageview = UIImageView(image: image)
                imageview.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
                self.view.addSubview(imageview)
            }
            print("out_end")
        } else {
            print("out_end_fail")
            return
        }

    }

    func contert(sampleBuffer: CMSampleBuffer) {

    }
}

