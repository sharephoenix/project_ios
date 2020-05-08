//
//  ViewController.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/7/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - 被C要调用的函数

func swiftFunImplement(a:Int32) -> Void {
    print("收到一个c函数的Int值->\(a)");
}

class ViewController: UIViewController {

    private var datas: [YSMainViewModel] = [YSMainViewModel]()

    private let mainTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        /// 初始化数据
        createData()
        createUI()
        view.backgroundColor = .red
        title = "组件"
        mainTableView.backgroundColor = .yellow
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.backgroundColor = .red
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.alpha = 0.3
        /// 禁用 navigationContrller 边栏返回手势
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        test()
    }

    private func test() {
        let person = createBy("peter", 14);
        printPersonInfo(person);
        let cName = getPersonName(person);
        let name = String(cString: cName!);
        print("fetch name is：\(name)");
        printHellow()

        YSFile.sum(withNum: 8, withNum: 9)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.alpha = 1
    }

    private func createData() {
        let ysSwitch = YSMainViewModel(name: "YSSwitch")
        let ysButton = YSMainViewModel(name: "YSButton")
        let ysToast = YSMainViewModel(name: "YSToast")
        let ysQR = YSMainViewModel(name: "YSQR")
        let ysVideoRtmp = YSMainViewModel(name: "YSVideoRtmp")
        let ysVideoPlayer = YSMainViewModel(name: "YSVideoPlayer")
        let ysGuide = YSMainViewModel(name: "YSGuideController")
        let ysFirstResponder = YSMainViewModel(name: "YSFistResponder")
        let ysSkin = YSMainViewModel(name: "showSkinController")
        let ysRunloop = YSMainViewModel(name: "RunloopController")
        datas.append(ysSwitch)
        datas.append(ysButton)
        datas.append(ysToast)
        datas.append(ysQR)
        datas.append(ysVideoRtmp)
        datas.append(ysVideoPlayer)
        datas.append(ysGuide)
        datas.append(ysFirstResponder)
        datas.append(ysSkin)
        datas.append(ysRunloop)
    }

    private func createUI() {
        view.addSubview(mainTableView)
        mainTableView.register(UINib.init(nibName: "YSMainCell", bundle: nil), forCellReuseIdentifier: "YSMainCell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.layer.borderColor = UIColor.blue.cgColor
        mainTableView.layer.borderWidth = 2
        mainTableView.layer.cornerRadius = 4
        mainTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        mainTableView.layer.borderColor = UIColor.red.cgColor
        mainTableView.layer.borderWidth = 1
    }

    private func showAlert() {
        let alert = UIAlertController.init(title: "TITLE", message: "MESSAGE", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction.init(title: "cancel", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private let window: UIWindow = {
        let window = UIWindow()
        window.frame = UIScreen.main.bounds
        window.backgroundColor = .yellow
        return window
    }()
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YSMainCell") as! YSMainCell
        let viewModel = datas[indexPath.row]
        cell.setModel(viewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = datas[indexPath.row]
        if viewModel.name == "YSSwitch" {
            YSRouter.showYSSwitch(navigationController)
        }
        if viewModel.name == "YSButton" {
            YSRouter.showYSButton(navigationController)
        }
        if viewModel.name == "YSToast" {
            YSRouter.showYSToast(navigationController)
        }
        if viewModel.name == "YSQR" {
            YSRouter.showYSQR(navigationController)
        }
        if viewModel.name == "YSVideoRtmp" {
            YSRouter.showYSVideoRtmp(navigationController)
        }
        if viewModel.name == "YSVideoPlayer" {
            YSRouter.showYSVideoPlayer(navigationController)
        }
        if viewModel.name == "YSGuideController" {
            YSRouter.showYSGuideController(navigationController)
        }
        if viewModel.name == "YSFistResponder" {
            YSRouter.showFirstResponder(navigationController)
        }
        if viewModel.name == "showSkinController" {
            YSRouter.showSkinController(navigationController)
        }
        if viewModel.name == "RunloopController" {
            YSRouter.showRunloopController(navigationController)
        }

        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
}

