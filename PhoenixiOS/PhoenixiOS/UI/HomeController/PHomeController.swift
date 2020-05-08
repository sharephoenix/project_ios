//
//  PHomeController.swift
//  PhoenixiOS
//
//  Created by phoenix on 2020/4/25.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class PHomeController: PBaseController {

    private let initilizeParams: [String: String]

    init(params: [String: String]) {
        initilizeParams = params
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
