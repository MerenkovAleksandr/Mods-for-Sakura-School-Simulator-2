//
//  TWBaseController_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

class TWBaseController_MTW: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultBackground()
    }
    
    deinit { print("DEINIT - \(String(describing: Self.self))") }
    
}

// MARK: - Private API

private extension TWBaseController_MTW {
    
    func setDefaultBackground() {
        let defaultBackground = UIImageView(image: #imageLiteral(resourceName: "bg_default"))
        
        view.insertSubview(defaultBackground, at: .zero)
        
        defaultBackground.contentMode = .scaleAspectFill
        defaultBackground.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
}
