//
//  PBaseController.swift
//  PhoenixiOS
//
//  Created by phoenix on 2020/4/25.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class PBaseController: UIViewController {

//    weak var callbackDelegate: CallbackDelegte?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

protocol CallbackDelegte {
    func actionBack(actionName: String, params: [String: String])
}
