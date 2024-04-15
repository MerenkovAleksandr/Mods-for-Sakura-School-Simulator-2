//
//  TWBaseView_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

class TWBaseView_MTW: UIView {
    
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
        adjustment * 2
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
    
    var cornerRadius: CGFloat {
        adjustedRect.height / 2.0
    }
    
    var adjustedAccentRect: CGRect {
        let size = cornerRadius / 2
        
        return .init(x: cornerRadius - adjustment,
                     y: size / 2 + adjustment / 2,
                     width: size,
                     height: size)
    }
    
    var gradientColors: [CGColor] {[
        TWColors_MTW.contentSelectorCellGradientStart.cgColor,
        TWColors_MTW.contentSelectorCellGradientEnd.cgColor
    ]}
    
    var gradientStartPoint: CGPoint {
        .zero
    }
    
    var gradientEndPoint: CGPoint {
        .init(x: 1.0, y: 1.0)
    }
    
    var backgroundFillColor: UIColor {
        TWColors_MTW.contentSelectorCellBackground
    }
    
    var shadowBackgroundColor: UIColor {
        .clear
    }
    
    var backgroundLayerPath: UIBezierPath {
        .init(roundedRect: adjustedRect, cornerRadius: cornerRadius)
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
        let path = backgroundLayerPath
        let mask = CAShapeLayer()
        mask.path = path.cgPath
//        mask.lineWidth = borderWidth
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
