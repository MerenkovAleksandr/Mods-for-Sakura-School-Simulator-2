//
//  TWCollectionViewCell_MTW+Extensions.swift
//  template
//
//  Created by Systems
//

import UIKit

typealias TWCollectionViewCell_MTW = UICollectionViewCell

extension TWCollectionViewCell_MTW {
    
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
    
    static var nib: UINib {
        .init(nibName: reuseIdentifier, bundle: .main)
    }
    
}
