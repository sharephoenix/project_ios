//
//  HtmlTools.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/22.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import SwiftSoup

class HtmlTools: NSObject {

    /// 传入 html 文本和节点名称， 返回 节点数据的 value 值
    ///
    /// - Parameters:
    ///   - html: html 文本
    ///   - node: div title 等 web 节点
    /// - Returns: 返回所有节点内部的数据
    @objc static func getNodes(html: String, node: String) -> [String]? {
        do {
            let document = try SwiftSoup.parse(html)
            var resultItems: [String] = [String]()
            let elements: Elements = try document.select(node)

            for element in elements {
                let text = try element.text()
                resultItems.append(text)
            }

            return resultItems
        } catch {
            return nil
        }
    }
}
