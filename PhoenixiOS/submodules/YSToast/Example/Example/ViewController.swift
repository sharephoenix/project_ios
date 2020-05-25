//
//  ViewController.swift
//  Example
//
//  Created by eric on 2020/4/9.
//  Copyright © 2020 eric. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift
import ReactiveCocoa

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        createAction()
    }
    
    private func createUI() {
        view.addSubview(testBtn)
        
        testBtn.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.center.equalToSuperview()
        }
    }
    
    private func createAction() {
        testBtn.reactive.controlEvents(UIControl.Event.touchUpInside).observeValues { btn in
            YSToast.instance.showToast("this is")
//            let customView = CustomToastLabel()
//            customView.text = "this is my test tittle"
//            YSToast.instance.showAsyncView(customView)
        }
    }
    
    private let testBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        return button
    }()
}

class CustomToastLabel: UILabel, YSToastProtocol {
    // 这个可以默认不写
    func ys_view() -> UIView {
        return self
    }
    
    func ys_direction() -> YSToast.Direction {
        return .RC
    }
    
    func ys_size() -> CGSize {
        return CGSize(width: 200, height: 33)
    }
   
    func ys_offset() -> UIOffset {
       return UIOffset(horizontal: 0, vertical: 0)
    }
   
    func ys_parentView() -> UIView? {
        return UIApplication.shared.windows.last
    }
}

