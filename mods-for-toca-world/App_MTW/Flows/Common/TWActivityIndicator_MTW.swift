//
//  TWActivityIndicator_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWActivityIndicator_MTW: UIView {
    
    let kRotationAnimationKey = "TWActivityIndicator_MTW.RotationKey"
    
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = #imageLiteral(resourceName: "icon_indicator")
        
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
    
    func commonInit_MTW() {
        backgroundColor = .clear
        addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func rotateView() {
        if imageView.layer.animation(forKey: kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float(.pi * 2.0)
            rotationAnimation.duration = 1.0
            rotationAnimation.repeatCount = .infinity
            
            imageView.layer.add(rotationAnimation,
                                forKey: kRotationAnimationKey)
        }
    }
    
}
