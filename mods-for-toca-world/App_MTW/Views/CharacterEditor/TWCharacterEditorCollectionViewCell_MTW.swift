//
//  TWCharacterEditorCollectionViewCell_MTW.swift
//  mods-for-toca-world
//
//

import UIKit

class TWCharacterEditorCollectionViewCell_MTW: TWBaseCollectionViewCell_MTW {
        
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var ivContent: TWImageView_MTW!
    @IBOutlet var vBubble: TWBubbleView_MTW!
    
    var didCallSubMenu: ((_ sender: UIView,
                          _ character: TWCharacterPreview_MTW) -> Void)?
    var didUpdate: (() -> Void)?
    
    private(set) var id: UUID?
    private(set) var isFavourite: Bool = false
    
    override var cornerRadius: CGFloat {
        bounds.height / 8
    }
    
    override var adjustedRect: CGRect {
        .init(x: 5.0,
              y: 7.0,
              width: bounds.width - 6,
              height: bounds.height - 6)
    }
    
    override var gradientColors: [CGColor] {[
        TWColors_MTW.contentSelectorCellGradientStart.cgColor,
        TWColors_MTW.contentSelectorCellGradientEnd.cgColor
    ]}
    
    override var shadowBackgroundColor: UIColor {
        TWColors_MTW.contentSelectorCellBackground
    }
    
    override var gradientStartPoint: CGPoint {
        .zero
    }
    
    override var gradientEndPoint: CGPoint {
        .init(x: 1.0, y: 1.0)
    }
    
    override var backgroundFillColor: UIColor {
        TWColors_MTW.contentSelectorCellShadow
    }
    
    override func commonInit_MTW() {
        super.commonInit_MTW()
         
        backgroundView = .clearView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        applyMask()
        ivContent.setCornerRadius_MTW(8.0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ivContent.hideNewCharacter()
    }

}

// MARK: - Public API

extension TWCharacterEditorCollectionViewCell_MTW {
    
    func configure(with character: TWCharacterPreview_MTW? = nil) {
        lblTitle.hide_MTW()
                
        if let character {
            ivContent.image = character.image
            ivContent.backgroundColor = TWColors_MTW.imageViewEmptyBackground
            vBubble.makeInteractive { [weak self] in
                guard let self else { return }
                self.didCallSubMenu?(self.vBubble, character) }
        } else {
            ivContent.backgroundColor = TWColors_MTW.imageViewEmptyBackground
            vBubble.isUserInteractionEnabled = false
            ivContent.createNewCharacter()
        }
        vBubble.updateImageViewForEdit()
    }
    
}

// MARK: - Private API

private extension TWCharacterEditorCollectionViewCell_MTW {
    
    func applyMask() {
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath()
        let cornerRadius: CGFloat = 15
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: bounds.width - 90, y: 0))
        path.addArc(withCenter: CGPoint(x: bounds.width - 70, y: cornerRadius), radius: cornerRadius, startAngle: .pi * 3 / 2, endAngle: 0, clockwise: true)
        path.addArc(withCenter: CGPoint(x: bounds.width - 40, y: cornerRadius), radius: cornerRadius, startAngle: .pi, endAngle: .pi / 2, clockwise: false)
        path.addArc(withCenter: CGPoint(x: bounds.width - 40, y: cornerRadius * 3), radius: cornerRadius, startAngle: .pi * 3 / 2, endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        path.addLine(to: CGPoint(x: 0, y: bounds.height))
        path.close()

        maskLayer.path = path.cgPath
        ivContent.layer.mask = maskLayer
    }
}

