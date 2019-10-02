//
//  LYSDownloadHelper.swift
//  EnglistWords
//
//  Created by Alexluan on 2019/10/2.
//  Copyright © 2019 Alexluan. All rights reserved.
//

import UIKit

typealias DonwLoadBlock = ((_ process: Float, _ location: URL? ) -> Void)

class LYSDownloadHelper: NSObject, URLSessionDownloadDelegate {
    static let  instance = LYSDownloadHelper()
    private let config: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.isDiscretionary = true
        return configuration
    }()
    private let operationQueue = OperationQueue()

    private var downloadModel: [URL: DownLoadModel] = [URL: DownLoadModel]()
    private var callbacks: [URL: NSMutableArray] = [URL: NSMutableArray]()

    private var session: URLSession!

    func downloadFile(url: URL, relativePath: String, newName: String, callBack: @escaping DonwLoadBlock) -> URLSessionDownloadTask {
        let model = DownLoadModel(url: url, relativePath: relativePath, newFileName: newName)
        registCallBack(url: url, callBack: callBack)
        downloadModel[url] = model

        if session == nil {
            session = URLSession(configuration: config, delegate: self, delegateQueue: operationQueue)
        }
        let task = session.downloadTask(with: URLRequest(url: url))
        task.resume()

        return task
    }

    func registCallBack(url: URL, callBack: @escaping DonwLoadBlock) {
        if let cBack = callbacks[url] {
            cBack.add(callBack)
        } else {
            callbacks[url] = NSMutableArray(object: callBack)
        }
        print("--")
    }

    // 下载代理方法，下载结束
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let url = downloadTask.originalRequest?.url,
            let cback = callbacks[url] {
            for callback in cback {
                if let callback = callback as? DonwLoadBlock {
                    callback(1, location)
                }
            }

            if let model = downloadModel[url] {
                LYSFileManager.instance.convertPath(path: location, realtivePath: model.relativePath, newName: model.newFileName)
            }
        }
    }
    // 下载代理方法，监听下载进度
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let process = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        if let url = downloadTask.originalRequest?.url,
            let cBack = callbacks[url] {
            for callback in cBack {
                if let callback = callback as? DonwLoadBlock {
                    callback(process, nil)
                }
            }
        }
    }
    // 下载代理方法，下载偏移
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("下载偏移")
        // 下载偏移，主要用于暂停续传
    }
    /*
     * 该方法下载成功和失败都会回调，只是失败的是error是有值的，
     * 在下载失败时，error的userinfo属性可以通过NSURLSessionDownloadTaskResumeData
     * 这个key来取到resumeData(和上面的resumeData是一样的)，再通过resumeData恢复下载
     */
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    }
}

class DownLoadModel {
    let url: URL
    let relativePath: String
    let newFileName: String

    init(url: URL, relativePath: String, newFileName: String) {
        self.url = url
        self.relativePath = relativePath
        self.newFileName = newFileName
    }
}
