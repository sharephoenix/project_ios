//
//  ViewExtension.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/10/29.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

extension UIView {
    func backgroundColor_t(_ colorName: String) {
        SkinManager.instance.autoSkin.producer.take(during: self.reactive.lifetime).startWithValues {[weak self] type in
            self?.backgroundColor = SkinManager.instance.getColor(name: colorName)
        }
    }
}

extension UILabel {
    func font_t(_ fontName: String) {
        SkinManager.instance.autoSkin.producer.take(during: self.reactive.lifetime).startWithValues {[weak self] type in
                   self?.font = SkinManager.instance.getFont(name: fontName)
               }
    }

    func textColor_t(_ colorName: String) {
        SkinManager.instance.autoSkin.producer.take(during: self.reactive.lifetime).startWithValues {[weak self] type in
            self?.textColor = SkinManager.instance.getColor(name: colorName)
        }
    }
}

extension UITextView {
    func font_t(_ fontName: String) {
        SkinManager.instance.autoSkin.producer.take(during: self.reactive.lifetime).startWithValues {[weak self] type in
                   self?.font = SkinManager.instance.getFont(name: fontName)
               }
    }
}

extension UITextField {
    func font_t(_ fontName: String) {
        SkinManager.instance.autoSkin.producer.take(during: self.reactive.lifetime).startWithValues {[weak self] type in
                   self?.font = SkinManager.instance.getFont(name: fontName)
               }
    }
}

extension CALayer {
    func backgroundColor_t(_ colorName: String) {
        SkinManager.instance.autoSkin.producer.take(during: self.reactive.lifetime).startWithValues {[weak self] type in
            self?.backgroundColor = SkinManager.instance.getColor(name: colorName).cgColor
               }
    }
}

extension UIImageView {
    func image_t(_ imageName: String) {
        SkinManager.instance.autoSkin.producer.take(during: self.reactive.lifetime).startWithValues {[weak self] type in
            self?.image = SkinManager.instance.getImage(name: imageName)
               }
    }
}

extension UIButton {
    func setBackgroundImage_t(_ imageName: String, state: UIControl.State) {
        SkinManager.instance.autoSkin.producer
            .take(during: self.reactive.lifetime)
            .startWithValues {[weak self] type in
                let image = SkinManager.instance.getImage(name: imageName)
                self?.setBackgroundImage(image, for: state)
           }
    }

    func setTitleColor_t(_ colorName: String, state: UIControl.State) {
        SkinManager.instance.autoSkin.producer
         .take(during: self.reactive.lifetime)
         .startWithValues {[weak self] type in
             let color = SkinManager.instance.getColor(name: colorName)
             self?.setTitleColor(color, for: state)
        }

    }
}
