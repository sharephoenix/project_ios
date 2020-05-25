//
//  YSToast.swift
//  blackboard
//
//  Created by phoenix on 2019/7/25.
//  Copyright © 2019 xkb. All rights reserved.
//

import UIKit

public class YSToast: NSObject {

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

    @objc public static let instance = YSToast()

    private override init() {}

    @objc public var duration = 1.5    /// toast 停留时间

    private var imageStack: [UIView & YSToastProtocol] = [UIView & YSToastProtocol]()

    private var isRunning = false

    public func showSyncView(_ view: UIView & YSToastProtocol) {
        imageStack.append(view)
        toAutoRun()
    }

    @objc public func showToast(_ content: NSString, sync: Bool = true) {
        if !Thread.current.isMainThread {
            perform(#selector(showToast(_:sync:)), on: Thread.main, with: content, waitUntilDone: false)
            return
        }
        let label = YSToastLabel()
        label.text = content as String
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 3
        label.numberOfLines = 0
        label.textColor = .white
        label.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.7)
        label.layer.masksToBounds = true
        var maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let attrs: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: label.font!]
        let options: NSStringDrawingOptions = .usesLineFragmentOrigin
        let maxWidth: CGFloat = 200
        var size = content.boundingRect(with: maxSize,
                                        options: options,
                                        attributes: attrs,
                                        context: nil).size
        if size.width > maxWidth {
            maxSize = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
            size = content.boundingRect(with: maxSize,
                                    options: options,
                                    attributes: attrs,
                                    context: nil).size
        }
        label.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height + 22)
        label.size = size
        duration = 2
        if sync {
            showSyncView(label)
        } else {
            showAsyncView(label)
        }
    }

    /// 无堆栈 toast，注意：必须在主线中
    ///
    /// - Parameter view: 需要弹出的 view
    public func showAsyncView(_ view: UIView & YSToastProtocol) {
        guard let parentView = view.ys_parentView() else {
            return
        }
        parentView.addSubview(view)
        let model = YSToastModel(direction: view.ys_direction(),
                                 popSize: view.ys_size(),
                                 popOffset: view.ys_offset(),
                                 parentView: view.ys_parentView(),
                                 customView: view)
        resetUI(model)
        animation(view, finish: { _ in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.duration, execute: {
                view.removeFromSuperview()
            })
        })
    }

    /// 清理所有 toast UI
    @objc public func clearToast() {
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
        guard let view = imageStack.first,
            let parentView = view.ys_parentView(),
            !isRunning else {
            return
        }

        isRunning = true
        parentView.addSubview(view)
        let model = YSToastModel(direction: view.ys_direction(),
        popSize: view.ys_size(),
        popOffset: view.ys_offset(),
        parentView: view.ys_parentView(),
        customView: view)
        
        resetUI(model)
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
    private func resetUI(_ model: YSToastModel) {
        switch model.direction {
        case .TC:
            resetUITC(model)
        case .TL:
            resetUITL(model)
        case .TR:
            resetUITR(model)
        case .RC:
            resetUIRC(model)
        case .LC:
            resetUILC(model)
        case .CC:
            resetUICC(model)
        case .BC:
            resetUIBC(model)
        case .BL:
            resetUIBL(model)
        case .BR:
            resetUIBR(model)
        }
    }

    private func resetUITC(_ model: YSToastModel) {
        guard let view = model.ys_view(), let parentView = model.ys_parentView() else {
            return
        }
        let offsetX = model.ys_offset().horizontal
        let offsetY = model.ys_offset().vertical
        view.frame = CGRect(x: parentView.bounds.width / 2.0 - view.frame.width / 2.0 + offsetX,
                            y: offsetY,
                            width: model.ys_size().width,
                            height: model.ys_size().height)
    }

    private func resetUICC(_ model: YSToastModel) {
        guard let view = model.ys_view(), let parentView = model.ys_parentView() else {
            return
        }
        let offsetX = model.ys_offset().horizontal
        let offsetY = model.ys_offset().vertical
        view.frame = CGRect(x: parentView.bounds.width / 2.0 - view.frame.width / 2.0 + offsetX,
                            y: offsetY,
                            width: model.ys_size().width,
                            height: model.ys_size().height)
        view.center = CGPoint(x: parentView.bounds.width / 2, y: parentView.bounds.height / 2)
    }

    private func resetUITL(_ model: YSToastModel) {
        guard let view = model.ys_view() else {
            return
        }
        let offsetX = model.ys_offset().horizontal
        let offsetY = model.ys_offset().vertical
        view.frame = CGRect(x: 0 + offsetX,
                            y: offsetY + 0,
                            width: model.ys_size().width,
                            height: model.ys_size().height)
    }

    private func resetUITR(_ model: YSToastModel) {
        guard let view = model.ys_view(), let parentView = model.ys_parentView() else {
            return
        }
        let offsetX = model.ys_offset().horizontal
        let offsetY = model.ys_offset().vertical
        view.frame = CGRect(x: parentView.bounds.width - view.frame.width + offsetX,
                            y: offsetY + 0,
                            width: model.ys_size().width,
                            height: model.ys_size().height)
    }

    private func resetUILC(_ model: YSToastModel) {
        guard let view = model.ys_view(), let parentView = model.ys_parentView() else {
            return
        }
        let offsetX = model.ys_offset().horizontal
        let offsetY = model.ys_offset().vertical
        view.frame = CGRect(x: 0 + offsetX,
                            y: offsetY + 0,
                            width: model.ys_size().width,
                            height: model.ys_size().height)
        view.center = CGPoint(x: view.bounds.width / 2 + offsetX,
                              y: parentView.bounds.height / 2 + offsetY)
    }

    private func resetUIRC(_ model: YSToastModel) {
        guard let view = model.ys_view(), let parentView = model.ys_parentView() else {
            return
        }
        let offsetX = model.ys_offset().horizontal
        let offsetY = model.ys_offset().vertical
        view.frame = CGRect(x: 0 + offsetX,
                            y: offsetY + 0,
                            width: model.ys_size().width,
                            height: model.ys_size().height)
        view.center = CGPoint(x: parentView.bounds.width - view.bounds.width / 2 + offsetX,
                              y: parentView.bounds.height / 2 + offsetY)
    }

    private func resetUIBC(_ model: YSToastModel) {
        guard let view = model.ys_view(), let parentView = model.ys_parentView() else {
            return
        }
        let offsetX = model.ys_offset().horizontal
        let offsetY = model.ys_offset().vertical
        view.frame = CGRect(x: 0 + offsetX,
                            y: offsetY + 0,
                            width: model.ys_size().width,
                            height: model.ys_size().height)
        view.center = CGPoint(x: parentView.bounds.width / 2 + offsetX,
                              y: parentView.bounds.height - view.bounds.height / 2 + offsetY)
    }

    private func resetUIBL(_ model: YSToastModel) {
        guard let view = model.ys_view(), let parentView = model.ys_parentView() else {
            return
        }
        let offsetX = model.ys_offset().horizontal
        let offsetY = model.ys_offset().vertical
        view.frame = CGRect(x: 0 + offsetX,
                            y: offsetY + 0,
                            width: model.ys_size().width,
                            height: model.ys_size().height)
        view.center = CGPoint(x: view.bounds.width / 2 + offsetX,
                              y: parentView.bounds.height - view.bounds.height / 2 + offsetY)
    }

    private func resetUIBR(_ model: YSToastModel) {
        guard let view = model.ys_view(), let parentView = model.ys_parentView() else {
            return
        }
        let offsetX = model.ys_offset().horizontal
        let offsetY = model.ys_offset().vertical
        view.frame = CGRect(x: 0 + offsetX,
                            y: offsetY + 0,
                            width: model.ys_size().width,
                            height: model.ys_size().height)
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

struct YSToastModel: YSToastProtocol {
    var direction: YSToast.Direction = .CC
    var popSize: CGSize = CGSize()
    var popOffset: UIOffset = UIOffset(horizontal: 0, vertical: 0)
    weak var parentView: UIView?
    weak var customView: UIView?
    
    func ys_direction() -> YSToast.Direction {
        return direction
    }
    
    func ys_size() -> CGSize {
        return popSize
    }
    
    func ys_offset() -> UIOffset {
        return popOffset
    }
    
    func ys_parentView() -> UIView? {
        guard let parent = parentView else {
            return UIApplication.shared.windows.first
        }
        return parent
    }
    
    func ys_view() -> UIView? {
        return customView
    }
}

class YSToastLabel: UILabel {

    var size: CGSize = CGSize.zero

    func ys_view() -> UIView {
        return self
    }
    
    func ys_direction() -> YSToast.Direction {
        return .CC
    }

    func ys_size() -> CGSize {
        return size
    }
}

public protocol YSToastProtocol {
    // 弹框的位置
    func ys_direction() -> YSToast.Direction
    // 弹框的 Size
    func ys_size() -> CGSize
    // 弹框 View 的偏移
    func ys_offset() -> UIOffset
    // parentView
    func ys_parentView() -> UIView?
    // customView
    func ys_view() -> UIView?
}

public extension YSToastProtocol where Self: UIView {
    func ys_direction() -> YSToast.Direction {
        return .CC
    }
    
    func ys_size() -> CGSize {
        return CGSize(width: 200, height: 33)
    }
    
    func ys_offset() -> UIOffset {
        return UIOffset(horizontal: 0, vertical: 0)
    }
    
    func ys_parentView() -> UIView? {
        return UIApplication.shared.windows.last
    }
    
    func ys_view() -> UIView? {
        return self
    }
}

extension UIView: YSToastProtocol {

}
