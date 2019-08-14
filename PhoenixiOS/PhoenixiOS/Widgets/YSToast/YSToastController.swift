//
//  YSToastController.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/14.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import SnapKit

class YSToastController: YSBaseController {

    private let toastAsyncButton = UIButton()
    private let toastSyncButton = UIButton()
    private let toastTipAsync = UIButton()
    private let toastTipSync = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        var parentView: UIView!

        toastAsyncButton.setTitle("TopCenter_async", for: .normal)
        toastAsyncButton.setTitleColor(.black, for: .normal)

        toastSyncButton.setTitle("TopCenter_sync", for: .normal)
        toastSyncButton.setTitleColor(.black, for: .normal)

        toastTipAsync.setTitle("TopCenter_tip_async", for: .normal)
        toastTipAsync.setTitleColor(.black, for: .normal)

        toastTipSync.setTitle("TopCenter_tip_sync", for: .normal)
        toastTipSync.setTitleColor(.black, for: .normal)

        view.addSubview(toastAsyncButton)
        view.addSubview(toastSyncButton)
        view.addSubview(toastTipAsync)
        view.addSubview(toastTipSync)

        toastAsyncButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(44)
        }
        parentView = toastAsyncButton
        parentView.backgroundColor = .green
        parentView.layer.cornerRadius = 4

        toastSyncButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(parentView.snp.bottom).offset(15)
            make.height.equalTo(44)
        }
        parentView = toastSyncButton
        parentView.backgroundColor = .green
        parentView.layer.cornerRadius = 4

        toastTipAsync.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(parentView.snp.bottom).offset(15)
            make.height.equalTo(44)
        }
        parentView = toastTipAsync
        parentView.backgroundColor = .green
        parentView.layer.cornerRadius = 4

        toastTipSync.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(parentView.snp.bottom).offset(15)
            make.height.equalTo(44)
        }
        parentView = toastTipSync
        parentView.backgroundColor = .green
        parentView.layer.cornerRadius = 4

        toastAsyncButton.addTarget(self, action: #selector(showToastAsync), for: .touchUpInside)
        toastSyncButton.addTarget(self, action: #selector(showToastSync), for: .touchUpInside)

        toastTipSync.addTarget(self, action: #selector(showTipSync), for: .touchUpInside)
        toastTipAsync.addTarget(self, action: #selector(showTipAsync), for: .touchUpInside)
    }

    @objc private func showToastAsync() {
        let imageView = UIImageView(image: UIImage(named: "face_001"))
        imageView.frame = CGRect(x: 0, y: 0, width: 88, height: 88)
        YSToast.instance.showAsyncView(imageView)
    }

    @objc private func showToastSync() {
        let imageView = UIImageView(image: UIImage(named: "face_001"))
        imageView.frame = CGRect(x: 0, y: 0, width: 88, height: 88)
        // 取消之前的 toast，否者会顺序执行
        YSToast.instance.clearToast()
        YSToast.instance.showSyncView(imageView)
    }

    @objc private func showTipAsync() {
        YSToast.instance.showToast("this is my title", sync: false)
    }

    @objc private func showTipSync() {
        YSToast.instance.clearToast()
        YSToast.instance.showToast("this is my titlethis is my titlethis is my titlethis is my titlethis is my titlethis is my title", sync: true)
    }
}
