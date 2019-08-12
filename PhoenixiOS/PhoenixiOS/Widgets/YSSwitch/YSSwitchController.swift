//
//  YSSwitchController.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/12.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import SnapKit

class YSSwitchController: UIViewController {
    private let ysSwitch = YSSwitch<String>(normal: ["左边", "右边"], selected: ["left", "right"])
    private let ysImgSwitch = YSSwitch<UIImage>(normal: [UIImage.init(named: "face_001")!, UIImage.init(named: "face_002")!], selected: [UIImage.init(named: "face_002")!, UIImage.init(named: "face_001")!])
    private let ysImgSwitch1 = YSSwitch<UIImage>(normal: [UIImage.init(named: "face_001")!, UIImage.init(named: "face_002")!], selected: [nil, nil])


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        title = "YSSwitch"

        view.addSubview(ysSwitch)
        view.addSubview(ysImgSwitch)
        view.addSubview(ysImgSwitch1)

        ysSwitch.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(22)
            make.trailing.equalToSuperview().offset(-22)
            make.top.equalToSuperview()
            make.height.equalTo(56)
        }

        ysImgSwitch.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(22)
            make.trailing.equalToSuperview().offset(-22)
            make.top.equalTo(ysSwitch.snp.bottom).offset(15)
            make.height.equalTo(56)
        }

        ysImgSwitch1.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(22)
            make.trailing.equalToSuperview().offset(-22)
            make.top.equalTo(ysImgSwitch.snp.bottom).offset(15)
            make.height.equalTo(56)
        }

        ysImgSwitch.selectedIndex = 1

        ysSwitch.layer.cornerRadius = 28
        ysSwitch.layer.borderColor = UIColor.blue.cgColor
        ysSwitch.layer.borderWidth = 1

        ysImgSwitch.layer.cornerRadius = 28
        ysImgSwitch.layer.borderColor = UIColor.blue.cgColor
        ysImgSwitch.layer.borderWidth = 1

        ysImgSwitch1.layer.cornerRadius = 28
        ysImgSwitch1.layer.borderColor = UIColor.blue.cgColor
        ysImgSwitch1.layer.borderWidth = 1
        ysImgSwitch1.switchIcon = UIImage(named: "face_001")
        createAction()
    }

    private func createAction() {
        ysSwitch.callback = { index in
            print("ysSwitch\(index)")
        }

        ysImgSwitch.callback = { index in
            print("ysImgSwitch\(index)")
        }

        ysImgSwitch1.callback = { index in
            print("ysImgSwitch1\(index)")
        }

    }
}
