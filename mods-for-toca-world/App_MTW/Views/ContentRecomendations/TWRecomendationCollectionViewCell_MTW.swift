//
//  :: MARK- - TWRecomendationCollectionViewCell_MTW  final class TWRecomendationCollectionViewCell_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWRecomendationCollectionViewCell_MTW: UICollectionViewCell {
    
    var imageView = TWImageView_MTW(frame: .zero)
    var vBubble = TWBubbleView_MTW()
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit_MTW()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit_MTW()
    }
    
}

// MARK: - Private API

private extension TWRecomendationCollectionViewCell_MTW {
    
    func commonInit_MTW() {
        backgroundColor = .clear
        
        addSubview(imageView)
        
        layer.cornerRadius = 8.0
        clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18.0
        imageView.layer.borderWidth = 10.0
        imageView.layer.borderColor = TWColors_MTW.contentSelectorCellBackground.cgColor
        
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
        
        addShadow()
        makeLayout()
    }
    
    func addShadow() {
            layer.masksToBounds = false
            layer.shadowColor = TWColors_MTW.contentSelectorCellShadow.cgColor
            layer.shadowOpacity = 0.8
            layer.shadowOffset = CGSize(width: 2, height: 2)
            layer.shadowRadius = 3.0
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        }
    
    func makeLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
