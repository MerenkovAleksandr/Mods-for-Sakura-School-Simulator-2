//
//  TWApperance_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWApperance_MTW {
    
    class func setup() {
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorStyle = .none
        
        UITableViewCell.appearance().backgroundView = nil
        UITableViewCell.appearance().backgroundColor = .clear
        
        UICollectionView.appearance().backgroundView = nil
        UICollectionView.appearance().backgroundColor = .clear
    }
    
}
