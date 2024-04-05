//
//  TWNavigationBarView_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

protocol TWNavigationBarDelegate_MTW: AnyObject {
    func didTapLeadingBarBtn()
    func didTapTrailingBarBtn()
}

final class TWNavigationBarView_MTW: TWBaseView_MTW {
    
    weak var delegate: TWNavigationBarDelegate_MTW?
    
    @IBOutlet var view: UIView!
    
    @IBOutlet private var lblTitle: UILabel!
    @IBOutlet private var btnLeading: UIButton!
    @IBOutlet private var btnTrailing: UIButton!
    
    override var gradientColors: [CGColor] {[
        TWColors_MTW.navigationBarGradientStart.cgColor,
        TWColors_MTW.navigationBarGradientEnd.cgColor
    ]}
    
    override var backgroundFillColor: UIColor {
        TWColors_MTW.navigationBarBackground
    }
    
    override var adjustedAccentRect: CGRect {
        let size = cornerRadius / 2
        
        return .init(x: cornerRadius - adjustment,
                     y: adjustment,
                     width: size,
                     height: size)
    }
    
    override func commonInit_MTW() {
        super.commonInit_MTW()
        
        loadViewFromNib_MTW()
        configureSubviews_MTW()
    }
    
    @IBAction func leadingBarBtnAction(_ sender: Any) {
        delegate?.didTapLeadingBarBtn()
    }
    
    
    @IBAction func trailingBarBtnAction(_ sender: Any) {
        delegate?.didTapTrailingBarBtn()
    }
    
}

// MARK: - Public API

extension TWNavigationBarView_MTW {
    
    func configure_MTW(localizedTitle title: String,
                   leadingIcon: UIImage? = nil,
                   trailingIcon: UIImage? = nil) {
        configure_MTW(localizedTitle: title)
        configure(barButton: btnLeading, with: leadingIcon)
        configure(barButton: btnTrailing, with: trailingIcon)
    }
    
    func update_MTW(trailingItem image: UIImage? = nil) {
       configure(barButton: btnTrailing, with: image)
    }
    
    func update_MTW(leadingItem image: UIImage? = nil) {
        configure(barButton: btnLeading, with: image)
    }
    
}

// MARK: - Private API

private extension TWNavigationBarView_MTW {
    
    func loadViewFromNib_MTW() {
        view = loadFromNib_MTW(in: bounds)
        view.backgroundColor = .clear
        addSubview(view)
    }
    
    func configureSubviews_MTW() {
        [btnLeading, btnTrailing].forEach { configure(barButton: $0, with: nil) }
    }
    
    func configure_MTW(localizedTitle: String) {
        lblTitle.attributedText = TWAttributtedStrings_MTW
            .barAttrString(with: localizedTitle,
                           foregroundColor: TWColors_MTW.navigationBarForeground)
        lblTitle.sizeToFit()
    }
    
    func configure(barButton: UIButton, with image: UIImage?) {
        guard let image else {
            barButton.hide_MTW()
            return
        }
        
        barButton.setImage(image, for: .normal)
        barButton.imageView?.contentMode = .scaleAspectFit
        barButton.tintColor = TWColors_MTW.navigationBarForeground
        barButton.show_MTW()
    }
    
}
