//
//  VoiceDetailController.swift
//  EnglistWords
//
//  Created by Alexluan on 2019/9/29.
//  Copyright © 2019 Alexluan. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class VoiceDetailController: UIViewController {

    private let url: String
    private let navTitle: String

    private let webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.backgroundColor = .gray
        return webView
    }()

    init(url: String, title: String) {
        self.url = url
        navTitle = title
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = navTitle
        createUI()
        createData()
    }

    private func createUI() {
        view.addSubview(webView)

        webView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(view.safeAreaInsets.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-view.safeAreaInsets.bottom)
        }
    }

    private func createData() {
        if let requestUrl = URL.init(string: url) {
            webView.load(URLRequest(url: requestUrl))
        }
    }
}
