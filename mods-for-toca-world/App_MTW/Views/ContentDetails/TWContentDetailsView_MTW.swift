//
//  TWContentDetailsView_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

protocol TWContentDetailsDelegate_MTW: AnyObject {
    func didTapActionButton()
}

final class TWContentDetailsView_MTW: TWBaseView_MTW {
    
    @IBOutlet var view: UIView!
    
    @IBOutlet private var lblTitle: UILabel!
    @IBOutlet private var lblDescription: UILabel!
    @IBOutlet private var ivContent: TWImageView_MTW!
    @IBOutlet private var vBubble: TWBubbleView_MTW!
    @IBOutlet private var ivFavourite: UIImageView!
    @IBOutlet private var btnDownload: TWBaseButton_MTW!
    @IBOutlet private var btnShare: TWBaseButton_MTW!
    
    weak var delegate: TWContentDetailsDelegate_MTW?
    
    var didUpdate: (() -> Void)?
    
    private(set) var id: UUID?
    private(set) var isFavourite: Bool = false
    
    var image: UIImage? { ivContent.image }
    
    @IBAction func btnAction(_ sender: Any) {
        btnDownload.animationLoading()
        animationImage()
        delegate?.didTapActionButton()
    }
    
    override var cornerRadius: CGFloat {
        ivContent.bounds.height / 16
    }
    
    override var adjustedShadowRect: CGRect {
        .init(x: 0,
              y: 0,
              width: bounds.width - 7,
              height: bounds.height - 7)
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
    
    override var shadowBackgroundColor: UIColor {
        TWColors_MTW.contentSelectorCellBackground
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ivContent.setCornerRadius_MTW(16.0)
    }
    
    override func draw(_ rect: CGRect) {
        drawShadowLayer_MTW()
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
        configureButtons()
        
        if item.contentType == .guide {
            vBubble.hide_MTW()
            configureContentTitle(localizedString: item.content.displayName)
            ivFavourite.hide_MTW()
            btnDownload.hide_MTW()
            btnShare.hide_MTW()
            lblDescription.snp.makeConstraints {
                $0.bottom.equalToSuperview()
            }
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
    
    func stopAnimation() {
        btnDownload.stopAminationLoading()
        guard let image = UIImage(named: "icon_download") else { return }
        btnDownload.setImage(image, for: .normal)
    }
    
}

// MARK: - Private API

private extension TWContentDetailsView_MTW {
    
    var foregroundColor: UIColor {
        TWColors_MTW.contentCellForeground
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
        guard item.contentType != .guide else { return }
        applyMask()
    }
    
    func configureContentTitle(localizedString: String?) {
        if let localizedString {
            lblTitle.show_MTW()
            lblTitle.attributedText = TWAttributtedStrings_MTW
                .contentDetailTitleAttrString(with: localizedString,
                                              foregroundColor: TWColors_MTW.contentDetailsTitleForeground)
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
                .contentDetailsCellTitleAttrString(with: localizedString,
                                            foregroundColor: foregroundColor)
            lblDescription.adjustsFontSizeToFitWidth = false
            return
        }
        lblDescription.hide_MTW()
        lblDescription.attributedText = nil
    }
    
    func configureButtons() {
        btnDownload.setAttributedTitle(TWAttributtedStrings_MTW
            .barAttrString(with: "",
                           foregroundColor: TWColors_MTW.buttonForegroundColor),
                                       for: .normal)
        
        btnDownload.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.width.equalTo(94)
            $0.height.equalTo(74)
        }
        
        let localizedTitle = NSLocalizedString("Text88ID", comment: "")
        
        btnShare.setAttributedTitle(TWAttributtedStrings_MTW
            .barAttrString(with: localizedTitle,
                           foregroundColor: TWColors_MTW.buttonForegroundColor),
                                       for: .normal)
        
        btnShare.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(btnDownload.snp.leading).offset(-10.0)
            $0.height.equalTo(74)
        }
        
        guard let image = UIImage(named: "icon_download") else { return }
        btnDownload.setImage(image, for: .normal)
    }
    
    func animationImage() {
        guard let image = UIImage(named: "icon_indicator") else { return }
        btnDownload.setImage(image, for: .normal)
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
