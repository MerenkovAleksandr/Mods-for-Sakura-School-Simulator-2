//
//  TWCharacterCoverView_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWCharacterCoverView_MTW: TWBaseView_MTW {
    
    override var cornerRadius: CGFloat {
        bounds.height / 16
    }
    
    override func draw(_ rect: CGRect) {
        drawBackgroundLayer_MTW()
    }
    
}
