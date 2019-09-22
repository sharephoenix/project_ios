//
//  GetResponderController.swift
//  PhoenixiOS
//
//  Created by Alexluan on 2019/9/22.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift

class GetResponderController: YSBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "获取第一响应者"
        createUI()
        createActions()
    }

    private func createUI() {
        view.addSubview(textField)
        view.addSubview(firstLabel)
        view.addSubview(responderBtn)

        textField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }

        firstLabel.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom).offset(12)
            make.left.right.equalTo(textField)
            make.height.equalTo(44)
        }

        responderBtn.snp.makeConstraints { (make) in
            make.top.equalTo(firstLabel.snp.bottom).offset(12)
            make.left.right.equalTo(textField)
            make.height.equalTo(44)
        }
    }

    private func createActions() {
        responderBtn.reactive.controlEvents(.touchUpInside).observeValues { (button) in
            let vv = SystemTool.getFirstResponder(baseView: self.view)
            self.firstLabel.text = "\(vv)"
        }
    }

    // MARK: - System
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - UI
    private let textField: UITextField = {
        let textfield = UITextField()
        textfield.text = "我的地址\(textfield)"
        return textfield
    }()

    private let responderBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("获取第一响应者", for: .normal)
        return button
    }()

    private let firstLabel: UILabel = {
        let label = UILabel()
        return label
    }()
}
