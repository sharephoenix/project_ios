//
//  YSToast.swift
//  blackboard
//
//  Created by phoenix on 2019/7/25.
//  Copyright © 2019 xkb. All rights reserved.
//

import UIKit

class YSToast: NSObject {

    public enum Direction: Int {
        case TC = 0 // T:TOP,C:CENTER,L:LEFT,R:RIGHT,B:BOTTOM
        case TL = 1
        case TR = 2
        case RC = 3
        case LC = 4
        case CC = 5
        case BC = 6
        case BL = 7
        case BR = 8
    }

    @objc static let instance = YSToast()

    private override init() {}

    @objc var duration = 1.5    /// toast 停留时间

    public var direction: Direction = .TC

    private var imageStack: [UIView] = [UIView]()

    var offsetX: CGFloat = 0
    var offsetY: CGFloat = 0//79.0 + UIApplication.shared.statusBarFrame.height

    private var isRunning = false

    @objc func showSyncView(_ view: UIView?) {
        guard let view = view else {
            return
        }
        imageStack.append(view)
        toAutoRun()
    }

    @objc func showToast(_ content: NSString, sync: Bool = true) {
        if !Thread.current.isMainThread {
            perform(#selector(showToast(_:sync:)), on: Thread.main, with: content, waitUntilDone: false)
            return
        }
        let label = UILabel()
        label.text = content as String
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 3
        label.numberOfLines = 0
        label.textColor = .white
        if #available(iOS 10.0, *) {
            label.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.3)
        } else {
            // Fallback on earlier versions
        }
        label.layer.masksToBounds = true
        let maxSize = CGSize(width: 120, height: CGFloat.greatestFiniteMagnitude)
        let attrs: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: label.font!]
        let options: NSStringDrawingOptions = .usesLineFragmentOrigin

        let size = content.boundingRect(with: maxSize, options: options, attributes: attrs, context: nil).size
        label.frame = CGRect(x: 0, y: 0, width: 120, height: size.height + 22)
        duration = 2
        if sync {
            showSyncView(label)
        } else {
            showAsyncView(label)
        }
    }

    /// 无堆栈 toast
    ///
    /// - Parameter view: 需要弹出的 view
    @objc func showAsyncView(_ view: UIView) {
        if !Thread.current.isMainThread {
            perform(#selector(showAsyncView(_:)), on: Thread.main, with: view, waitUntilDone: false)
            return
        }
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        window.addSubview(view)
        resetUI(view, parentView: window)
        animation(view, finish: { _ in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.duration, execute: {
                view.removeFromSuperview()
            })
        })
    }

    /// 清理所有 toast UI
    @objc func clearToast() {
        if imageStack.count <= 1 {
            return
        }
        for i in (1..<imageStack.count).reversed() {
            imageStack[i].removeFromSuperview()
            imageStack.remove(at: i)
        }
    }

    /// 动画自动运行 有队列的运行
    @objc private func toAutoRun() {
        if !Thread.current.isMainThread {
            perform(#selector(toAutoRun), on: Thread.main, with: nil, waitUntilDone: false)
            return
        }
        guard let window = UIApplication.shared.windows.first,
            !isRunning,
            let view = imageStack.first else {
            return
        }

        isRunning = true
        window.addSubview(view)
        resetUI(view, parentView: window)
        animation(view, finish: { _ in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.duration, execute: {
                if self.imageStack.count > 0 {
                    self.imageStack.removeAll(where: { (current) -> Bool in
                        return view === current
                    })
                    view.removeFromSuperview()
                }

                self.isRunning = false
                // 自动开启动画
                self.toAutoRun()
            })
        })
    }

    /// 重新给需要 toast 的 View 布局
    ///
    /// - Parameter view: 需要重置布局的 view
    private func resetUI(_ view: UIView, parentView: UIView) {
        switch direction {
        case .TC:
            resetUITC(view, parentView: parentView)
        case .TL:
            resetUITL(view, parentView: parentView)
        case .TR:
            resetUITR(view, parentView: parentView)
        case .RC:
            resetUIRC(view, parentView: parentView)
        case .LC:
            resetUILC(view, parentView: parentView)
        case .CC:
            resetUICC(view, parentView: parentView)
        case .BC:
            resetUIBC(view, parentView: parentView)
        case .BL:
            resetUIBL(view, parentView: parentView)
        case .BR:
            resetUIBR(view, parentView: parentView)
        }
    }

    private func resetUITC(_ view: UIView, parentView: UIView) {
        view.frame = CGRect(x: parentView.bounds.width / 2.0 - view.frame.width / 2.0 + offsetX, y: offsetY, width: view.frame.width, height: view.frame.height)
    }

    private func resetUICC(_ view: UIView, parentView: UIView) {
        view.frame = CGRect(x: parentView.bounds.width / 2.0 - view.frame.width / 2.0 + offsetX, y: offsetY, width: view.frame.width, height: view.frame.height)
        view.center = CGPoint(x: parentView.bounds.width / 2, y: parentView.bounds.height / 2)
    }

    private func resetUITL(_ view: UIView, parentView: UIView) {
        view.frame = CGRect(x: 0 + offsetX, y: offsetY + 0, width: view.frame.width, height: view.frame.height)
    }

    private func resetUITR(_ view: UIView, parentView: UIView) {
        view.frame = CGRect(x: parentView.bounds.width - view.frame.width + offsetX, y: offsetY + 0, width: view.frame.width, height: view.frame.height)
    }

    private func resetUILC(_ view: UIView, parentView: UIView) {
        view.frame = CGRect(x: 0 + offsetX, y: offsetY + 0, width: view.frame.width, height: view.frame.height)
        view.center = CGPoint(x: view.bounds.width / 2 + offsetX,
                              y: parentView.bounds.height / 2 + offsetY)
    }

    private func resetUIRC(_ view: UIView, parentView: UIView) {
        view.frame = CGRect(x: 0 + offsetX, y: offsetY + 0, width: view.frame.width, height: view.frame.height)
        view.center = CGPoint(x: parentView.bounds.width - view.bounds.width / 2 + offsetX,
                              y: parentView.bounds.height / 2 + offsetY)
    }

    private func resetUIBC(_ view: UIView, parentView: UIView) {
        view.frame = CGRect(x: 0 + offsetX, y: offsetY + 0, width: view.frame.width, height: view.frame.height)
        view.center = CGPoint(x: parentView.bounds.width / 2 + offsetX,
                              y: parentView.bounds.height - view.bounds.height / 2 + offsetY)
    }

    private func resetUIBL(_ view: UIView, parentView: UIView) {
        view.frame = CGRect(x: 0 + offsetX, y: offsetY + 0, width: view.frame.width, height: view.frame.height)
        view.center = CGPoint(x: view.bounds.width / 2 + offsetX,
                              y: parentView.bounds.height - view.bounds.height / 2 + offsetY)
    }

    private func resetUIBR(_ view: UIView, parentView: UIView) {
        view.frame = CGRect(x: 0 + offsetX, y: offsetY + 0, width: view.frame.width, height: view.frame.height)
        view.center = CGPoint(x: parentView.bounds.width - view.bounds.width / 2 + offsetX,
                              y: parentView.bounds.height - view.bounds.height / 2 + offsetY)
    }

    /// 动画效果
    ///
    /// - Parameter imageView: 需要动画的view
    private func animation(_ view: UIView, finish: @escaping ((Bool) -> Void)) {
        view.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)

        UIView.animate(withDuration: 0.3, animations: {
            view.transform = CGAffineTransform.identity
        }) { flag in
            finish(flag)
        }
    }
}
