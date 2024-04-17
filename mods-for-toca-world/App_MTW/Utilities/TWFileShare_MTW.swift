//
//  TWFileShare_MTW.swift
//  mods-for-toca-world
//
//

import Foundation
import LinkPresentation

final class TWFileShare_MTW {
    
    static let share = TWFileShare_MTW()
    
    func saveFile(data: UIImage, fileName: String, viewController: UIViewController, completion: @escaping (Bool, Error?) -> Void) {
        let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                completion(true, nil)
            } else if let error = error {
                completion(false, error)
            } else {
                completion(false, nil)
            }
        }
        
        activityViewController.popoverPresentationController?.sourceView = viewController.view
        activityViewController.popoverPresentationController?.sourceRect = viewController.view.bounds
        viewController.present(activityViewController, animated: true, completion: nil)
    }
}
