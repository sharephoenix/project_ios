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

    let mainTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        createUI()
    }

    private func createUI() {
        view.addSubview(mainTableView)

        mainTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        mainTableView.layer.borderColor = UIColor.red.cgColor
        mainTableView.layer.borderWidth = 1
    }
}

