//
//  TWBaseButton_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

class TWBaseButton_MTW: UIButton {
    
    var opacity: CGFloat = 1.0
    
    override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
            setNeedsDisplay()
        }
    }
    
    private var gradientLayer = CAGradientLayer()
    private var gradientShadowLayer = CAGradientLayer()
    private var accentLayer = CALayer()
    
    var gradientStartPoint: CGPoint {
        .zero
    }
    
    var gradientEndPoint: CGPoint {
        .init(x: 1.0, y: 1.0)
    }
    
    var backgroundFillColor: UIColor {
        TWColors_MTW.buttonShadow
    }
    
    var shadowBackgroundColor: UIColor {
        TWColors_MTW.buttonBackground
    }
    
    var borderWidth: CGFloat {
       iPad ? 6.0 : 3.0
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
              width: bounds.width - sizeAdjustment + 2,
              height: bounds.height - sizeAdjustment + 2)
    }
    
    var adjustedShadowRect: CGRect {
        .init(x: adjustment,
              y: adjustment,
              width: bounds.width - sizeAdjustment - 2,
              height: bounds.height - sizeAdjustment - 2)
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
            layer.startPoint = gradientStartPoint
            layer.endPoint = gradientEndPoint
            layer.mask = mask
            
            return layer
        }()
        
        layer.insertSublayer(gradientLayer, at: 0)
        
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
            layer.startPoint = gradientStartPoint
            layer.endPoint = gradientEndPoint
            
            layer.addSublayer(shadowLayer)
            
            return layer
        }()
        
        layer.insertSublayer(gradientShadowLayer, at: 0)
    }
    
    func configure_MTW(with localizedTitle: String) {
        let foregroundColor = TWColors_MTW.buttonForegroundColor
            .withAlphaComponent(opacity)
        let attributtedTitle = TWAttributtedStrings_MTW
            .barAttrString(with: localizedTitle,
                           foregroundColor: foregroundColor)
        
        setAttributedTitle(attributtedTitle, for: .normal)
        setNeedsDisplay()
    }
}
