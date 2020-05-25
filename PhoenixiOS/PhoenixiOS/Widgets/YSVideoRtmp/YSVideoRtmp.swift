//
//  YSSystemQR.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/16.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import YSToast

class YSVideoRtmp: NSObject {

    private var captureDevice: AVCaptureDevice!
    private var captureSession: AVCaptureSession!
    private var captureDeviceInput: AVCaptureDeviceInput!
    private var captureDeviceOutput: AVCaptureMovieFileOutput!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var dataOutPut: AVCaptureVideoDataOutput!

    weak var parentView: UIView?

    override init() {
        super.init()
        create()
    }

    /// 展示层的赋值
    func resetDisplay(parentView: UIView) {
        self.parentView = parentView
        previewLayer.removeFromSuperlayer()
        parentView.layer.insertSublayer(previewLayer, at: 0)
    }

    @objc func startRunning() {
        if Thread.current.isMainThread {
            self.captureSession.startRunning()
        } else {
            perform(#selector(startRunning), on: Thread.main, with: nil, waitUntilDone: false)
        }
    }

    @objc func stopRunning() {
        if Thread.current.isMainThread {
            self.captureSession.startRunning()
        } else {
            perform(#selector(stopRunning), on: Thread.main, with: nil, waitUntilDone: false)
        }
    }

    private func create() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd1280x720

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill;

        captureDevice = AVCaptureDevice.default(for: AVMediaType.video)

        captureDeviceInput = try! AVCaptureDeviceInput(device: captureDevice)

        if captureSession.canAddInput(captureDeviceInput) {
            captureSession.addInput(captureDeviceInput)
            captureSession.commitConfiguration()
            startRunning()
        }
        captureSession.beginConfiguration()

        previewLayer.frame = parentView?.bounds ?? CGRect.zero
        previewLayer.backgroundColor = UIColor.yellow.cgColor

        if let parentView = parentView {
            resetDisplay(parentView: parentView)
        }

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
}


extension YSVideoRtmp: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("out")
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        if #available(iOS 9.0, *) {

            var ciImage = CIImage(cvImageBuffer: pixelBuffer)
            let temporaryContext = CIContext(options: nil)
            guard let videoImagef = temporaryContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))) else { return }
            var image = UIImage(cgImage: videoImagef)
            image = self.grayImage(image: image)
            ciImage = CIImage(cgImage: image.cgImage!)

            do {
                DispatchQueue.main.async {
                    let params = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
                    let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: temporaryContext, options: params)
                    let features = detector?.features(in: ciImage, options: params)
                    features?.forEach({ (feature) in
                        if let qr = feature as? CIQRCodeFeature,
                            let message = qr.messageString{
                            YSToast.instance.showToast(message as NSString, sync: false)
                        } else {
                            print(feature.type)
                        }
                    })

                }

            }

            DispatchQueue.main.async {
                self.parentView?.subviews.forEach({ (v) in
                    v.removeFromSuperview()
                })
                let imageview = UIImageView(image: self.grayImage(image: image))
                imageview.frame = CGRect(x: 0, y: 0, width: image.size.width , height: image.size.height)
                self.parentView?.addSubview(imageview)
            }
            print("out_end")
        } else {
            print("out_end_fail")
            return
        }
    }
    func grayImage(image:UIImage) -> UIImage {
        let imageSize = image.size//获取原图像的尺寸属性
        let width = Int(imageSize.width)//获取原图像的宽度
        let height = Int(imageSize.height)
        //创建灰度色彩空间的对象，各种设备对待颜色的方式都不同，颜色必须有一个相关的色彩空间，否则图像上下文将不知道如何解释相关的颜色值
        let spaceRef = CGColorSpaceCreateDeviceGray()
        //参数1：指向要渲染的绘制内存的地址，参数2，3：高度和宽度，参数4：表示内存中像素的每个组件的位数，参数5：每一行在内存所占的比特数
        //参数6：表示上下文使用的颜色空间，参数7：表示是否包含透明通道
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: spaceRef, bitmapInfo: CGBitmapInfo().rawValue)!
        let rect = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)//创建一个源图像同样尺寸的空间
        context.draw(image.cgImage!, in: rect)//在灰度上下文中画入图片

        let grayImage = UIImage(cgImage: context.makeImage()!)//从上下文中获取并生成转为灰度的图片
        return grayImage//返回最终的灰度图片
    }
}
