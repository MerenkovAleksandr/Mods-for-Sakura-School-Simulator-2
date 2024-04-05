//
//  TWAlertController_MTW+Extensions.swift
//  template
//
//  Created by Systems
//

import UIKit

typealias TWUIAlertController_MTW = UIAlertController

extension TWUIAlertController_MTW {
    
    class func connectionIssue(handler: @escaping () -> Void) -> UIAlertController {
        let title = NSLocalizedString("Text30ID", comment: "")
        let message = NSLocalizedString("Text31ID", comment: "")
        let okTitle = NSLocalizedString("Text33ID", comment: "")
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: okTitle,
                                   style: .default,
                                   handler: { _ in handler() })
        alert.addAction(action)
        return alert
    }
    
    class func photoLibraryIssue() -> UIAlertController {
        let title = NSLocalizedString("Text53ID", comment: "")
        let message = NSLocalizedString("Text54ID", comment: "")
        let settingsTitle = NSLocalizedString("Text55ID", comment: "")
        let okTitle = NSLocalizedString("Text33ID", comment: "")
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: settingsTitle,
                                   style: .default,
                                   handler: { _ in
            UIApplication.shared.open(.init(string: UIApplication.openSettingsURLString)!)
        })
        let okAction = UIAlertAction(title: okTitle, style: .default)
        
        alert.addAction(settingsAction)
        alert.addAction(okAction)
        
        return alert
    }
    
}
