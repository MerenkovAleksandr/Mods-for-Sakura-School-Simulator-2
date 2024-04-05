//
//  TWSubMenuView_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWSubMenu_MTW: TWBaseView_MTW {
    
    enum TWAction_MTW { case edit,delete }
    
    var didPerform: ((_ action: TWSubMenu_MTW.TWAction_MTW) -> Void)?
    
    private var editBtn: UIButton = {
        .configured(with: NSLocalizedString("Text61ID", comment: ""),
                    titleColor: TWColors_MTW.navigationBarForeground)
    }()
    
    private var deleteBtn: UIButton = {
        .configured(with: NSLocalizedString("Text62ID", comment: ""),
                    titleColor: TWColors_MTW.deleteButtonForeground)
    }()
    
    override var cornerRadius: CGFloat {
        bounds.height / 12
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
        
        backgroundColor = .clear
        
        configureStackView()
        configureEditButton()
        configuredDeleteButton()
    }
    
    override func draw(_ rect: CGRect) {
        drawBackgroundLayer_MTW()
    }

}


// MARK: - Private API

private extension TWSubMenu_MTW {
    
    func configureEditButton() {
        editBtn.addTarget(self,
                          action: #selector(editAction_MTW),
                          for: .touchUpInside)
    }
    
    func configuredDeleteButton() {
        deleteBtn.addTarget(self,
                          action: #selector(deleteAction_MTW),
                          for: .touchUpInside)
    }

    func configureStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = .zero
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        [editBtn, deleteBtn].forEach  {
            $0.contentHorizontalAlignment = .leading
            stackView.addArrangedSubview($0)
        }
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
            $0.height.width.equalToSuperview().multipliedBy(0.7)
        }
    }
    
    @objc func editAction_MTW() { hide_MTW(toPerform: .edit) }
    
    @objc func deleteAction_MTW() { hide_MTW(toPerform: .delete) }
    
    func hide_MTW(toPerform action: TWAction_MTW) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = .zero
        }, completion: { _ in
            self.didPerform?(action)
        })
    }
    
}
