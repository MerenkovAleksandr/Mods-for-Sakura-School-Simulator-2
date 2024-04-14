//
//  TWPlainTextCollectionViewCell_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

class TWPlainTextCollectionViewCell_MTW: TWBaseCollectionViewCell_MTW {
    
    var opacity: CGFloat { isInactive ? 0.5 : 1.0 }
    
    private var ivPlayStatus = UIImageView()
    private var lblContentTitle = UILabel()
    private var indicator : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .medium
        view.color = TWColors_MTW.navigationBarBackground
        view.hidesWhenStopped = true
        return view
    }()
    
    private var isInactive: Bool = false
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        contentView.backgroundColor = .clear
        contentView.addSubview(ivPlayStatus)
        contentView.addSubview(lblContentTitle)
        contentView.addSubview(indicator)
        
        indicator.color = TWColors_MTW.navigationBarForeground
        
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        .init(x: 1.0, y: 1.0)
    }
    
    override var cornerRadius: CGFloat {
        adjustedRect.height / 3.5
    }
    
    override var backgroundFillColor: UIColor {
        drawSelected
        ? TWColors_MTW.contentSelectorCellSelectedBackground.withAlphaComponent(opacity)
        : TWColors_MTW.contentSelectorCellBackground.withAlphaComponent(opacity)
    }
    
    override var shadowBackgroundColor: UIColor {
        UIColor.orange
    }
    
    override func draw(_ rect: CGRect) {
        drawBackgroundLayer_MTW()
        
        if drawSelected {
            accentLayer.removeFromSuperlayer()
            return
        }
        
    }
    
}

// MARK: - Public API

extension TWPlainTextCollectionViewCell_MTW {
    
    func configure_MTW(with item: TWContentSelectorItem_MTW) {
        configureTitleLabel(with: item.localizedTitle)
        
        setNeedsDisplay()
    }
    
    func configure_MTW(with title: String, isLoading: Bool = false) {
        isInactive = isLoading

        configureImageView()
        
        configureTitleLabel(with: title)
        
        if isLoading {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
        
        setNeedsDisplay()
    }
    
}

// MARK: - Private API

private extension TWPlainTextCollectionViewCell_MTW {
    
    var drawSelected: Bool {
        isSelected || isHighlighted
    }
    
    var foregoundColor: UIColor {
        TWColors_MTW.soundCellForeground
    }
    
    var defaultGradientColors: [CGColor] {[
        TWColors_MTW.contentSelectorCellGradientStart.withAlphaComponent(opacity).cgColor,
        TWColors_MTW.contentSelectorCellGradientEnd.withAlphaComponent(opacity).cgColor
    ]}
    
    var selectedGradientColors: [CGColor] {[
        TWColors_MTW.contentSelectorCellSelectedGradientStart.withAlphaComponent(opacity).cgColor,
        TWColors_MTW.contentSelectorCellSelectedGradientEnd.withAlphaComponent(opacity).cgColor
    ]}
    
    func updateApperance() {
        updateTitleLabelAppearance()
        setNeedsDisplay()
    }
    
    func configureImageView() {
        ivPlayStatus.image = #imageLiteral(resourceName: "icon_play")
    }
    
    func configureTitleLabel(with title: String) {
        lblContentTitle.attributedText = TWAttributtedStrings_MTW
            .contentSelectorItemAttrString(with: title,
                                           foregroundColor: foregoundColor)
        lblContentTitle.textAlignment = .left
        lblContentTitle.sizeToFit()
    }
    
    func updateTitleLabelAppearance() {
        let title = lblContentTitle.attributedText?.string ?? ""
        configureTitleLabel(with: title)
    }
    
    func makeLayout() {
        ivPlayStatus.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10.0)
            $0.top.equalToSuperview().offset(8.0)
            $0.bottom.equalToSuperview().inset(8.0)
            $0.width.equalTo(62)
            $0.centerY.equalToSuperview()
        }
        
        lblContentTitle.snp.makeConstraints {
            $0.leading.equalTo(ivPlayStatus.snp.trailing).offset(10.0)
            $0.trailing.equalToSuperview().inset(24.0)
            $0.top.equalToSuperview().offset(16.0)
            $0.bottom.equalToSuperview().inset(16.0)
            $0.centerY.equalToSuperview()
        }
        
        indicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
