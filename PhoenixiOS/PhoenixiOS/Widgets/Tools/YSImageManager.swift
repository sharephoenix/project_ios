//
//  YSImageManager.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/13.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class YSImageManager: NSObject {
    /// 获取图片
    static func imageName(_ name: String) -> UIImage? {
        return UIImage(named: name)
    }
}
