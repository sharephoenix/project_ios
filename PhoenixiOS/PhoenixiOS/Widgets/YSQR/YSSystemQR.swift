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
import YSToast

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
            converToMetadataOutputReact(cropRect: react,
                                        session: session,
                                        prewview: prewview,
                                        output: output)
            maskLayer.frame = react
//            parentView?.layer.mask = maskLayer
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

    private func converToMetadataOutputReact(cropRect: CGRect,
                                             session: AVCaptureSession,
                                             prewview: AVCaptureVideoPreviewLayer,
                                             output: AVCaptureMetadataOutput) {
        let size = prewview.bounds.size
        let p1: CGFloat = size.height / size.width
        var p2: CGFloat = 0.0

        switch session.sessionPreset {
        case .hd1920x1080:
            p2 = 1920 / 1080
        case .cif352x288:
            p2 = 352 / 288
        case .hd1920x1080:
            p2 = 1920 / 1080
        case .iFrame1280x720:
            p2 = 1280 / 720
        case .iFrame960x540:
            p2 = 960 / 540
        case .hd1280x720:
            p2 = 1280 / 720
        case .high:
            p2 = 1920 / 1080
        case .medium:
            p2 = 480 / 360
        case .low:
            p2 = 192 / 144
        case .photo:
            p2 = 4 / 3
        case .inputPriority:
            p2 = 1920 / 1080
        case .hd4K3840x2160:
            p2 = 3840 / 2160
        default:
            p2 = 1920 / 1080
        }

        if prewview.videoGravity == AVLayerVideoGravity.resize {
            output.rectOfInterest = CGRect(x: cropRect.minY / size.height,
                                                    y: (size.width - (cropRect.width + cropRect.minX)) / size.width,
                                                    width: cropRect.size.height / size.height,
                                                    height: cropRect.width / size.width)
        } else if prewview.videoGravity == AVLayerVideoGravity.resizeAspectFill {
            if p1 < p2 {
                let fixHeight = size.width * p2
                let fixPadding = (fixHeight - size.height) / 2

                output.rectOfInterest = CGRect(x: (cropRect.minY + fixPadding) / fixHeight,
                                                        y: (size.width - (cropRect.width + cropRect.minX)) / size.width,
                                                        width: cropRect.size.height / fixHeight,
                                                        height: cropRect.width / size.width)
            } else {
                let fixWidth = size.height * (1 / p2)
                let fixPadding = (fixWidth - size.width) / 2
                output.rectOfInterest = CGRect(x: cropRect.minY / size.height,
                                                        y: (size.width - (cropRect.width + cropRect.minX) + fixPadding) / fixWidth,
                                                        width: cropRect.size.height / size.height,
                                                        height: cropRect.width / fixWidth)
            }
        } else if prewview.videoGravity == AVLayerVideoGravity.resizeAspect {
            if p1 > p2 {
                let fixHeight = size.width * p2
                let fixPadding = (fixHeight - size.height) / 2
                output.rectOfInterest = CGRect(x: (cropRect.minY + fixPadding) / fixHeight,
                                                        y: (size.width - (cropRect.width + cropRect.minX)) / size.width,
                                                        width: cropRect.size.height / fixHeight,
                                                        height: cropRect.width / size.width)
            } else {
                let fixWidth = size.height * (1 / p2)
                let fixPadding = (fixWidth - size.width) / 2
                output.rectOfInterest = CGRect(x: cropRect.minY / size.height,
                                                        y: (size.width - (cropRect.width + cropRect.minX) + fixPadding) / fixWidth,
                                                        width: cropRect.size.height / size.height,
                                                        height: cropRect.width / fixWidth)
            }
        }
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
