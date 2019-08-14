//
//  YSButtonController.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/14.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import SnapKit

class YSButtonController: YSBaseController {

    private var ysButton0: YSButton!
    private var ysButton1: YSButton!
    private var ysButton2: YSButton!
    private var ysButton3: YSButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        var foreView: UIView!

        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "icon"), for: UIControl.State.normal)
        button.setTitle("icon", for: UIControl.State.normal)
        button.setTitle("icon", for: UIControl.State.normal)
        button.setTitle("iconhhh", for: UIControl.State.highlighted)
        button.setTitle("iconsss", for: UIControl.State.selected)
        button.setTitle("iconffff", for: UIControl.State.focused)
        button.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        button.backgroundColor = .red
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(44)
            make.top.equalToSuperview().offset(15)
        }
        foreView = button
        foreView.layer.cornerRadius = 5

        ysButton0 = YSButton(gapSize: CGSize(width: 3, height: 0), position: YSButton.Position.labelLeftImageRight)
        ysButton0.setImage(UIImage(named: "icon"), for: UIControl.State.normal)
        ysButton0.setTitle("icon", for: UIControl.State.normal)
        ysButton0.setTitle("iconhhh", for: UIControl.State.highlighted)
        ysButton0.setTitle("iconsss", for: UIControl.State.selected)
        ysButton0.setTitle("iconffff", for: UIControl.State.focused)
        ysButton0.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        view.addSubview(ysButton0)
        ysButton0.backgroundColor = .red
        ysButton0.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(44)
            make.top.equalTo(foreView.snp.bottom).offset(15)
        }
        foreView = ysButton0
        foreView.layer.cornerRadius = 5

/****************************************/
        ysButton1 = YSButton(gapSize: CGSize(width: 3, height: 3), position: YSButton.Position.labelTopImageBottom)
        ysButton1.setImage(UIImage(named: "icon"), for: UIControl.State.normal)
        ysButton1.setTitle("icon", for: UIControl.State.normal)
        ysButton1.setTitle("iconhhh", for: UIControl.State.highlighted)
        ysButton1.setTitle("iconsss", for: UIControl.State.selected)
        ysButton1.setTitle("iconffff", for: UIControl.State.focused)
        ysButton1.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        ysButton1.setTitleColor(.green, for: UIControl.State.selected)
        ysButton1.setTitleColor(.yellow, for: UIControl.State.highlighted)

        view.addSubview(ysButton1)
        ysButton1.backgroundColor = .red
        ysButton1.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(77)
            make.top.equalTo(foreView.snp.bottom).offset(15)
        }
        foreView = ysButton1
        foreView.layer.cornerRadius = 5

        /****************************************/
        ysButton2 = YSButton(gapSize: CGSize(width: 3, height: 3), position: YSButton.Position.labelRightImageLeft)
        ysButton2.setImage(UIImage(named: "icon"), for: UIControl.State.normal)
        ysButton2.setTitle("icon", for: UIControl.State.normal)
        ysButton2.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        ysButton2.setTitle("iconhhh", for: UIControl.State.highlighted)
        ysButton2.setTitle("iconsss", for: UIControl.State.selected)
        ysButton2.setTitle("iconffff", for: UIControl.State.focused)
        view.addSubview(ysButton2)
        ysButton2.backgroundColor = .red
        ysButton2.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(77)
            make.top.equalTo(foreView.snp.bottom).offset(15)
        }
        foreView = ysButton2
        foreView.layer.cornerRadius = 5

        /****************************************/
        ysButton3 = YSButton(gapSize: CGSize(width: 3, height: 3), position: YSButton.Position.labelBottomImageTop)
        ysButton3.setImage(UIImage(named: "icon"), for: UIControl.State.normal)
        ysButton3.setTitle("icon", for: UIControl.State.normal)
        ysButton3.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        ysButton3.setTitle("iconhhh", for: UIControl.State.highlighted)
        ysButton3.setTitle("iconsss", for: UIControl.State.selected)
        ysButton3.setTitle("iconffff", for: UIControl.State.focused)
        view.addSubview(ysButton3)
        ysButton3.backgroundColor = .red
        ysButton3.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(77)
            make.top.equalTo(foreView.snp.bottom).offset(15)
        }
        foreView = ysButton3
        foreView.layer.cornerRadius = 5

    }
}
