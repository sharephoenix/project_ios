//
//  YSSwitchController.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/12.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import SnapKit

class YSSwitchController: YSBaseController {
    private let ysSwitch = YSSwitch<String>(normal: ["左边", "右边"], selected: ["left", "right"])
    private let ysImgSwitch = YSSwitch<UIImage>(normal: [UIImage.init(named: "face_001")!, UIImage.init(named: "face_002")!], selected: [YSImageManager.imageName("face_002")!, YSImageManager.imageName("face_001")!])
    private let ysImgSwitch1 = YSSwitch<UIImage>(normal: [YSImageManager.imageName("face_001")!, YSImageManager.imageName("face_002")!], selected: [nil, nil])


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "YSSwitch"

        view.backgroundColor = UIColor.init(hex: "#f4f4f4")

        view.addSubview(ysSwitch)
        view.addSubview(ysImgSwitch)
        view.addSubview(ysImgSwitch1)

        ysSwitch.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(122)
            make.width.equalTo(172)
            make.top.equalToSuperview()
            make.height.equalTo(36)
        }

        ysImgSwitch.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(122)
            make.width.equalTo(172)
            make.top.equalTo(ysSwitch.snp.bottom).offset(15)
            make.height.equalTo(36)
        }

        ysImgSwitch1.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(122)
            make.width.equalTo(172)
            make.top.equalTo(ysImgSwitch.snp.bottom).offset(15)
            make.height.equalTo(36)
        }

        ysImgSwitch.selectedIndex = 1

        ysSwitch.normalColor = .blue
        ysSwitch.selectedColor = .red
        ysSwitch.normalFont = UIFont.boldSystemFont(ofSize: 12)
        ysSwitch.selectedFont = UIFont.systemFont(ofSize: 18)
        ysSwitch.switchButtonColor = .green
        ysSwitch.layer.cornerRadius = 18
        ysSwitch.layer.borderColor = UIColor.blue.cgColor
        ysSwitch.layer.borderWidth = 1

        ysImgSwitch.layer.cornerRadius = 18
        ysImgSwitch.layer.borderColor = UIColor.blue.cgColor
        ysImgSwitch.layer.borderWidth = 1
        ysImgSwitch.switchButtonColor = UIColor.init(hex: "#ff0000a4")
        ysImgSwitch.switchSelectedContentMode = .scaleToFill
        ysImgSwitch.switchNormalContentMode = .left

        ysImgSwitch1.layer.cornerRadius = 18
        ysImgSwitch1.layer.borderColor = UIColor.blue.cgColor
        ysImgSwitch1.layer.borderWidth = 1
        ysImgSwitch1.switchIcon = UIImage(named: "face_001")
        ysImgSwitch1.switchButtonColor = UIColor.init(hex: "#ff0000")
        ysImgSwitch1.switchIconMode = .scaleToFill
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.isHidden = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
}
