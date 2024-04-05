//
//  TWViewController_MTW+Extensions.swift
//  template
//
//  Created by Systems
//

import UIKit

typealias TWViewController_MTW = UIViewController

extension TWViewController_MTW {
    
    class func loadFromNib() -> Self {
        .init(nibName: String(describing: Self.self), bundle: .main)
    }
    
}
