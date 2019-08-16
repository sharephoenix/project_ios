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

    private let ysSystemQr = YSSystemQR()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "系统二维码扫描"

        ysSystemQr.setParentView(view)
        ysSystemQr.fixScanArea()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ysSystemQr.setParentView(view)
        ysSystemQr.fixScanArea()
    }

    deinit {

    }
}
