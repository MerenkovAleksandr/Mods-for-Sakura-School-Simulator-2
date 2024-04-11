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
    
    private var gradientLayerEdit = CAGradientLayer()
    
    private var editBtn: UIButton = {
        .configured(with: NSLocalizedString("Text61ID", comment: ""),
                    titleColor: TWColors_MTW.contentCellForeground)
    }()
    
    private var deleteBtn: UIButton = {
        .configured(with: NSLocalizedString("Text62ID", comment: ""),
                    titleColor: TWColors_MTW.contentCellForeground)
    }()
    
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
        TWColors_MTW.buttonDeleteBackground
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
    
    override func drawBackgroundLayer_MTW() {
        let pathDelete = backgroundLayerPathForDelete()
        let maskDelete = CAShapeLayer()
        maskDelete.path = pathDelete.cgPath
        maskDelete.lineWidth = borderWidth
        maskDelete.strokeColor = UIColor.black.cgColor
        maskDelete.fillColor = nil
        
        let pathEdit = backgroundLayerPathForEdit()
        let maskEdit = CAShapeLayer()
        maskEdit.path = pathEdit.cgPath
        maskEdit.lineWidth = borderWidth
        maskEdit.strokeColor = UIColor.black.cgColor
        maskEdit.fillColor = nil
        
        gradientLayer.removeFromSuperlayer()
        gradientLayer = {
            let layer = CAGradientLayer()
            
            layer.frame = bounds
            layer.colors = gradientColors
            layer.startPoint = gradientStartPoint
            layer.endPoint = gradientEndPoint
            layer.mask = maskDelete
            
            return layer
        }()
        
        gradientLayerEdit.removeFromSuperlayer()

        gradientLayerEdit = {
            let layer = CAGradientLayer()
            
            layer.frame = bounds
            layer.colors = gradientColors
            layer.startPoint = gradientStartPoint
            layer.endPoint = gradientEndPoint
            layer.mask = maskEdit
            
            return layer
        }()
        
        layer.insertSublayer(gradientLayerEdit, at: 1)
        layer.insertSublayer(gradientLayer, at: 0)
        
        backgroundFillColor.setFill()
        
        pathDelete.fill()
        TWColors_MTW.buttonEditBackground.setFill()
        pathEdit.fill()
    }

}


// MARK: - Private API

private extension TWSubMenu_MTW {
    
    func configureEditButton() {
        editBtn.addTarget(self,
                          action: #selector(editAction_MTW),
                          for: .touchUpInside)
        editBtn.backgroundColor = TWColors_MTW.buttonEditBackground
    }
    
    func configuredDeleteButton() {
        deleteBtn.addTarget(self,
                          action: #selector(deleteAction_MTW),
                          for: .touchUpInside)
        deleteBtn.backgroundColor = TWColors_MTW.buttonDeleteBackground
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
    
    func backgroundLayerPathForDelete() -> UIBezierPath {
        let radius = bounds.height / 2.0
        let centerX = bounds.width / 2.0
        let centerY = bounds.height / 2.0
        let path = UIBezierPath()
        path.move(to: CGPoint(x: centerX + radius, y: centerY))
        path.addArc(withCenter: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: 0, endAngle: .pi, clockwise: true)
        path.close()
        return path
    }
    
    func backgroundLayerPathForEdit() -> UIBezierPath {
        let radius = bounds.height / 2.0
        let centerX = bounds.width / 2.0
        let centerY = bounds.height / 2.0
        let path = UIBezierPath()
        path.move(to: CGPoint(x: centerX + radius, y: centerY))
        path.addArc(withCenter: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: .pi, endAngle: 0, clockwise: true)
        path.close()
        return path
    }
    
}
