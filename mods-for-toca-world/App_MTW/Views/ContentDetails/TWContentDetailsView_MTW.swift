//
//  TWContentDetailsView_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWContentDetailsView_MTW: TWBaseView_MTW {
    
    @IBOutlet var view: UIView!
    
    @IBOutlet private var lblTitle: UILabel!
    @IBOutlet private var lblDescription: UILabel!
    @IBOutlet private var ivContent: TWImageView_MTW!
    @IBOutlet private var vBubble: TWBubbleView_MTW!
    @IBOutlet private var ivFavourite: UIImageView!
    
    var didUpdate: (() -> Void)?
    
    private(set) var id: UUID?
    private(set) var isFavourite: Bool = false
    
    var image: UIImage? { ivContent.image }
    
    override var cornerRadius: CGFloat {
        ivContent.bounds.height / 16
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ivContent.setCornerRadius_MTW(16.0)
    }
    
    override func draw(_ rect: CGRect) {
        drawBackgroundLayer_MTW()
    }
    
    override func commonInit_MTW() {
        super.commonInit_MTW()
        
        loadFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didToggleIsFavourite))
        
        ivFavourite.isUserInteractionEnabled = true
        ivFavourite.addGestureRecognizer(tapGesture)
    }
    
}

// MARK: - Public API

extension TWContentDetailsView_MTW {
    
    func configure_MTW(with item: TWContentModel_MTW) {
        configureImageView(item: item)
        
        if item.contentType == .guide {
            vBubble.hide_MTW()
            configureContentTitle(localizedString: item.content.displayName)
            ivFavourite.hide_MTW()
        } else {
            vBubble.visibility(isVisible: item.attributes?.new ?? false)
            lblTitle.hide_MTW()
            id = item.id
            isFavourite = item.attributes?.favourite ?? false
            ivFavourite.show_MTW()
            configureFavouriteImageView()
        }
        
        configureContentDescription(localizedString: item.content.description)
    }
    
}

// MARK: - Private API

private extension TWContentDetailsView_MTW {
    
    var foregroundColor: UIColor {
        TWColors_MTW.contentDetailsViewForeground
    }
    
    var favouriteToggleImage: UIImage {
        isFavourite ? #imageLiteral(resourceName: "favourite_selected") : #imageLiteral(resourceName: "favourite")
    }
    
    func loadFromNib() {
        view = loadFromNib_MTW(in: bounds)
        view.backgroundColor = .clear
        addSubview(view)
    }
    
    func configureImageView(item: TWContentModel_MTW) {
        ivContent.image = item.content.image
        ivContent.setCornerRadius_MTW(8.0)
    }
    
    func configureContentTitle(localizedString: String?) {
        if let localizedString {
            lblTitle.show_MTW()
            lblTitle.attributedText = TWAttributtedStrings_MTW
                .contentDetailTitleAttrString(with: localizedString,
                                              foregroundColor: foregroundColor)
            lblTitle.adjustsFontSizeToFitWidth = false
            return
        }
        lblTitle.hide_MTW()
        lblTitle.attributedText = nil
    }
    
    func configureContentDescription(localizedString: String?) {
        if let localizedString {
            lblDescription.show_MTW()
            lblDescription.attributedText = TWAttributtedStrings_MTW
                .contentCellTitleAttrString(with: localizedString,
                                            foregroundColor: foregroundColor)
            lblDescription.adjustsFontSizeToFitWidth = false
            return
        }
        lblDescription.hide_MTW()
        lblDescription.attributedText = nil
    }
    
    func configureFavouriteImageView() {
        ivFavourite.image = favouriteToggleImage
    }
    
    @objc func didToggleIsFavourite() {
        guard let id else { return }
        
        TWDBManager_MTW.shared.contentManager.update(modelId: id,
                                                     isFavourite: isFavourite)
        isFavourite.toggle()
        didUpdate?()
        configureFavouriteImageView()
    }
    
}
