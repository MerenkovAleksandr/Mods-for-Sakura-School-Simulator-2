//
//  :: MARK- - TWRecomendationCollectionViewCell_MTW  final class TWRecomendationCollectionViewCell_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWRecomendationCollectionViewCell_MTW: UICollectionViewCell {
    
    var imageView = TWImageView_MTW(frame: .zero)
    
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
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8.0
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = TWColors_MTW.bubbleViewForegroundColor.cgColor
        
        makeLayout()
    }
    
    func makeLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
