//
//  TWColorPicker_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWColorPicker_MTW: UIView {
    
    var didSelectColor: ((TWCharacterColor_MTW) -> Void)?

    @IBOutlet var view: UIView!
    
    @IBOutlet private var vColorSlider: TWColorSlider_MTW!
    
    private(set) var selectedColor: UIColor? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit_MTW()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit_MTW()
    }
    
} 

// MARK: - Public API

extension TWColorPicker_MTW {
    
    func configure_MTW(color: TWCharacterColor_MTW) {
        vColorSlider.setColor_MTW(color.color)
        vColorSlider.didSelectColor = { [weak self] color in
            self?.didSelectColor?(color)
        }
    }
    
}

// MARK: - Private API

private extension TWColorPicker_MTW {
    
    var foregroundColor: UIColor {
        TWColors_MTW.navigationBarForeground
    }
    
    func commonInit_MTW() {
        backgroundColor = .clear
        
        loadViewFromNib_MTW()
    }
    
    func loadViewFromNib_MTW() {
        view = loadFromNib_MTW(in: bounds)
        view.backgroundColor = .clear
        addSubview(view)
    }
    
}
