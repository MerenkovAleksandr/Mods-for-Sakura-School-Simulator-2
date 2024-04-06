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
        ? selectedGradientColors
        : defaultGradientColors
    }
    
    override var gradientStartPoint: CGPoint {
        .zero
    }
    
    override var gradientEndPoint: CGPoint {
        .init(x: 10.0, y: 10.0)
    }
    
    override var cornerRadius: CGFloat {
        adjustedRect.height / 10
    }
    
    override var backgroundFillColor: UIColor {
        drawSelected
        ? TWColors_MTW
            .contentSelectorCellSelectedBackground
            
        : TWColors_MTW
            .contentSelectorCellBackground
            
    }
    
    override func draw(_ rect: CGRect) {
        drawBackgroundLayer_MTW()
        
        if drawSelected {
            accentLayer.removeFromSuperlayer()
            return
        }
        
        drawAccent()
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
        configureTitleLabel(with: item.localizedTitle)
        
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
        drawSelected
        ? TWColors_MTW.contentSelectorCellSelectedForeground
        : TWColors_MTW.contentSelectorCellForeground
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
    
}
