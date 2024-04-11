//
//  TWAlertView_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

enum TWAlertButtonStyle_MTW {
    case plain,
         desctructive
    
    var foregroundColor: UIColor {
        self == .plain
        ? TWColors_MTW.contentCellForeground
        : TWColors_MTW.deleteButtonForeground
    }
}

struct TWAlertButton_MTW {
    let title: String
    let style: TWAlertButtonStyle_MTW
    let handler: (() -> Void)?
    
    init(title: String,
         style: TWAlertButtonStyle_MTW = .plain,
         handler: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    
    static let defaultBtn = TWAlertButton_MTW(title: NSLocalizedString("Text33ID",comment: ""))
    
    static func cancel_MTW(handler: @escaping () -> Void) -> TWAlertButton_MTW {
        .init(title: NSLocalizedString("Text34ID", comment: ""), handler: handler)
    }
}

final class TWAlertView_MTW: TWBaseView_MTW {
    
    var didSelect: ((_ leading: Bool) -> Void)?
    
    private let lblTitle = UILabel()
    private let lblMessage = UILabel()
    private let svContent = UIStackView()
    private let svActions = UIStackView()
    
    override var cornerRadius: CGFloat {
        adjustedRect.height / 12.0
    }
    
    override func commonInit_MTW() {
        super.commonInit_MTW()
        
        configureSubviews_MTW()
        makeLayout()
    }
    
    override var adjustedAccentRect: CGRect {
        .init(x: cornerRadius + adjustment / 2,
              y: adjustment,
              width: cornerRadius,
              height: cornerRadius)
    }
    
}

// MARK: - Public API

extension TWAlertView_MTW {
    
    func configure(title: String,
                   message: String,
                   leadingButton: TWAlertButton_MTW = .defaultBtn,
                   trailingButton: TWAlertButton_MTW? = nil) {
        
        configure(title: title)
        configure(message: message)
        
        let leadingBtn = UIButton
            .configured(with: leadingButton.title,
                        titleColor: leadingButton.style.foregroundColor)
        leadingBtn.addTarget(self,
                             action: #selector(leadingAction),
                             for: .touchUpInside)
        svActions.addArrangedSubview(leadingBtn)
        
        if let trailingButton {
            let trailingBtn = UIButton
                .configured(with: trailingButton.title,
                            titleColor: trailingButton.style.foregroundColor)
            trailingBtn.addTarget(self,
                                 action: #selector(trailingAction),
                                 for: .touchUpInside)
            svActions.addArrangedSubview(trailingBtn)
        }
    }
    
    func configure(message localizedString: String) {
        lblMessage.attributedText = TWAttributtedStrings_MTW
            .alertViewMessageAttrString(with: localizedString,
                                        foregroundColor: TWColors_MTW
                .alertMessageForeground)
    }
    
}

// MARK: - Private API

private extension TWAlertView_MTW {
    
    func configure(title localizedString: String) {
        lblTitle.attributedText = TWAttributtedStrings_MTW
            .alertViewTitleAttrString(with: localizedString,
                                      foregroundColor: TWColors_MTW
                .alertTitleForeground)
    }
    
    func configureSubviews_MTW() {
        lblTitle.adjustsFontSizeToFitWidth = true
        
        lblMessage.numberOfLines = .zero
        lblMessage.adjustsFontSizeToFitWidth = true
        
        svContent.axis = .vertical
        svContent.spacing = .zero
        svContent.alignment = .fill
        svContent.distribution = .fillEqually
        
        svContent.addArrangedSubview(lblTitle)
        svContent.addArrangedSubview(lblMessage)
        
        addSubview(svContent)
        
        svActions.axis = .horizontal
        svActions.spacing = .zero
        svActions.alignment = .fill
        svActions.distribution = .fillEqually
        
        addSubview(svActions)
    }
    
    func makeLayout() {
        svContent.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12.0)
            $0.leading.equalToSuperview().offset(12.0)
            $0.trailing.equalToSuperview().inset(12.0)
        }
        
        svActions.snp.makeConstraints {
            $0.top.equalTo(svContent.snp.bottom)
            $0.bottom.equalToSuperview().inset(24.0)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.15)
        }
    }
    
    @objc func leadingAction() { didSelect?(true) }
    
    @objc func trailingAction() { didSelect?(false) }
    
}
