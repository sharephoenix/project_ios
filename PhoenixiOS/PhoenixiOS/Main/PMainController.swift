//
//  PMainController.swift
//  PhoenixiOS
//
//  Created by phoenix on 2020/4/25.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class PMainController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let v0 = UIViewController()
        let nav0 = UINavigationController()
        nav0.tabBarItem = UITabBarItem(title: "我的", image: UIImage(), selectedImage: UIImage())
        setViewControllers([nav0], animated: true)
    }
}
