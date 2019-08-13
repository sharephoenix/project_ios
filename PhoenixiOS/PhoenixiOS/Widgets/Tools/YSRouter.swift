//
//  YSRouter.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/13.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class YSRouter: NSObject {
    /// present 堆栈
    var stacks: [UIViewController] = [UIViewController]()

    /// 调转到 Switch Case 中
    static func showYSSwitch(_ navigationController: UINavigationController?) {
        let vc = YSSwitchController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
