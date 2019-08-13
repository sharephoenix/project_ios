//
//  YSColorManager.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/13.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class YSColorManager: NSObject {

}

extension UIColor {

    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }

    convenience init(hex: String) {
        var currentHex = hex
        if currentHex.hasPrefix("#") {
            currentHex.removeFirst()
        }
        let scanner = Scanner(string: currentHex)
        scanner.scanLocation = 0

        var rgbValue: UInt64 = 0

        scanner.scanHexInt64(&rgbValue)
        if rgbValue <= 0xffffff {
            let r = (rgbValue & 0xff0000) >> 16
            let g = (rgbValue & 0xff00) >> 8
            let b = rgbValue & 0xff

            self.init(
                red: CGFloat(r) / 0xff,
                green: CGFloat(g) / 0xff,
                blue: CGFloat(b) / 0xff, alpha: 1
            )
        } else {
            let r = (rgbValue & 0xff000000) >> 24
            let g = (rgbValue & 0xff0000) >> 16
            let b = (rgbValue & 0xff00) >> 8
            let a = rgbValue & 0xff
            self.init(
                red: CGFloat(r) / 0xff,
                green: CGFloat(g) / 0xff,
                blue: CGFloat(b) / 0xff,
                alpha: CGFloat(a) / 0xff
            )
        }

    }
}
