//
//  GuideController.swift
//  PhoenixiOS
//
//  Created by Alexluan on 2019/9/22.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveCocoa

class GuideController: YSBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "引导页"
        createUI()
        createActions()
    }

    private func createUI() {
        view.addSubview(guideButton)
        view.addSubview(guideButton1)

        guideButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(100)
        }
        guideButton1.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(300)
            make.leading.equalToSuperview().offset(100)
        }
    }

    private func createActions() {
        guideButton.reactive.controlEvents(.touchUpInside).observeValues { (button) in
            GuideManager.showGuide(views: [self.guideButton])
        }
        guideButton1.reactive.controlEvents(.touchUpInside).observeValues { (button) in
            let v = UIView()
            v.frame = CGRect(x: 110, y: 20, width: 300, height: 200)
            GuideManager.showGuide(views: [v])
        }
    }

    // MARK: - UI
    private let guideButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 100, width: 100, height: 200)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("guidebutton", for: .normal)
        button.backgroundColor = .yellow
        return button
    }()

    private let guideButton1: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 100, width: 100, height: 200)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("guidebutton", for: .normal)
        button.backgroundColor = .yellow
        return button
    }()

}
