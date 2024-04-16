//
//  TWCharacterDetailsController_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit
import Photos

final class TWCharacterDetailsController_MTW: TWNavigationController_MTW {
    
    class func instantiate_MTW(with preview: TWCharacterPreview_MTW)
    -> TWCharacterDetailsController_MTW {
        let controller = TWCharacterDetailsController_MTW()
        
        controller.preview = preview
        
        return controller
    }
    
    private var characterPreview = TWCharacterPreviewView_MTW()
    private var preview: TWCharacterPreview_MTW!
    
    private var dropbox: TWDBManager_MTW { .shared }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCharacterPreview()
    }
    
    override var localizedTitle: String {
        NSLocalizedString("Text65ID", comment: "")
    }
    
    override var leadingBarIcon: UIImage? {
        #imageLiteral(resourceName: "icon_navigation_back")
    }
    
    override func didTapLeadingBarBtn() {
        navigationController?.popViewController(animated: false)
    }
    
}

// MARK: -

private extension TWCharacterDetailsController_MTW {
    
    func configureCharacterPreview() {
        vContent.addSubview(characterPreview)
        
        characterPreview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        characterPreview.configure(preview)
        characterPreview.didPerform = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .edit:
                let controller = TWCharacterEditorController_MTW
                    .instantiate_MTW(character: self.preview)
                controller.onSave = { preview in
                    self.preview = preview
                    self.configureCharacterPreview()
                }
                self.navigationController?.pushViewController(controller, animated: true)
            case .delete:
                showDeleteConfirmation {
                    self.dropbox.contentManager.delete(character: self.preview)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        characterPreview.didSave = { [weak self] in
            self?.savePreview()
        }
    }
    
    func showDeleteConfirmation(handler: @escaping () -> Void) {
        let title = NSLocalizedString("Text63ID", comment: "")
        let message = NSLocalizedString("Text64ID", comment: "")
        let closeTitle = NSLocalizedString("Text37ID", comment: "")
        let deleteTitle = NSLocalizedString("Text38ID", comment: "")
        let alert = TWAlertController_MTW
            .show_MTW(with: title,
                         message: message,
                         leading: .init(title: closeTitle),
                         trailing: .init(title: deleteTitle,
                                         style: .desctructive,
                                         handler: handler))
        present(alert, animated: false)
    }
    
    func savePreview() {
        guard let image = preview.image else { return }
        
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        
        if status == .authorized {
            saveImage(image)
            return
        }
        
        PHPhotoLibrary.requestAuthorization(for: .addOnly, handler: { [weak self] status in
            if status == .authorized {
                self?.saveImage(image)
                return
            }
            
            let alert = UIAlertController.photoLibraryIssue()
            DispatchQueue.main.async {
                self?.present(alert, animated: true)
            }
        })
    }
    
    func goToSettings() {
        UIApplication.shared.canOpenURL(.init(string: UIApplication.openSettingsURLString)!)
    }
    
    func saveImage(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        
        if let error {
            print(error.localizedDescription)
            return
        }
        
        let alert = TWAlertController_MTW.loadingSuccessful { [weak self] in
            sleep(1)
//            self?.didTapLeadingBarBtn()
            self?.characterPreview.stopAnimation()
        }
        
        present(alert, animated: true)
    }
    
}
