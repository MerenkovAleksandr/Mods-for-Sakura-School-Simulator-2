//
//  TWContentCollectionViewCell_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

class TWContentCollectionViewCell_MTW: TWBaseCollectionViewCell_MTW {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var ivContent: TWImageView_MTW!
    @IBOutlet var vBubble: TWBubbleView_MTW!
    @IBOutlet var ivFavourite: UIImageView!
    
    var didCallSubMenu: ((_ sender: UIView,
                          _ character: TWCharacterPreview_MTW) -> Void)?
    var didUpdate: (() -> Void)?
    
    private(set) var id: UUID?
    private(set) var isFavourite: Bool = false
    
    override var adjustedShadowRect: CGRect {
        .init(x: adjustment,
              y: adjustment,
              width: bounds.width - sizeAdjustment,
              height: bounds.height - sizeAdjustment)
    }
    
    override var shadowBackgroundColor: UIColor {
        TWColors_MTW.contentSelectorCellBackground
    }
    
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
        TWColors_MTW.contentSelectorCellShadow
    }

    override var adjustedRect: CGRect {
        .init(x: 5.0,
              y: 7.0,
              width: bounds.width - 6,
              height: bounds.height - 6)
    }
    
    override func commonInit_MTW() {
        super.commonInit_MTW()
         
        backgroundView = .clearView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ivContent.setCornerRadius_MTW(8.0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ivContent.hideNewCharacter()
    }

}

// MARK: - Public API

extension TWContentCollectionViewCell_MTW {
    
    func configure_MTW(with item: TWContentModel_MTW) {
        id = item.id
        isFavourite = item.attributes?.favourite ?? false
        
        configureImageView(item: item)
        configureTitleLabel(localizedTitle: item.content.displayName)
        configureAttributes(item.attributes)
    }
    
    func configure(with character: TWCharacterPreview_MTW? = nil) {
        ivFavourite.hide_MTW()
        lblTitle.hide_MTW()
        
        if let character {
            ivContent.image = character.image
            ivContent.backgroundColor = TWColors_MTW.contentSelectorCellBackground
            vBubble.makeInteractive { [weak self] in
                guard let self else { return }
                self.didCallSubMenu?(self.vBubble, character) }
        } else {
            ivContent.backgroundColor = TWColors_MTW.imageViewEmptyBackground
            vBubble.hide_MTW()
            ivContent.createNewCharacter()
        }
    }
    
}


// MARK: - Private API

private extension TWContentCollectionViewCell_MTW {
    
    var favouriteToggleImage: UIImage {
        isFavourite ? #imageLiteral(resourceName: "favourite_selected") : #imageLiteral(resourceName: "favourite")
    }
    
    var foregroundColor: UIColor {
        TWColors_MTW.contentCellForeground
    }
    
    func configureImageView(item: TWContentModel_MTW) {
        ivContent.setCornerRadius_MTW(8.0)
        ivContent.configure(with: item.content.image)
    }
    
    func configureTitleLabel(localizedTitle: String?) {
        if let localizedTitle {
            lblTitle.show_MTW()
            lblTitle.attributedText = TWAttributtedStrings_MTW
                .contentCellTitleAttrString(with: localizedTitle,
                                            foregroundColor: foregroundColor)
            lblTitle.adjustsFontSizeToFitWidth = false
            lblTitle.sizeToFit()
            return
        }
        lblTitle.hide_MTW()
        lblTitle.attributedText = nil
    }
    
    func configureAttributes(_ attributes: TWContentAttributes_MTW?) {
        vBubble.visibility(isVisible: attributes?.new ?? false)
        configureFavouriteImageView()
    }
    
    func configureIsFavouriteTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didToggleIsFavourite))
        
        ivFavourite.isUserInteractionEnabled = true
        ivFavourite.addGestureRecognizer(tapGesture)
    }
    
    func configureFavouriteImageView() {
        ivFavourite.show_MTW()
        ivFavourite.image = favouriteToggleImage
        ivFavourite.backgroundColor = TWColors_MTW.contentSelectorCellBackground
        
        configureIsFavouriteTap()
    }
    
    @objc func didToggleIsFavourite() {
        guard let id else { return }
        
        let fetchRequest = ContentEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        
        let managedContext = TWDBManager_MTW.shared.contentManager.managedContext
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if let entity = result.first {
                entity.contentStared = !isFavourite
                
                try managedContext.save()
                
                isFavourite.toggle()
                didUpdate?()
                
                DispatchQueue.main.async {
                    self.configureFavouriteImageView()
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

}
