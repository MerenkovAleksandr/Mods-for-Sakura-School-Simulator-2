//
//  TWView_MTW+Extensions.swift
//  template
//
//  Created by Systems
//

import UIKit

typealias TWView_MTW = UIView

extension TWView_MTW {
    
    class var clearView: Self {
        let view = Self()
        
        view.backgroundColor = .clear
        
        return view
    }
    
    var iPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    func loadFromNib_MTW(in frame: CGRect) -> UIView {
        let nibName = String(describing: Self.self)
        guard let view = UINib(nibName: nibName, bundle: .main)
            .instantiate(withOwner: self)
            .first as? UIView
        else { fatalError("Unable to load \(nibName).xib!") }
        
        view.frame = frame
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return view
    }
    
    func hide_MTW() {
        if !isHidden { update(isHidden: true) }
    }
    
    func show_MTW() {
        if isHidden { update(isHidden: false) }
    }
    
    func visibility(isVisible: Bool) {
        isVisible ? show_MTW() : hide_MTW()
    }
    
}

// MARK: - Private API

private extension UIView {
    
    func update(isHidden value: Bool) {
        isHidden = value
        isUserInteractionEnabled = !value
    }
    
}
