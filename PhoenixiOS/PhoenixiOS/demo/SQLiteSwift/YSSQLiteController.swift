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
import RxSwift
import RxCocoa

class YSSQLiteController: UIViewController {
    //    let id = Expression<Int64>("id")
    //    let name = Expression<String?>("name")
    //    let email = Expression<String>("email")
    //    let age = Expression<Int64>("age")
    private let disposeBag = DisposeBag()
    private var id: Int64 = 0
    private var name: String?
    private var email: String = ""
    private var age: Int64 = 0

    private var error: String? {
        willSet {
            errorField.text = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createUI()
        createActions()
        createSignal()
    }

    private func createUI() {
        view.addSubview(idField)
        view.addSubview(nameField)
        view.addSubview(emailField)
        view.addSubview(ageField)
        view.addSubview(errorField)

        idField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(56)
            make.leading.trailing.equalToSuperview()
        }
        nameField.snp.makeConstraints { make in
            make.top.equalTo(idField.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview()
        }
        emailField.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview()
        }
        ageField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview()
        }
        errorField.snp.makeConstraints { make in
            make.top.equalTo(ageField.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(66)
        }

        view.addSubview(createBtn)
        view.addSubview(selectBtn)
        view.addSubview(updateBtn)
        view.addSubview(insertBtn)
        view.addSubview(deleteBtn)
        view.addSubview(dropBtn)

        weak var topView: UIView?
        createBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(44)
        }
        topView = createBtn
        insertBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if let top = topView {
                make.top.equalTo(top.snp.bottom).offset(8)
            } else {
                make.top.equalToSuperview().offset(100)
            }
            make.height.equalTo(44)
        }
        topView = insertBtn
        selectBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if let top = topView {
                make.top.equalTo(top.snp.bottom).offset(8)
            } else {
                make.top.equalToSuperview().offset(100)
            }
            make.height.equalTo(44)
        }
        topView = selectBtn
        updateBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if let top = topView {
                make.top.equalTo(top.snp.bottom).offset(8)
            } else {
                make.top.equalToSuperview().offset(100)
            }
            make.height.equalTo(44)
        }
        topView = updateBtn
        deleteBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if let top = topView {
                make.top.equalTo(top.snp.bottom).offset(8)
            } else {
                make.top.equalToSuperview().offset(100)
            }
            make.height.equalTo(44)
        }
        topView = deleteBtn
        dropBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if let top = topView {
                make.top.equalTo(top.snp.bottom).offset(8)
            } else {
                make.top.equalToSuperview().offset(100)
            }
            make.height.equalTo(44)
        }

    }

    private func createActions() {
        createBtn.addTarget(self, action: #selector(createBtnAction), for: .touchUpInside)
        insertBtn.addTarget(self, action: #selector(insertBtnAction), for: .touchUpInside)
        selectBtn.addTarget(self, action: #selector(selectBtnAction), for: .touchUpInside)
        updateBtn.addTarget(self, action: #selector(updateBtnAction), for: .touchUpInside)
        deleteBtn.addTarget(self, action: #selector(deleteBtnAction), for: .touchUpInside)
        dropBtn.addTarget(self, action: #selector(dropBtnAction), for: .touchUpInside)
    }

    private func createSignal() {
        idField.rx.text.bind { value in
            self.id = Int64(value ?? "0") ?? 0
        }.disposed(by: self.disposeBag)

        nameField.rx.text.bind { value in
            self.name = value ?? ""
        }.disposed(by: self.disposeBag)

        emailField.rx.text.bind { value in
            self.email = value ?? ""
        }.disposed(by: self.disposeBag)

        ageField.rx.text.bind { value in
            self.age = Int64(value ?? "0") ?? 0
        }.disposed(by: self.disposeBag)
    }

    // MARK: - Handler+UIProcess
    /// 只可以调用 Logic 中的方法整理数据，并对 UI 逻辑进行处理
    @objc private func createBtnAction() {
        self.error = ""
        do {
            try createTableLogic()
            self.error = "success"
        } catch let error {
            self.error = error.localizedDescription
        }
    }

    @objc private func insertBtnAction() {
        self.error = ""
        do {
            let count = try insertLogic()
            self.error = "success: \(count)"
        } catch let error {
            self.error = error.localizedDescription
        }
    }

    @objc private func selectBtnAction() {
        self.error = ""
        do {
            let datas = try selectLogic()
            self.error = "\(datas)"
        } catch let error {
            self.error = error.localizedDescription
        }
    }

    @objc private func updateBtnAction() {
        self.error = ""
        do {
            let count = try updateLogic()
            self.error = "success:\(count)"
        } catch let error {
            self.error = error.localizedDescription
        }
    }

    @objc private func deleteBtnAction() {
        self.error = ""
        do {
            let count = try deleteLogic()
            self.error = "success:\(count)"
        } catch let error {
            self.error = error.localizedDescription
        }
    }

    @objc private func dropBtnAction() {
        self.error = ""
        do {
            let count = try dropLogic()
            self.error = "success:\(count)"
        } catch let error {
            self.error = error.localizedDescription
        }
    }

    // MARK: - Logic
    /// Logic  中调用各种 Model 中的数据组合数据
    @discardableResult
    private func createTableLogic() throws -> Int {
        try YSSQLiteManager.instance.createTable()
        return 0
    }

    @discardableResult
    private func insertLogic() throws -> Int64 {
        return try YSSQLiteManager.instance.insertData()
    }

    @discardableResult
    private func selectLogic() throws -> [String] {
        return try YSSQLiteManager.instance.selectData()
    }

    @discardableResult
    private func updateLogic() throws -> Int {
        return try YSSQLiteManager.instance.updateData()
    }

    @discardableResult
    private func deleteLogic() throws -> Int {
        return try YSSQLiteManager.instance.deleteAllData()
    }

    @discardableResult
    private func dropLogic() throws -> Int {
        return try YSSQLiteManager.instance.dropUserTable()
    }

    // MARK: - Model
    /// 最小数据逻辑颗粒，并返回想要的数据

    // MARK: - Delegate

    // MARK: - Tool_Methods
    /// 本类中所使用的小工具方法

    // MARK: - UI
    private let createBtn: UIButton = {
        let button = UIButton()
        button.setTitle("createBtn", for: .normal)
        button.backgroundColor = .lightGray
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.layer.cornerRadius = 3
        return button
    }()

    private let insertBtn: UIButton = {
        let button = UIButton()
        button.setTitle("insertBtn", for: .normal)
        button.backgroundColor = .lightGray
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.layer.cornerRadius = 3
        return button
    }()

    private let selectBtn: UIButton = {
        let button = UIButton()
        button.setTitle("selectBtn", for: .normal)
        button.backgroundColor = .lightGray
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.layer.cornerRadius = 3
        return button
    }()

    private let updateBtn: UIButton = {
        let button = UIButton()
        button.setTitle("updateBtn", for: .normal)
        button.backgroundColor = .lightGray
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.layer.cornerRadius = 3
        return button
    }()

    private let deleteBtn: UIButton = {
        let button = UIButton()
        button.setTitle("deleteBtn", for: .normal)
        button.backgroundColor = .lightGray
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.layer.cornerRadius = 3
        return button
    }()

    private let dropBtn: UIButton = {
        let button = UIButton()
        button.setTitle("dropBtn", for: .normal)
        button.backgroundColor = .lightGray
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.layer.cornerRadius = 3
        return button
    }()

    private let idField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "idField"
        return textField
    }()
    private let nameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "nameField"
        return textField
    }()
    private let emailField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "emailField"
        return textField
    }()
    private let ageField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "ageField"
        return textField
    }()
    private let errorField: UITextView = {
        let textField = UITextView()
        textField.backgroundColor = .lightGray
        return textField
    }()
}
