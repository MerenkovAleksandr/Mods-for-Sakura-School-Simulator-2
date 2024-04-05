//
//  TWImageView_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWImageView_MTW: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit_MTW()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit_MTW()
    }
    
    private var indicator : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .medium
        view.color = TWColors_MTW.navigationBarBackground
        view.hidesWhenStopped = true
        return view
    }()
    
    private var ivNewCharacter: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "icon_editor_new"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
}

// MARK: - Public API

extension TWImageView_MTW {
    
    func setCornerRadius_MTW(_ divider: CGFloat = 4.0) {
        layer.cornerRadius = bounds.height / divider
    }
    
    func configure(with image: UIImage?) {
        ivNewCharacter.hide_MTW()
        
        if let image {
            self.image = image
            indicator.stopAnimating()
            return
        }
        
        indicator.startAnimating()
    }
    
    func createNewCharacter() {
        image = nil
        ivNewCharacter.show_MTW()
    }
    
    func hideNewCharacter() {
        ivNewCharacter.hide_MTW()
        image = nil
    }
}

// MARK: - Private API

private extension TWImageView_MTW {
    
    func commonInit_MTW() {
        addSubview(indicator)
        addSubview(ivNewCharacter)
        contentMode = .scaleAspectFill
        backgroundColor = TWColors_MTW.navigationBarForeground
        tintColor = TWColors_MTW.navigationBarBackground
        
        makeLayout()
        
        indicator.hide_MTW()
        ivNewCharacter.hide_MTW()
    }
    
    func makeLayout() {
        indicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        ivNewCharacter.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalToSuperview().dividedBy(5.0)
        }
    }

}
