//
//  TWCharacterCoverView_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWCharacterCoverView_MTW: TWBaseView_MTW {
    
    override var adjustedShadowRect: CGRect {
        .init(x: 0,
              y: 0,
              width: bounds.width - 7,
              height: bounds.height - 7)
    }
    
    override var cornerRadius: CGFloat {
        bounds.height / 16
    }
    
    override var backgroundFillColor: UIColor {
        TWColors_MTW.contentSelectorCellShadow
    }
    
    override var shadowBackgroundColor: UIColor {
        TWColors_MTW.contentSelectorCellBackground
    }
    
}
