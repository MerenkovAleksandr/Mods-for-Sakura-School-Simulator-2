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
        let updateBounds = CGRect(x: 0, y: 0, width: bounds.width + 8.0, height: bounds.height)
        cover.frame = updateBounds
        cover.contents = drawSelected ? #imageLiteral(resourceName: "icon_bubble_category_selected").cgImage : #imageLiteral(resourceName: "icon_bubble_category").cgImage
        
        coverLayer.removeFromSuperlayer()
        coverLayer = cover
        
        layer.insertSublayer(coverLayer, at: .zero)
    }
    
}
