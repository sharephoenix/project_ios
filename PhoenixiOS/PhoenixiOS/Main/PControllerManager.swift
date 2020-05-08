//
//  PControllerManager.swift
//  PhoenixiOS
//
//  Created by phoenix on 2020/4/25.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

extension PControllerManager {
    func presentController(_ controller: UIViewController) {

    }

    func pushController(_ controller: UIViewController) {

    }
}

class PControllerManager: NSObject {
    static let instance = PControllerManager()

//    private init() {
//    }
//    func createController(_ type: PControllerId) -> UIViewController {
//        switch type {
//        }
//    }
}

enum PControllerId: String {
    case mine   //我的主页
    case home   //我的首页
}
