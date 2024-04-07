//
//  TWContentCategoryCollectionViewCell_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

class TWContentCategoryCollectionViewCell_MTW: TWBaseCollectionViewCell_MTW {
    
    var lblTitle = UILabel()
    var drawSelected = false
    
    var foregroundColor: UIColor {
        drawSelected
        ? TWColors_MTW.contentCategoryCellSelectedForeground
        : TWColors_MTW.contentCategoryCellForeground
    }
    
    override var adjustment: CGFloat { 4.0 }
    
    override var adjustedAccentRect: CGRect {
        let size = cornerRadius / 2
        
        return .init(x: cornerRadius - adjustment,
                     y: size / 2 + adjustment / 2,
                     width: size,
                     height: size)
    }
    
    override var cornerRadius: CGFloat {
        adjustedRect.height / 2
    }
    
    override var gradientColors: [CGColor] {
        drawSelected
        ? [TWColors_MTW.bubbleViewGradientStart.cgColor,
           TWColors_MTW.bubbleViewGradientEnd.cgColor]
        : [TWColors_MTW.contentSelectorCellGradientStart.cgColor,
           TWColors_MTW.contentSelectorCellGradientEnd.cgColor]
    }
    
    override var backgroundFillColor: UIColor {
        drawSelected
        ? TWColors_MTW.bubbleViewForegroundColor
        : TWColors_MTW.contentSelectorCellBackground
    }
    
    override func drawBackgroundLayer_MTW() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 25, y: 5))
        path.addLine(to: CGPoint(x: bounds.width - 20, y: 5))
        path.addArc(withCenter: CGPoint(x: bounds.width - 20, y: 22), radius: 17, startAngle: -.pi/2, endAngle: .pi/2, clockwise: true)
        path.addLine(to: CGPoint(x: 25, y: 48))
        path.addArc(withCenter: CGPoint(x: 25, y: 27), radius: 21, startAngle: .pi/2, endAngle:-.pi , clockwise: true)
        path.addLine(to: CGPoint(x: 4, y: 30))
        path.addArc(withCenter: CGPoint(x: 25, y: 26), radius: 21, startAngle: -.pi, endAngle: -.pi/2, clockwise: true)
        
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit_MTW()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit_MTW()
    }
    
    override func commonInit_MTW() {
        super.commonInit_MTW()
        backgroundColor = .clear
        
        contentView.backgroundColor = .clear
        contentView.addSubview(lblTitle)
        
        makeLayout()
    }
    
}

// MARK: - Public API

extension TWContentCategoryCollectionViewCell_MTW {
    
    func configure(_ category: TWContentItemCategory_MTW, isSelected: Bool) {
        drawSelected = isSelected
        
        lblTitle.attributedText = TWAttributtedStrings_MTW
            .categoryItemAttrString(with: category.localizedTitle,
                                    foregroundColor: foregroundColor)
        
        setNeedsDisplay()
    }
    
}

// MARK: - Private API

private extension TWContentCategoryCollectionViewCell_MTW {
    
    func makeLayout() {
        lblTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24.0)
            make.trailing.equalToSuperview().offset(-24.0)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
}
