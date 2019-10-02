//
//  LYSFileManager.swift
//  EnglistWords
//
//  Created by Alexluan on 2019/10/2.
//  Copyright © 2019 Alexluan. All rights reserved.
//

import UIKit
import Foundation

class LYSFileManager: NSObject {
    static let instance = LYSFileManager()
    private let manager = FileManager.default

    func getDocument() -> String {
        let document = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)[0]
        return document
    }

    /// 判断文件是否存在
    func isExist(relativePath: String, fileName: String) -> Bool {
        let document = getDocument()
        return manager.fileExists(atPath: document + "/\(relativePath)/\(fileName)")
    }

    func getDocumentPath() -> String {
        return getDocument()
    }

    func convertPath(path: URL, realtivePath: String, newName: String) {
        let document = getDocument()
        let redirpath = document + realtivePath
        if !manager.fileExists(atPath: redirpath) {
            try? manager.createDirectory(at: URL(fileURLWithPath: redirpath), withIntermediateDirectories: true, attributes: nil)
        }
        try? manager.moveItem(at: path, to: URL.init(fileURLWithPath: redirpath + "/" + newName))
    }
}
