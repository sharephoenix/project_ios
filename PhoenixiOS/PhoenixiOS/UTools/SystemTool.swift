//
//  SystemTool.swift
//  PhoenixiOS
//
//  Created by Alexluan on 2019/9/22.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class SystemTool: NSObject {

    /// 获取当前view 中的第一响应者
    ///
    /// - Parameter baseView: 给一个基本View
    /// - Returns: 返回 第一响应者的 View
    static func getFirstResponder(baseView: UIView) -> UIView? {
        if baseView.isFirstResponder {
            return baseView
        }
        if baseView.subviews.count > 0 {
            for nextView in baseView.subviews {
                if nextView.isFirstResponder {
                    return nextView
                }
                if let first = getFirstResponder(baseView: nextView) {
                    return first
                }
            }
        }
        return nil
    }
}
