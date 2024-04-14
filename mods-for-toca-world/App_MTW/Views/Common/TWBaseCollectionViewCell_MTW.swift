//
//  TWBaseCollectionViewCell_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

class TWBaseCollectionViewCell_MTW: UICollectionViewCell {
    
    var gradientLayer = CAGradientLayer()
    var gradientShadowLayer = CAGradientLayer()
    var accentLayer = CALayer()
    
    var borderWidth: CGFloat {
        iPad ? 6.0 : 1.0
    }
    
    var adjustment: CGFloat {
        borderWidth * 2
    }
    
    var sizeAdjustment: CGFloat {
        adjustment * 4
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
    
    var adjustedShadowRect: CGRect {
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
    
    var shadowBackgroundColor: UIColor {
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
        drawShadowLayer_MTW()
        drawBackgroundLayer_MTW()
    }
    
    func commonInit_MTW() {
        backgroundColor = .clear
    }
    
    func drawBackgroundLayer_MTW() {
        let path = UIBezierPath(roundedRect: adjustedRect,
                                cornerRadius: cornerRadius)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
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
        
        layer.insertSublayer(gradientLayer, at: 1)
        
        backgroundFillColor.setFill()
        
        path.fill()
    }
    
    func drawShadowLayer_MTW() {
        let shadowLayer = CALayer()
        shadowLayer.frame = adjustedShadowRect
        shadowLayer.cornerRadius = cornerRadius
        shadowLayer.backgroundColor = shadowBackgroundColor.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowRadius = 3.0
        shadowLayer.shadowOffset = CGSize(width: 0, height: 2)
        
        gradientShadowLayer.removeFromSuperlayer()
        gradientShadowLayer = {
            let layer = CAGradientLayer()
            layer.frame = bounds
            layer.colors = gradientColors
            layer.startPoint = gradientStartPoint
            layer.endPoint = gradientEndPoint
            
            layer.addSublayer(shadowLayer)
            
            return layer
        }()
        
        layer.insertSublayer(gradientShadowLayer, at: 0)
    }
    
}
