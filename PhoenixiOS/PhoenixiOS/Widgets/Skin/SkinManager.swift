//
//  SkinManager.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/10/29.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import ReactiveSwift

enum SkinType: String {
    case white
    case black
    case other
}

class SkinManager: NSObject {
    static let instance = SkinManager()

    private let colors = [
        SkinType.white: ["color0": "#ff0000", "color1": "#00ff00", "color2": "#0000ff"],
        SkinType.black: ["color1": "#ff0000", "color2": "#00ff00", "color0": "#0000ff"],
        SkinType.other: ["color2": "#ff0000", "color0": "#00ff00", "color1": "#0000ff"]
    ]

    private let fonts = [
        SkinType.white: ["font0": 12, "font1": 35, "font2": 58],
        SkinType.black: ["font1": 12, "font2": 35, "font0": 58],
        SkinType.other: ["font2":12, "font0": 35, "font1": 58]
    ]

    private let images = [
        SkinType.white: ["images-0": UIImage(named: "icon"), "images-1": UIImage(named: "face_001"), "images-2": UIImage(named: "face_002")],
        SkinType.black: ["images-1": UIImage(named: "face_002"), "images-2": UIImage(named: "icon"), "images-0": UIImage(named: "face_001")],
        SkinType.other: ["images-2":UIImage(named: "face_001"), "images-0": UIImage(named: "face_002"), "images-1": UIImage(named: "icon")]
    ]

    var skin: SkinType = .white {
        didSet {
            autoSkin.value = skin
        }
    }

    var autoSkin = MutableProperty<SkinType>(.white)

    func getColor(name: String) -> UIColor {
        let colors = self.colors[self.skin]
        return UIColor(hex: colors?[name] ?? "#ffffff")
    }

    func getFont(name: String) -> UIFont {
        let fonts = self.fonts[self.skin]
        return UIFont.systemFont(ofSize: CGFloat(fonts?[name] ?? 6))
    }

    func getImage(name: String) -> UIImage? {
        let image = self.images[self.skin]
        return image?[name] ?? nil
    }

}
