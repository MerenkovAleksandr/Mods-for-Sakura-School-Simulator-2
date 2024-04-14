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
        TWColors_MTW.contentCategoryCellForeground
    }
    
    var shadowColor: UIColor {
       drawSelected
       ? TWColors_MTW.contentSelectorCellShadow
       : TWColors_MTW.bubbleViewForegroundShadow
    }
    
    var adjustedShadowRect: CGRect {
        .init(x: adjustment,
              y: adjustment,
              width: bounds.width - sizeAdjustment,
              height: bounds.height - sizeAdjustment)
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
    
    override var adjustedRect: CGRect {
        .init(x: 5.0,
              y: 7.0,
              width: bounds.width - 12,
              height: bounds.height - 14)
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
        ? TWColors_MTW.contentSelectorCellBackground
        : TWColors_MTW.bubbleViewForegroundColor
    }
    
    override func draw(_ rect: CGRect) {
        drawShadowLayer_MTW()
        drawBackgroundLayer_MTW()
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
            make.leading.equalToSuperview().offset(34.0)
            make.trailing.equalToSuperview().offset(-34.0)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func drawShadowLayer_MTW() {
        let shadowLayer = CALayer()
        shadowLayer.frame = adjustedShadowRect
        shadowLayer.cornerRadius = cornerRadius
        shadowLayer.backgroundColor = backgroundFillColor.cgColor
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
