//
//  YSSQLiteController.swift
//  PhoenixiOS
//
//  Created by phoenix on 2020/5/8.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SnapKit
import SQLite

class YSSQLiteController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createUI()
        createActions()
    }

    private func createUI() {
        view.addSubview(createBtn)
        view.addSubview(selectBtn)

        createBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        selectBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(createBtn.snp.bottom).offset(8)
        }
    }

    private func createActions() {
        createBtn.addTarget(self, action: #selector(createBtnAction), for: .touchUpInside)
        selectBtn.addTarget(self, action: #selector(selectBtnAction), for: .touchUpInside)
    }

    @objc private func createBtnAction() {
        do {
            try YSSQLiteManager.instance.createTable()
        } catch {
            print("=createBtn: error=")
        }
    }

    @objc private func selectBtnAction() {
        do {
            var table: [String] = []
            try YSSQLiteManager.instance.selectData(data: &table)
            print("\(table)")
        } catch {
            print("=selectBtnAction: error=")
        }
    }

    private let createBtn: UIButton = {
        let button = UIButton()
        button.setTitle("createBtn", for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()

    private let selectBtn: UIButton = {
        let button = UIButton()
        button.setTitle("selectBtn", for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()

}
