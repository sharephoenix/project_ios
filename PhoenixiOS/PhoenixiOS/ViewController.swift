//
//  ViewController.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/7/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import SnapKit

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
    }

    private func createData() {
        let ysSwitch = YSMainViewModel(name: "YSSwitch")
        datas.append(ysSwitch)
    }

    private func createUI() {
        view.addSubview(mainTableView)
        mainTableView.register(UINib.init(nibName: "YSMainCell", bundle: nil), forCellReuseIdentifier: "YSMainCell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        mainTableView.layer.borderColor = UIColor.red.cgColor
        mainTableView.layer.borderWidth = 1
    }
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
            navigationController?.pushViewController(YSSwitchController(), animated: true)
        }
    }
}

