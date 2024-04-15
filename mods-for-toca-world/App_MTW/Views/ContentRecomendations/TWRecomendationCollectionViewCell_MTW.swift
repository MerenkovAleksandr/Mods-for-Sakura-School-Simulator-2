//
//  :: MARK- - TWRecomendationCollectionViewCell_MTW  final class TWRecomendationCollectionViewCell_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWRecomendationCollectionViewCell_MTW: TWBaseCollectionViewCell_MTW {
    
    var imageView = TWImageView_MTW(frame: .zero)
    var vBubble = TWBubbleView_MTW()
    
    var radius: CGFloat = 18.0
    
    var favouriteView: UIView = {
        let view = UIView()
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "favourite")
        view.addSubview(iv)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        iv.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 14).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 18).isActive = true
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        view.backgroundColor = TWColors_MTW.contentSelectorCellBackground
        return view
    }()
    
    override var cornerRadius: CGFloat {
        radius
    }
    
    override var adjustedRect: CGRect {
        .init(x: 3,
              y: 3,
              width: bounds.width - 3,
              height: bounds.height - 3)
    }
    
    override var adjustedShadowRect: CGRect {
        .init(x: 0,
              y: 0,
              width: bounds.width - 5,
              height: bounds.height - 5)
    }
    
    override var backgroundFillColor: UIColor {
        TWColors_MTW.contentSelectorCellShadow
    }
    
    override var shadowBackgroundColor: UIColor {
        TWColors_MTW.contentSelectorCellBackground
    }
    
    
    override func commonInit_MTW() {
        backgroundColor = .clear
        
        addSubview(imageView)
        
        layer.cornerRadius = 8.0
        clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = radius
        
        addSubview(favouriteView)
        
        favouriteView.translatesAutoresizingMaskIntoConstraints = false
        favouriteView.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        favouriteView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        favouriteView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        favouriteView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(vBubble)
        vBubble.translatesAutoresizingMaskIntoConstraints = false
        vBubble.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -5).isActive = true
        vBubble.topAnchor.constraint(equalTo: topAnchor, constant: -5).isActive = true
        vBubble.heightAnchor.constraint(equalToConstant: 44).isActive = true
        vBubble.widthAnchor.constraint(equalToConstant: 54).isActive = true
        vBubble.isHidden = true
        
        applyMask()
        makeLayout()
    }
}

// MARK: - Private API

private extension TWRecomendationCollectionViewCell_MTW {
    
    func makeLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12.0)
        }
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
        imageView.layer.mask = maskLayer
    }
}
