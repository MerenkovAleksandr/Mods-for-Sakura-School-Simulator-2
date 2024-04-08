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
    private var accentLayer = CALayer()
    
    var gradientColors: [CGColor] {[
        TWColors_MTW.bubbleViewGradientStart.withAlphaComponent(opacity).cgColor,
        TWColors_MTW.bubbleViewGradientEnd.withAlphaComponent(opacity).cgColor
    ]}
    
    var gradientStartPoint: CGPoint {
        .zero
    }
    
    var gradientEndPoint: CGPoint {
        .init(x: 1.0, y: 1.0)
    }
    
    var backgroundFillColor: UIColor {
        TWColors_MTW.bubbleViewForegroundColor.withAlphaComponent(opacity)
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
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 25, y: 2))
        path.addLine(to: CGPoint(x: bounds.width - 40, y: 10))
        path.addArc(withCenter: CGPoint(x: bounds.width - 40, y: 29), radius: 19, startAngle: 3 * .pi/2, endAngle: 2 * .pi , clockwise: true)
        path.addLine(to: CGPoint(x: bounds.width - 20, y: 32))
        path.addArc(withCenter: CGPoint(x: bounds.width - 40, y: 39), radius: 19, startAngle: 2 * .pi, endAngle: .pi/2 , clockwise: true)
        path.addLine(to: CGPoint(x: 25, y: 56))
        path.addArc(withCenter: CGPoint(x: 25, y:42), radius: 14, startAngle: .pi/2, endAngle:-.pi , clockwise: true)
        path.addLine(to: CGPoint(x: 10, y: 24))
        path.addArc(withCenter: CGPoint(x: 25, y: 16), radius: 14, startAngle: -.pi, endAngle: -.pi/2, clockwise: true)
        
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
        
        layer.insertSublayer(gradientLayer, at: 2)
    }
    
    func configure_MTW(with localizedTitle: String) {
        let foregroundColor = TWColors_MTW.bubbleViewTextColor
            .withAlphaComponent(opacity)
        let attributtedTitle = TWAttributtedStrings_MTW
            .barAttrString(with: localizedTitle,
                           foregroundColor: foregroundColor)
        
        setAttributedTitle(attributtedTitle, for: .normal)
        setNeedsDisplay()
    }
}
