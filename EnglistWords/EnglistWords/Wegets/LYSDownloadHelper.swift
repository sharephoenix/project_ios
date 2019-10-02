//
//  LYSDownloadHelper.swift
//  EnglistWords
//
//  Created by Alexluan on 2019/10/2.
//  Copyright © 2019 Alexluan. All rights reserved.
//

import UIKit

class LYSDownloadHelper: NSObject, URLSessionDownloadDelegate {
    static let  instance = LYSDownloadHelper()
    private let config: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.isDiscretionary = true
        return configuration
    }()
    private let operationQueue = OperationQueue()
    typealias DonwLoadBlock = ((_ process: Float, _ location: URL? ) -> Void)

    private var downloadCallback: [URL: DonwLoadBlock] = [:]
    private var session: URLSession!

    func downloadFile(url: URL, callBack: @escaping DonwLoadBlock) -> URLSessionDownloadTask {
        if session == nil {
            session = URLSession(configuration: config, delegate: self, delegateQueue: operationQueue)
        }
        let task = session.downloadTask(with: URLRequest(url: url))
        task.resume()
        downloadCallback[url] = callBack
        return task
    }

    // 下载代理方法，下载结束
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let url = downloadTask.originalRequest?.url,
            let callback = downloadCallback[url] {
            callback(1,location)
        }
    }
    // 下载代理方法，监听下载进度
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let process = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        if let url = downloadTask.originalRequest?.url,
            let callback = downloadCallback[url] {
            callback(process, nil)
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

    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    print("finish")
    }
}
