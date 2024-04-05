//
//  TWContentCategoryBubbleCollectionViewCell_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWContentCategoryBubbleCollectionViewCell_MTW:
    TWContentCategoryCollectionViewCell_MTW {
    
    private var coverLayer = CALayer()
    
    override func draw(_ rect: CGRect) {
        gradientLayer.removeFromSuperlayer()
        accentLayer.removeFromSuperlayer()
        
        drawCoverLayer()
    }
    
    override var backgroundFillColor: UIColor { .clear }
    
}

private extension TWContentCategoryBubbleCollectionViewCell_MTW {
    
    func drawCoverLayer() {
        let cover = CALayer()
        cover.frame = bounds
        cover.contents = drawSelected ? #imageLiteral(resourceName: "icon_bubble").cgImage : #imageLiteral(resourceName: "icon_bubble_plain").cgImage
        
        coverLayer.removeFromSuperlayer()
        coverLayer = cover
        
        layer.insertSublayer(coverLayer, at: .zero)
    }
    
}
