//
//  TWContentSelectorCollectionViewCell_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWContentSelectorCollectionViewCell_MTW: TWBaseCollectionViewCell_MTW {
    
    @IBOutlet private var ivContentImage: UIImageView!
    @IBOutlet private var lblContentTitle: UILabel!
    @IBOutlet private var ivContentLock: UIImageView!
    @IBOutlet private var vContentLock: UIView!
    
    private var backgrountColorToSet: UIColor = .clear
    private var shadowColor: UIColor = .clear
    
    var adjustedShadowRect: CGRect {
        .init(x: adjustment,
              y: adjustment,
              width: bounds.width - sizeAdjustment,
              height: bounds.height - sizeAdjustment)
    }
    
    override var isHighlighted: Bool {
        didSet {
            updateApperance()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateApperance()
        }
    }
    
    override var gradientColors: [CGColor] {
        drawSelected
        ? defaultGradientColors
        : defaultGradientColors
    }
    
    override var gradientStartPoint: CGPoint {
        .zero
    }
    
    override var gradientEndPoint: CGPoint {
        .init(x: 10.0, y: 10.0)
    }
    
    override var cornerRadius: CGFloat {
        adjustedRect.height / 8
    }
    
    override var backgroundFillColor: UIColor {
        shadowColor
    }
    
    override var adjustedRect: CGRect {
        .init(x: 5.0,
              y: 5.0,
              width: bounds.width - 5,
              height: bounds.height - 5)
    }
    
    override func draw(_ rect: CGRect) {
        drawBackgroundLayer_MTW()
        drawShadowLayer_MTW()
        
        if drawSelected {
            accentLayer.removeFromSuperlayer()
            return
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ivContentLock.visibility(isVisible: false)
        vContentLock.visibility(isVisible: false)
    }
    
}


// MARK: - Public API

extension TWContentSelectorCollectionViewCell_MTW {
    
    func configure_MTW(with item: TWContentSelectorItem_MTW,
                   isContentLocked: Bool = false) {

        configureContentImage(item.image)
        configureTitleLabel(with: item.localizedTitle.uppercased())

        backgrountColorToSet = item.backgroundColor
        shadowColor = item.shadowColor
        
        ivContentLock.visibility(isVisible: isContentLocked)
        vContentLock.visibility(isVisible: isContentLocked)
        
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(roundedRect: adjustedRect,
                                 cornerRadius: cornerRadius).cgPath
        vContentLock.layer.mask = mask
        
        setNeedsDisplay()
    }
    
}

// MARK: - Private API

private extension TWContentSelectorCollectionViewCell_MTW {
    
    var drawSelected: Bool {
        isSelected || isHighlighted
    }
    
    var foregoundColor: UIColor {
        TWColors_MTW.contentCellForeground
    }
    
    var defaultGradientColors: [CGColor] {[
        TWColors_MTW.contentSelectorCellGradientStart.cgColor,
        TWColors_MTW.contentSelectorCellGradientEnd.cgColor
    ]}
    
    var selectedGradientColors: [CGColor] {[
        TWColors_MTW.contentSelectorCellSelectedGradientStart.cgColor,
        TWColors_MTW.contentSelectorCellSelectedGradientEnd.cgColor
    ]}
    
    func updateApperance() {
        updateTitleLabelAppearance()
        setNeedsDisplay()
    }
    
    func configureContentImage(_ image: UIImage?) {
        ivContentImage.image = image
    }
    
    func configureTitleLabel(with title: String) {
        lblContentTitle.attributedText = TWAttributtedStrings_MTW
            .contentSelectorItemAttrString(with: title,
                                           foregroundColor: foregoundColor)
        lblContentTitle.sizeToFit()
    }
    
    func updateTitleLabelAppearance() {
        let title = lblContentTitle.attributedText?.string ?? ""
        configureTitleLabel(with: title)
    }
    
    func drawShadowLayer_MTW() {
        let shadowLayer = CALayer()
        shadowLayer.frame = adjustedShadowRect
        shadowLayer.cornerRadius = cornerRadius
        shadowLayer.backgroundColor = backgrountColorToSet.cgColor
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
