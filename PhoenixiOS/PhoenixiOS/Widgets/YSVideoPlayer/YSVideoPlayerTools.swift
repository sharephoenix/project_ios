//
//  YSVideoPlayerTools.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/22.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class YSVideoPlayerTools: NSObject {
/// 获取去视频中的图片
    static func getVideoImageWithTime(time: Float64, path: URL) -> UIImage? {
        let asset = AVURLAsset(url: path)
        let assetGen = AVAssetImageGenerator(asset: asset)
        assetGen.appliesPreferredTrackTransform = true
        let time = CMTimeMake(value: Int64(time), timescale: 1)
        do {
            guard let image = try? assetGen.copyCGImage(at: time, actualTime: nil) else { return nil }
            let videoImage = UIImage(cgImage: image)
            return videoImage
        }
    }
}
