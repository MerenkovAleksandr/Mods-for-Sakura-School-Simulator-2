//
//  TWCharacterEditorCollectionViewCell_MTW.swift
//  mods-for-toca-world
//
//  Created by Александр Меренков on 09.04.2024.
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
    
    override var gradientColors: [CGColor] {[
        TWColors_MTW.contentSelectorCellGradientStart.cgColor,
        TWColors_MTW.contentSelectorCellGradientEnd.cgColor
    ]}
    
    override var gradientStartPoint: CGPoint {
        .zero
    }
    
    override var gradientEndPoint: CGPoint {
        .init(x: 1.0, y: 1.0)
    }
    
    override var backgroundFillColor: UIColor {
        TWColors_MTW.contentSelectorCellBackground
    }

    
    override func commonInit_MTW() {
        super.commonInit_MTW()
         
        backgroundView = .clearView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ivContent.setCornerRadius_MTW(8.0)
    }
    
    override func draw(_ rect: CGRect) {
        drawBackgroundLayer_MTW()
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
            vBubble.hide_MTW()
            ivContent.createNewCharacter()
        }
        vBubble.updateImageViewForEdit()
    }
    
}



