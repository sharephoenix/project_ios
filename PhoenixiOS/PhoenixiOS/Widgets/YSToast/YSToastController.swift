//
//  YSToastController.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/14.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import SnapKit
import YSToast
import RxSwift

class YSToastController: YSBaseController {

    private let toastAsyncButton = UIButton()
    private let toastSyncButton = UIButton()
    private let toastTipAsync = UIButton()
    private let toastTipSync = UIButton()
    private let directionPickerView = UIPickerView()

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

        directionPickerView.dataSource = self
        directionPickerView.delegate = self

        view.addSubview(toastAsyncButton)
        view.addSubview(toastSyncButton)
        view.addSubview(toastTipAsync)
        view.addSubview(toastTipSync)
        view.addSubview(directionPickerView)

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

        do {
            directionPickerView.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.height.equalTo(299)
            }
        }

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


extension YSToastController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 9
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let signal = row % 2 == 1 ? -1 : 1

        if component == 0 {
            switch row {
            case 0:
                return "TC"
            case 1:
                return "TL"
            case 2:
                return "TR"
            case 3:
                return "RC"
            case 4:
                return "LC"
            case 5:
                return "CC"
            case 6:
                return "BC"
            case 7:
                return "BL"
            case 8:
                return "BR"
            default:
                return "CC"
            }
        }
        if component == 1 {

            return "offsetX\(row * 20 * signal)"
        }
        if component == 2 {
            return "offsetY\(row * 20 * signal)"
        }
        return "null"
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return view.bounds.width / 3
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("selected:\(row)")
    }
}
