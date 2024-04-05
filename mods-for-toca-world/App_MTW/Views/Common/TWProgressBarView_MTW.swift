//
//  TWProgressBarView_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWProgressBarView_MTW: TWBaseView_MTW {
    
    var didFinishAnimation: ((_ progress: CGFloat) -> Void)?
    
    private var progressValue: CGFloat = 0.1
    private var pendingProgress: CGFloat?
    private var progressBarShape = CAShapeLayer()
    
    private(set) var isAnimating: Bool = false
    
    override func draw(_ rect: CGRect) {
        super.drawBackgroundLayer_MTW()
        
        layer.addSublayer(progressBarShape)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        progressBarShape.removeAllAnimations()
        updateProgressBarShape()
    }
    
    override var adjustment: CGFloat {
        iPad ? 10.0 : 5.0
    }
    
    override var gradientColors: [CGColor] {[
        TWColors_MTW.progressBarGradientStart.cgColor,
        TWColors_MTW.progressBarGradientEnd.cgColor
    ]}
    
    override var backgroundFillColor: UIColor {
        TWColors_MTW.progressBarBackground
    }
    
}

// MARK: - CAAnimationDelegate

extension TWProgressBarView_MTW: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            updateProgressBarShape()
            isAnimating = false
            if let value = pendingProgress {
                pendingProgress = nil
                setProgress_MTW(value: value, animated: true)
                return
            }
            didFinishAnimation?(progressValue)
        }
    }
    
}

// MARK: - Public API

extension TWProgressBarView_MTW {
    
    func setProgress_MTW(value: CGFloat = 1.0, animated: Bool = false) {
        guard progressValue != value else { return }
        if isAnimating, animated {
            pendingProgress = value
            return
        }
        guard animated else {
            updateProgressBarShape()
            return
        }
        isAnimating = true
        progressValue = value
        animateProgressBarShape()
    }
    
}

// MARK: - Private API

private extension TWProgressBarView_MTW {
    
    var customAdjustedRect: CGRect {
        let customAdjustment = adjustment * 1.5
        let customSizeAdjustment = customAdjustment * 2
        
        return .init(x: customAdjustment,
                     y: customAdjustment,
                     width: bounds.width - customSizeAdjustment,
                     height: bounds.height - customSizeAdjustment)
    }
    
    var adjustedProgressBarPath: UIBezierPath {
        let adjWidth = customAdjustedRect.width * progressValue
        let roundedRect = CGRect(origin: customAdjustedRect.origin,
                                 size: .init(width: adjWidth,
                                             height: customAdjustedRect.height))
        
        return .init(roundedRect: roundedRect,
                     cornerRadius: roundedRect.height / 2)
    }
    
    func updateProgressBarShape() {
        progressBarShape.path = adjustedProgressBarPath.cgPath
        progressBarShape.fillColor = TWColors_MTW.progressBarForeground.cgColor
    }
    
    func animateProgressBarShape() {
        let oldShapePath = progressBarShape.path
        let newShapePath = adjustedProgressBarPath.cgPath
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 1.0
        animation.fromValue = oldShapePath
        animation.toValue = newShapePath
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.delegate = self
        
        progressBarShape.path = newShapePath
        progressBarShape.add(animation, forKey: "path")
    }
    
}
