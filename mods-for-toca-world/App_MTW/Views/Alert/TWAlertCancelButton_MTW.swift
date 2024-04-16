//
//  TWAlertCancelButton_MTW.swift
//  mods-for-toca-world
//
//  

import UIKit

final class TWAlertCancelButton_MTW: TWBaseButton_MTW {
    
    override var adjustedRect: CGRect {
        .init(x: 0,
              y: 0,
              width: bounds.width,
              height: bounds.height)
    }
    
    override var adjustedShadowRect: CGRect {
        .init(x: 0,
              y: 0,
              width: bounds.width - 4,
              height: bounds.height - 4)
    }
    
    override var backgroundFillColor: UIColor {
        TWColors_MTW.closeButtonShadow
    }
    
    override var shadowBackgroundColor: UIColor {
        TWColors_MTW.closeButtonBackgroound
    }
}
