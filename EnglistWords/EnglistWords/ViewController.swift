//
//  ViewController.swift
//  EnglistWords
//
//  Created by Alexluan on 2019/9/29.
//  Copyright © 2019 Alexluan. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private var voiceList = [String]()
    private let tableView = UITableView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "雅思词汇"
        view.backgroundColor = .systemBackground
        createUI()
        createData()

        let link = "http://download.dogwood.com.cn/online/yschlx/WordList41.mp3"
        LYSDownloadHelper.instance.registCallBack(url: URL(string: link)!) { (process, uurl) in
            print(".........::\(process)")
        }
    }

    private func createUI() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(view.safeAreaInsets.top)
            make.bottom.equalTo(view.snp.bottomMargin)
        }
    }

    private func createData() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 45
        tableView.delegate = self
        tableView.dataSource = self

        for i in 0..<45 {
            let index = i + 1
            var indexStr = ""
            if index < 10 {
                indexStr = "0\(String(index))"
            } else {
                indexStr = String(index)
            }
            let link = "http://download.dogwood.com.cn/online/yschlx/WordList\(indexStr).mp3"
            voiceList.append(link)
        }
        tableView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voiceList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.selectionStyle = .none
        cell?.textLabel?.textColor = .label
        cell?.textLabel?.text = getIdentifier(index: indexPath.row)
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = voiceList[indexPath.row]
        navigationController?.pushViewController(VoiceDetailController(url: url, title: getIdentifier(index: indexPath.row)), animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    private func getIdentifier(index: Int) -> String{
        return "WordList\(index + 1)"
    }
}
