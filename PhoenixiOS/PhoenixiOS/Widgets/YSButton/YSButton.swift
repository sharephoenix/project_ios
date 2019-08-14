//
//  RightImageButton.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/12.
//  Copyright © 2019 Danil Gontovnik. All rights reserved.
//

import UIKit
import Foundation

class YSButton: UIButton {

    struct Coordinate {
        var firstPoint: CGPoint = CGPoint(x: 0, y: 0)
        var secondPoint: CGPoint = CGPoint(x: 0, y: 0)
    }
    public enum Position {
        case labelLeftImageRight
        case labelRightImageLeft
        case labelTopImageBottom
        case labelBottomImageTop
    }
    var position: Position
    var gapH: Float = 10
    var gapV: Float = 10
    var centerPoint: CGPoint = CGPoint.init(x: 0, y: 0)

    init(frame: CGRect, gapSize: CGSize, position: Position) {
        self.position = position
        self.gapH = Float(gapSize.width)
        self.gapV = Float(gapSize.height)
        super.init(frame: frame)
    }

    convenience init(gapSize: CGSize, position: Position) {
        self.init(frame: .zero, gapSize: gapSize, position: position)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func caculateHXY(coordinate: inout Coordinate, firstView: UIView, secondView: UIView) {
        let boundsWith = bounds.width
        let firstFrame = firstView.frame
        let secondFrame = secondView.frame
        let allWidth = firstFrame.width + secondFrame.width + CGFloat(gapH)

        coordinate.firstPoint.x = boundsWith / 2.0 - allWidth / 2.0
        coordinate.firstPoint.y = firstFrame.origin.y
        coordinate.secondPoint.x = coordinate.firstPoint.x + firstFrame.width + CGFloat(gapH)
        coordinate.secondPoint.y = secondFrame.origin.y
    }

    func caculateVXY(coordinate: inout Coordinate, firstView: UIView, secondView: UIView) {
        let firstFrame = firstView.frame
        let secondFrame = secondView.frame
        let gapVFromCenter = gapV / 2.0

        coordinate.firstPoint.x = centerPoint.x - firstFrame.width / 2.0
        coordinate.firstPoint.y = centerPoint.y + CGFloat(gapVFromCenter)
        coordinate.secondPoint.x = centerPoint.x - secondFrame.width / 2.0
        coordinate.secondPoint.y =  centerPoint.y - secondFrame.height - CGFloat(gapVFromCenter)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let currentWith = bounds.width
        let currentHeight = bounds.height
        centerPoint = CGPoint.init(x: currentWith / 2.0, y: currentHeight / 2.0)
        var firstView: UIView?
        var secondView: UIView?
        var coordinate = Coordinate(firstPoint: CGPoint.zero, secondPoint: CGPoint.zero)
        if position == .labelBottomImageTop || position == .labelRightImageLeft {
            firstView = imageView
            secondView = titleLabel
        }
        if position == .labelLeftImageRight || position == .labelTopImageBottom {
            firstView = titleLabel
            secondView = imageView
        }
        guard firstView != nil, secondView != nil else {
            return
        }
        if position == .labelLeftImageRight || position == .labelRightImageLeft {
            caculateHXY(coordinate: &coordinate, firstView: firstView!, secondView: secondView!)
        }
        if position == .labelTopImageBottom || position == .labelBottomImageTop {
            caculateVXY(coordinate: &coordinate, firstView: firstView!, secondView: secondView!)
        }
        var currentImageFrame = CGRect.zero
        var currentLabelFrame = CGRect.zero
        switch position {
        case .labelLeftImageRight, .labelTopImageBottom:
            currentLabelFrame = CGRect(origin: coordinate.firstPoint, size: firstView!.frame.size)
            currentImageFrame = CGRect(origin: coordinate.secondPoint, size: secondView!.frame.size)
        case .labelRightImageLeft, .labelBottomImageTop:
            currentImageFrame = CGRect(origin: coordinate.firstPoint, size: firstView!.frame.size)
            currentLabelFrame = CGRect(origin: coordinate.secondPoint, size: secondView!.frame.size)
        }
        titleLabel?.frame = currentLabelFrame
        imageView?.frame = currentImageFrame
    }

}
