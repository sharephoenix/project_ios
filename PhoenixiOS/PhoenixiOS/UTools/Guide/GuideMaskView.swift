//
//  XHBGuideMaskView.swift
//  blackboard
//
//  Created by 研发部-001 on 2019/9/19.
//  Copyright © 2019 xkb. All rights reserved.
//

import UIKit

class XHBGuideMaskView: UIControl {
    private var showViews: [UIView] = []    // 引导提示
    private var viewFrames: [CGRect] = []   // 引导提示定位
    private var transparentPaths: [UIBezierPath] = [] // 引导透明区域，为 nil 时，铺满显示区域
    private var showOrder: [Int]? // 显示个数，默认一次只显示一个引导页
    private var clickIndex = -1 // 点击次数
    private var hasShowGuide = 0 // 已经展示引导页数量
    private var guideNumber = 0 // 引导总数量

    private var overLayerPath: UIBezierPath?
    private var fillLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = UIScreen.main.bounds
        return layer
    }()

    init(nums: Int) {
        super.init(frame: UIScreen.main.bounds)
        guideNumber = nums
        createUI()
        createActions()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createUI() {
        backgroundColor = .clear
        let maskColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)

        self.layer.addSublayer(fillLayer)
        refreshMask()
        fillLayer.path = self.overLayerPath?.cgPath
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.fillColor = maskColor.cgColor
    }

    private func createActions() {
        addTarget(self, action: #selector(clickNext), for: UIControl.Event.touchUpInside)
    }

    // 创建透明层区域
    private func createOverLayerPath() -> UIBezierPath {
        let overlayPath = UIBezierPath(rect: self.bounds)
        overlayPath.usesEvenOddFillRule = true
        return overlayPath
    }

    /// 添加蒙版上的指定View
    ///
    /// - Parameters:
    ///   - views: 提示 view
    ///   - viewFrame: 提示 view 定位
    ///   - transparentViews: 透明区域 CGRect
    @objc func addViews(views: [UIView], viewFrame: [CGRect], transparentViews: [CGRect], orders: [Int]? = nil) {
        showOrder = orders
        showViews = views
        viewFrames = viewFrame
        for item in transparentViews {
            let frame = item
            let radius = 8 //item.layer.cornerRadius
            let transparentPath = UIBezierPath.init(roundedRect: frame, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: radius, height: radius))
            transparentPaths.append(transparentPath)
        }
    }

    /// 绘制透明区域
    private func addTransparentPath(transparentPath: UIBezierPath) {
        overLayerPath?.append(transparentPath)
        fillLayer.path = overLayerPath?.cgPath
    }

    /// 点击显示下一张引导页，如果没有退出显示
    @objc private func clickNext() {
        if hasShowGuide >= guideNumber {
            dismissMaskView()
            return
        }
        clickIndex += 1
        /// 单张引导逻辑
        func showGuides(_ nums: Int = 1) {
            if clickIndex < showViews.count {
                refreshMask()

                subviews.forEach { (view) in
                    view.removeFromSuperview()
                }
                for index in hasShowGuide..<hasShowGuide + nums where index < transparentPaths.count {
                    addTransparentPath(transparentPath: transparentPaths[index])
                }
                addGuideView(nums)
            } else {
                dismissMaskView()
            }
            hasShowGuide += nums
        }

        if let showOrder = showOrder,
            clickIndex < showOrder.count, showOrder[clickIndex] + hasShowGuide <= guideNumber {
            showGuides(showOrder[clickIndex])
            return
        }
        showGuides()
    }

    private func refreshMask() {
        overLayerPath = createOverLayerPath()
    }

    /// 添加一张引导图
    private func addGuideView(_ nums: Int = 1) {
        for index in hasShowGuide..<nums + hasShowGuide {
            let v = showViews[index]
            let frame = viewFrames[index]
            v.frame = frame
            addSubview(showViews[index])
        }
    }

    func showMaskViewInView(view: UIView?) {
        self.alpha = 0
        if let view = view {
            view.addSubview(self)
        } else {
            UIApplication.shared.keyWindow?.addSubview(self)
        }

        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
        clickNext()
    }

    /// 销毁蒙层，默认点击区域后自动销毁
    func dismissMaskView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }

    deinit {
        showViews.removeAll()
    }
}
