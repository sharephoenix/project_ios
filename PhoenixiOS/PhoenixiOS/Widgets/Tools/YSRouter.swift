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
    /// 调转到 Button Case 中
    static func showYSButton(_ navigationController: UINavigationController?) {
        let vc = YSButtonController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 调转到 Toast Case 中
    static func showYSToast(_ navigationController: UINavigationController?) {
        let vc = YSToastController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 调用二维码扫描
    static func showYSQR(_ navigationController: UINavigationController?) {
        let vc = YSQRController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 调用视频录制
    static func showYSVideoRtmp(_ navigationController: UINavigationController?) {
        let vc = YSVideoRtmpController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 视频播放器
    static func showYSVideoPlayer(_ navigationController: UINavigationController?) {
        let vc = YSVideoPlayerController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 引导页
    static func showYSGuideController(_ navigationController: UINavigationController?) {
        let vc = GuideController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 获取第一响应者
    static func showFirstResponder(_ navigationController: UINavigationController?) {
        let vc = GetResponderController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 换肤
    static func showSkinController(_ navigationController: UINavigationController?) {
        let vc = YSSkinController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
