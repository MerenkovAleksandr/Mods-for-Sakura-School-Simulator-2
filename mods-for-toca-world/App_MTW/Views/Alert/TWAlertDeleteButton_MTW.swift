//
//  TWAlertDeleteButton_MTW.swift
//  mods-for-toca-world
//
//  Created by Александр Меренков on 16.04.2024.
//

import UIKit

final class TWAlertDeleteButton_MTW: TWBaseButton_MTW {
    
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
        TWColors_MTW.deleteButtonShadow
    }
    
    override var shadowBackgroundColor: UIColor {
        TWColors_MTW.deleteButtonBackground
    }
}
