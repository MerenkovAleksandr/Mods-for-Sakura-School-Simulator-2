//
//  TWContentPlainCollectionViewCell_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

class TWContentPlainCollectionViewCell_MTW: TWBaseCollectionViewCell_MTW {
    
    @IBOutlet var ivContent: TWImageView_MTW!
    @IBOutlet var lblContentTitle: UILabel!
    
    override var cornerRadius: CGFloat {
        bounds.height / 4
    }
    
    var foregroundColor: UIColor {
        isHighlighted
        ? TWColors_MTW.contentSelectorCellSelectedForeground
        : TWColors_MTW.contentSelectorCellForeground
    }
    
    override var gradientColors: [CGColor] {
        isHighlighted
        ? selectedGradientColors
        : defaultGradientColors
    }
    
    var defaultGradientColors: [CGColor] {[
        TWColors_MTW.contentSelectorCellGradientStart.cgColor,
        TWColors_MTW.contentSelectorCellGradientEnd.cgColor
    ]}
    
    var selectedGradientColors: [CGColor] {[
        TWColors_MTW.contentSelectorCellSelectedGradientStart.cgColor,
        TWColors_MTW.contentSelectorCellSelectedGradientEnd.cgColor
    ]}
    
    override var backgroundFillColor: UIColor {
        isHighlighted
        ? TWColors_MTW.contentSelectorCellSelectedBackground
        : TWColors_MTW.contentSelectorCellBackground
    }
    
    override var gradientStartPoint: CGPoint {
        .zero
    }
    
    override var gradientEndPoint: CGPoint {
        .init(x: 1.0, y: 1.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ivContent.setCornerRadius_MTW(8.0)
    }
    
    override var isHighlighted: Bool {
        didSet {
            let title = lblContentTitle.attributedText?.string ?? ""
            configureTitleLabel(localizedTitle: title)
            
            setNeedsDisplay()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ivContent.image = nil
    }
    
}

// MARK: - Public API

extension TWContentPlainCollectionViewCell_MTW {
    
    func configure_MTW(with item: TWContentModel_MTW) {
        configureImageView(with: item)
        configureTitleLabel(localizedTitle: item.content.displayName ?? "")
    }
    
}

// MARK: - Private API

private extension TWContentPlainCollectionViewCell_MTW {
    
    func configureImageView(with item: TWContentModel_MTW) {
        ivContent.configure(with: item.content.image)
        ivContent.setCornerRadius_MTW(8.0)
    }
    
    func configureTitleLabel(localizedTitle: String) {
        lblContentTitle.attributedText = TWAttributtedStrings_MTW
            .contentSelectorItemAttrString(with: localizedTitle,
                                           foregroundColor: foregroundColor)
        lblContentTitle.sizeToFit()
    }
    
}
