//
//  TWBubbleView_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWBubbleView_MTW: UIView {
    
    private let offset: CGFloat = 4.0
    private let foregroundColor = TWColors_MTW.bubbleViewTextColor
    private let localizedTitle = NSLocalizedString("Text48ID",comment: "").uppercased()
    private var ivContent = UIImageView()
    private var lblTitle = UILabel()
    
    private var didTapButton: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit_MTW_MTW()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit_MTW_MTW()
    }
    
}

// MARK: - Public API

extension TWBubbleView_MTW {
    
    func makeInteractive(didTapButton: @escaping () -> Void) {
        show_MTW()
        lblTitle.attributedText = TWAttributtedStrings_MTW
            .bubbleButtonDotsTitleAttrString()
        lblTitle.adjustsFontSizeToFitWidth = false
        self.didTapButton = didTapButton
        
        configureActionButton()
    }
    
}

// MARK: - Private API

private extension TWBubbleView_MTW {
    
    func commonInit_MTW_MTW() {
        backgroundColor = .clear
        
        configureImageView_MTW()
        configureTitleLabel()
        
        
        layoutViews()
    }
    
    func layoutViews() {
        lblTitle.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().offset(-offset)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(offset * 3)
        }
        
        ivContent.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(-offset)
            $0.top.equalToSuperview().offset(-offset)
            $0.width.equalTo(70)
            $0.height.equalTo(27)
        }
    }
    
    func configureTitleLabel() {
        lblTitle.adjustsFontSizeToFitWidth = true
        lblTitle.lineBreakMode = .byTruncatingTail
        lblTitle.numberOfLines = 1
        
        lblTitle.attributedText = TWAttributtedStrings_MTW
            .barAttrString(with: localizedTitle,
                           foregroundColor: foregroundColor)
        
        addSubview(lblTitle)
    }
    
    func configureImageView_MTW() {
        ivContent.contentMode = .scaleAspectFit
        ivContent.image = #imageLiteral(resourceName: "icon_bubble")
        
        addSubview(ivContent)
    }
    
    func configureActionButton() {
        let button = UIButton(type: .system)
        
        button.setTitle(nil, for: .normal)
        button.addTarget(self, action: #selector(buttonAction_MTW), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonAction_MTW), for: .touchUpOutside)
        
        addSubview(button)
        
        button.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    @objc func buttonAction_MTW() { didTapButton?() }
    
}
