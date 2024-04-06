//
//  TWBaseCollectionViewCell_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

class TWBaseCollectionViewCell_MTW: UICollectionViewCell {
    
    var gradientLayer = CAGradientLayer()
    var accentLayer = CALayer()
    
    var borderWidth: CGFloat {
        iPad ? 6.0 : 1.0
    }
    
    var adjustment: CGFloat {
        borderWidth * 2
    }
    
    var sizeAdjustment: CGFloat {
        adjustment * 2
    }
    
    var cornerRadius: CGFloat {
        adjustedRect.height / 4
    }
    
    var adjustedRect: CGRect {
        .init(x: adjustment,
              y: adjustment,
              width: bounds.width - sizeAdjustment,
              height: bounds.height - sizeAdjustment)
    }
    
    var gradientColors: [CGColor] { [] }
    
    var gradientStartPoint: CGPoint {
        .init(x:.zero, y: 0.5)
    }
    
    var gradientEndPoint: CGPoint {
        .init(x: 1.0, y: 0.5)
    }
    
    var backgroundFillColor: UIColor {
        .clear
    }
    
    var adjustedAccentRect: CGRect {
        let size = cornerRadius / 3
        let side = size * 1.4
        let origin: CGPoint = iPad
        ? .init(x: cornerRadius - adjustment,  y: size)
        : .init(x: cornerRadius * 0.75, y: size * 0.75)
        
        return .init(origin: origin, size: .init(width: side, height: side))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit_MTW()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit_MTW()
    }
    
    override func draw(_ rect: CGRect) {
        drawBackgroundLayer_MTW()
        drawAccent()
    }
    
    func commonInit_MTW() {
        backgroundColor = .clear
    }
    
    func drawBackgroundLayer_MTW() {
        let path = UIBezierPath(roundedRect: adjustedRect,
                                cornerRadius: cornerRadius)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.lineWidth = borderWidth
        mask.strokeColor = UIColor.black.cgColor
        mask.fillColor = nil
        
        gradientLayer.removeFromSuperlayer()
        gradientLayer = {
            let layer = CAGradientLayer()
            
            layer.frame = bounds
            layer.colors = gradientColors
            layer.startPoint = gradientStartPoint
            layer.endPoint = gradientEndPoint
            layer.mask = mask
            
            return layer
        }()
        
        layer.insertSublayer(gradientLayer, at: 0)
        
        backgroundFillColor.setFill()
        
        path.fill()
    }
    
    func drawAccent() {
        let accent = CALayer()
        accent.frame = adjustedAccentRect
        accent.contents = #imageLiteral(resourceName: "accent").cgImage
        
        accentLayer.removeFromSuperlayer()
        accentLayer = accent
        
        layer.insertSublayer(accentLayer, at: 1)
    }
    
}
