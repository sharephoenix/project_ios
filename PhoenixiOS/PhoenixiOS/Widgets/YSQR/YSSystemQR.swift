//
//  YSSystemQR.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/16.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import CoreImage

class YSSystemQR: NSObject {
    private var device: AVCaptureDevice!
    private var input: AVCaptureDeviceInput!
    private var output: AVCaptureMetadataOutput!
    private var session: AVCaptureSession!
    private var prewview: AVCaptureVideoPreviewLayer!

    private var parentView: UIView?

    private let offsetX = 0
    private let offsetY = 0
    private let width = 300
    private let height = 300

    override init() {
        super.init()
        create()
    }

    private func create() {
        device = AVCaptureDevice.default(for: AVMediaType.video)

        input = try! AVCaptureDeviceInput(device: device)

        output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.high

        if session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        output.metadataObjectTypes = [AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.qr]

        prewview = AVCaptureVideoPreviewLayer(session: session)
        prewview.videoGravity = AVLayerVideoGravity.resizeAspectFill

        if let parentView = parentView {
            setParentView(parentView)
        }

        fixScanArea()

        startRunning()
    }

    func setParentView(_ parentView: UIView) {
        self.parentView = parentView
        if let preview = prewview {
            preview.removeFromSuperlayer()
            parentView.layer.insertSublayer(preview, at: 0)
        }
    }

    var maskLayer = CALayer()

    @objc func fixScanArea() {


        if Thread.current.isMainThread {
            prewview.frame = parentView?.bounds ?? CGRect(x: 0, y: 0, width: 330, height: 330)
            let react = CGRect(x: offsetX, y: offsetY, width: width, height: height)
            output.rectOfInterest = react
            maskLayer.frame = react
//            prewview.mask = maskLayer
        } else {
            perform(#selector(fixScanArea), on: Thread.main, with: nil, waitUntilDone: true)
        }
    }

    func startRunning() {
        session.commitConfiguration()
        session.startRunning()
    }

    func stopRunning() {
        session.stopRunning()
    }

    deinit {
        stopRunning()
    }
}

extension YSSystemQR: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        metadataObjects.forEach { (metaObject) in
            if let meta = metaObject as? AVMetadataMachineReadableCodeObject,
                let content = meta.stringValue {
                YSToast.instance.showToast(content as NSString, sync: false)
            }
        }
    }
}
