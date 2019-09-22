//
//  GuideManager.swift
//  blackboard
//
//  Created by 研发部-001 on 2019/9/19.
//  Copyright © 2019 xkb. All rights reserved.
//

import UIKit

class GuideManager: NSObject {

    enum GuideCategory: String {
        case testGuide = "测试引导"
    }

    static func showGuide(views: [UIView], type: GuideCategory = .testGuide) {
        let guideManager = GuideManager()
        guideManager.guidePunchSend(views: views)
        UserDefaults.standard.set(true, forKey: type.rawValue)
    }

    // MARK: - 测试打卡管理器
    private func guidePunchSend(views: [UIView]) {
        if views.count < 1 {
            return
        }
        guard let parentView = UIApplication.shared.windows.last else { return }
        let maskView = XHBGuideMaskView(nums: 1)

        let guide0 = UIView(frame: CGRect(x: 0, y: 0, width: 33, height: 33))
        guide0.backgroundColor = .red

        let father0 = views[0].superview

        let transFrame0 = father0?.convert(views[0].frame, to: parentView) ?? .zero

        let guideFrame0 = CGRect(x: transFrame0.midX - guide0.frame.width / 2, y: transFrame0.maxY, width: guide0.frame.width, height: guide0.frame.height)

        maskView.addViews(views: [guide0],
                          viewFrame: [guideFrame0],
                          transparentViews: [transFrame0])
        maskView.showMaskViewInView(view: parentView)
    }
}
