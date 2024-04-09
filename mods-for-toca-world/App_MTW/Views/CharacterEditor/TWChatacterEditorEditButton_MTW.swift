//
//  TWChatacterEditorEditButton_MTW.swift
//  mods-for-toca-world
//
//  Created by Александр Меренков on 09.04.2024.
//

import UIKit

final class TWCharacterEditorEditButton_MTW: TWBaseButton_MTW {
    
    private var gradientLayer = CAGradientLayer()
    
    override func drawBackgroundLayer_MTW() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 25, y: 12))
        path.addLine(to: CGPoint(x: bounds.width - 30, y: 16))
        path.addArc(withCenter: CGPoint(x: bounds.width - 30, y: 30), radius: 14, startAngle: 3 * .pi/2, endAngle: 2 * .pi , clockwise: true)
        path.addArc(withCenter: CGPoint(x: bounds.width - 30, y: 34), radius: 14, startAngle: 2 * .pi, endAngle: .pi/2 , clockwise: true)
        path.addLine(to: CGPoint(x: 25, y: 48))
        path.addArc(withCenter: CGPoint(x: 25, y:34), radius: 14, startAngle: .pi/2, endAngle:-.pi , clockwise: true)
        path.addArc(withCenter: CGPoint(x: 25, y: 26), radius: 14, startAngle: -.pi, endAngle: -.pi/2, clockwise: true)
        
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

}
