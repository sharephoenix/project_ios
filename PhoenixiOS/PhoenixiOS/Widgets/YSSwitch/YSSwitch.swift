//
//  YSSwitch.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/12.
//  Copyright © 2019 Danil Gontovnik. All rights reserved.
//
/*
 * T: 支持 String UIImage 两种类型
 */
import UIKit

class YSSwitch<T>: UIControl, UIGestureRecognizerDelegate {
    /// switch Color
    var switchButtonColor = UIColor.white {
        didSet {
            self.switchButton.backgroundColor = self.switchButtonColor
        }
    }
    /// 文字默认颜色
    var normalColor = UIColor.black {
        didSet {
            self.normalImageViews.forEach { (view) in
                if let view = view.subviews.first as? UILabel {
                    view.textColor = self.normalColor
                }
            }
        }
    }
    /// 默认字体
    var normalFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            self.normalImageViews.forEach { (view) in
                if let view = view.subviews.first as? UILabel {
                    view.font = self.normalFont
                }
            }
        }
    }
    /// 默认背景色
    var normalBgColor = UIColor.white {
        didSet {
            self.normalImageViews.forEach { (view) in
                view.backgroundColor = self.normalBgColor
            }
        }
    }
    /// 文字选中颜色
    var selectedColor = UIColor.blue {
        didSet {
            self.selectedImageViews.forEach { (view) in
                if let view = view.subviews.first as? UILabel {
                    view.textColor = self.selectedColor
                }
            }
        }
    }
    /// 选中字体大小
    var selectedFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            self.selectedImageViews.forEach { (view) in
                if let view = view.subviews.first as? UILabel {
                    view.font = self.selectedFont
                }
            }
        }
    }
    /// 选中回调方法
    var callback: ((Int) -> Void)?
    /// 背景颜色
    var bgColor = UIColor.white
    /// switch 的圆角宽度
    var switchButtonBorderWidth: CGFloat = 2
    /// 默认图片展示
    var switchNormalContentMode: UIView.ContentMode = .center {
        didSet {
            self.normalImageViews.forEach { (view) in
                view.subviews.first?.contentMode = self.switchNormalContentMode
            }
        }
    }
    /// 选中图片展示
    var switchSelectedContentMode: UIView.ContentMode = .center {
        didSet {
            self.selectedImageViews.forEach { (view) in
                view.subviews.first?.contentMode = self.switchSelectedContentMode
            }
        }
    }
    /// switch 上图片的布局方式
    var switchIconMode: UIView.ContentMode = .center {
        didSet {
            switchButton.subviews.first?.contentMode = self.switchIconMode
        }
    }
    /// switch Icon
    var switchIcon: UIImage? {
        didSet {
            switchButton.subviews.forEach { (view) in
                view.removeFromSuperview()
            }
            let imageView = UIImageView(image: self.switchIcon)
            imageView.image = self.switchIcon
            imageView.contentMode = self.switchIconMode
            switchButton.addSubview(imageView)
        }
    }

    /// 默认选中
    var selectedIndex = 0 {
        didSet {
            if let callback = self.callback, oldValue != self.selectedIndex {
                callback(self.selectedIndex)
            }
        }
    }

    open var animationDuration: TimeInterval = 0.3
    open var animationSpringDamping: CGFloat = 0.75
    open var animationInitialSpringVelocity: CGFloat = 0.0

    /// 默认图片
    private var normalViews: [T] = [T]()
    /// 选中时候的 image
    private var selectedViews: [T?] = [T]()
    /// 默认背景布局
    private var backContent = UIView()
    /// 默认前景选中布局
    private var frontContent = UIView()
    /// 选中滑块
    private var switchButton = UIView()

    private var normalImageViews = [UIView]()
    private var selectedImageViews = [UIView]()

    fileprivate var tapGesture: UITapGestureRecognizer!
    fileprivate var panGesture: UIPanGestureRecognizer!

    fileprivate var initialSelectedBackgroundViewFrame: CGRect?

    /// maskLayer
    var maskLayer = CALayer()

    open var selectedBackgroundInset: CGFloat = 2.0 {
        didSet { setNeedsLayout() }
    }

    public init(normal: [T], selected: [T?]) {
        super.init(frame: CGRect.zero)

        self.normalViews = normal
        self.selectedViews = selected
        finishInit()

        layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func finishInit() {
        addSubview(backContent)
        addSubview(switchButton)
        addSubview(frontContent)

        for i in 0..<normalViews.count {
            var contentView: UIView?
            if let content = normalViews[i] as? UIImage {
                contentView = UIImageView(image: content)
            }
            if let content = normalViews[i] as? String {
                let label = UILabel()
                label.text = content
                label.textColor = normalColor
                label.textAlignment = .center
                contentView = label
            }
            if let contentView = contentView {
                let view = UIView()
                view.addSubview(contentView)
                normalImageViews.append(view)
                backContent.addSubview(view)
            }
        }

        for i in 0..<selectedViews.count {
            var contentView: UIView?
            if let content = selectedViews[i] as? UIImage {
                contentView = UIImageView(image: content)
            }
            if let content = selectedViews[i] as? String {
                let label = UILabel()
                label.text = content
                label.textColor = selectedColor
                label.textAlignment = .center
                contentView = label
            }
            if let contentView = contentView {
                let view = UIView()
                view.addSubview(contentView)
                selectedImageViews.append(view)
                frontContent.addSubview(view)
            }
        }

        restStyle()
    }

    /// 重置界面样式
    private func restStyle() {
        backContent.backgroundColor = bgColor
        switchButton.backgroundColor = switchButtonColor
        switchButton.layer.cornerRadius = layer.cornerRadius
        switchButton.layer.borderWidth = switchButtonBorderWidth
        switchButton.layer.borderColor = layer.borderColor
        maskLayer.masksToBounds = true
        maskLayer.cornerRadius = layer.cornerRadius

        resetSwitchButton()
    }

    private func resetSwitchButton() {
        switchButton.subviews.first?.frame = switchButton.bounds
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard normalViews.count == selectedViews.count && normalViews.count > 0 else {
            return
        }

        let width = self.frame.width / CGFloat(normalViews.count)
        switchButton.frame = CGRect(x: CGFloat(selectedIndex) * width, y: 0, width: width, height: frame.height)
        switchButton.layer.masksToBounds = true
        switchButton.layer.cornerRadius = layer.cornerRadius

        for i in 0..<normalImageViews.count {
            let imageView = normalImageViews[i]
            imageView.frame = CGRect(x: CGFloat(i) * width, y: 0, width: width, height: frame.height)
            imageView.backgroundColor = normalBgColor
            imageView.subviews.first?.frame = imageView.bounds
            imageView.subviews.first?.contentMode = switchNormalContentMode
        }

        for i in 0..<selectedImageViews.count {
            let imageView = selectedImageViews[i]
            imageView.frame = CGRect(x: CGFloat(i) * width, y: 0, width: width, height: frame.height)
            imageView.subviews.first?.frame = imageView.bounds
            imageView.subviews.first?.contentMode = switchSelectedContentMode
        }

        if frontContent.layer.mask == nil {
            frontContent.layer.mask = maskLayer
            frontContent.layer.mask?.removeAllAnimations()
            frontContent.layer.removeAllAnimations()
            switchButton.layer.removeAllAnimations()
        }

        maskLayer.frame = switchButton.frame

        maskLayer.backgroundColor = UIColor.white.cgColor

        // Gestures
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tapGesture)

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)

        frontContent.frame = bounds
        backContent.frame = bounds
        frontContent.layer.removeAllAnimations()

        restStyle()
    }

    @objc func tapped(_ gesture: UITapGestureRecognizer!) {
        let location = gesture.location(in: self)
        let index = Int(location.x / (bounds.width / CGFloat(normalViews.count)))
        setSelectedIndex(index, animated: true)
    }

    @objc func pan(_ gesture: UIPanGestureRecognizer!) {
        if gesture.state == .began {
            initialSelectedBackgroundViewFrame = switchButton.frame
        } else if gesture.state == .changed {
            var frame = initialSelectedBackgroundViewFrame!
            frame.origin.x += gesture.translation(in: self).x
            frame.origin.x = max(min(frame.origin.x, bounds.width - selectedBackgroundInset - frame.width), selectedBackgroundInset)

            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.switchButton.frame = frame
            self.maskLayer.frame = frame
            CATransaction.commit()

        } else if gesture.state == .ended || gesture.state == .failed || gesture.state == .cancelled {
            let index = max(0, min(normalViews.count - 1, Int(switchButton.center.x / (bounds.width / CGFloat(normalViews.count)))))
            setSelectedIndex(index, animated: true)
        }
        sendActions(for: .valueChanged)
    }

    open func setSelectedIndex(_ selectedIndex: Int, animated: Bool) {
        guard normalViews.count == selectedViews.count && normalViews.count > 0 else {
            return
        }

        guard 0..<normalViews.count ~= selectedIndex else { return }

        var catchHalfSwitch = false
        if self.selectedIndex == selectedIndex {
            catchHalfSwitch = true
        }

        self.selectedIndex = selectedIndex
        if animated {
            if (!catchHalfSwitch) {
                self.sendActions(for: .valueChanged)
            }
            UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: animationSpringDamping, initialSpringVelocity: animationInitialSpringVelocity, options: [UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.curveEaseOut], animations: { () -> Void in
                self.layoutSubviews()
            }, completion: nil)
        } else {
            layoutSubviews()
            sendActions(for: .valueChanged)
        }
    }

    // MARK: - UIGestureRecognizerDelegate
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGesture {
            return switchButton.frame.contains(gestureRecognizer.location(in: self))
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }

}
