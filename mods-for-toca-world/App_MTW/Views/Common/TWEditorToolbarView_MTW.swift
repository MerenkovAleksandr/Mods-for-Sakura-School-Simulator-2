//
//  TWEditorToolbarView_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWEditorToolbarView: TWBaseView_MTW {
    
    override var cornerRadius: CGFloat {
        16.0
    }
    
    override func draw(_ rect: CGRect) {
        drawBackgroundLayer_MTW()
    }
    
    override var adjustedRect: CGRect {
        .init(x: adjustment,
              y: adjustment,
              width: bounds.width - sizeAdjustment,
              height: bounds.height)
    }
    
    override var backgroundLayerPath: UIBezierPath {
        .init(roundedRect: adjustedRect,
              byRoundingCorners: [.topLeft, .topRight],
              cornerRadii: CGSizeMake(cornerRadius,
                                      cornerRadius))
    }
    
}
