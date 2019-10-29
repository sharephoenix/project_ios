//
//  YSSkinController.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/10/29.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import ReactiveSwift

/// 不可以重复设置动态属性，注意：仅仅可以设置一次
class YSSkinController: UIViewController {

    var button = UIButton()
    var label = UILabel()
    var imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        createActions()
    }

    private func createUI() {
        view.addSubview(button)
        view.addSubview(label)
        view.addSubview(imageView)

        view.backgroundColor_t("color0")
        label.text = "kk"
        label.textColor_t("color2")
        imageView.backgroundColor_t("color1")
        label.font_t("font1")
        imageView.image_t("images-0")
        button.setTitleColor_t("color0", state: UIControl.State.normal)
        button.setTitle("aaa", for: UIControl.State.normal)
        button.backgroundColor_t("color1")

        button.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(150)
            make.width.height.equalTo(44)
        }
        label.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalTo(button.snp.bottom).offset(22)
            make.width.height.equalTo(44)
        }
        imageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalTo(label.snp.bottom).offset(22)
            make.width.height.equalTo(44)
        }

    }

    private func createActions() {
        button.reactive.controlEvents(UIControl.Event.touchUpInside).observeValues { btn in
            if SkinManager.instance.skin == .white {
                SkinManager.instance.skin = .black
            } else {
                SkinManager.instance.skin = .white
            }
        }
    }
}
