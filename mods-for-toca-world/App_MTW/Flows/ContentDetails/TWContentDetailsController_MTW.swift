//
//  TWContentDetailsController_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit
import Photos

final class TWContentDetailsController_MTW: TWNavigationController_MTW {
    
    class func instantiate_MTW(selectedItem: TWContentModel_MTW)
    -> TWContentDetailsController_MTW {
        let controller = TWContentDetailsController_MTW()
        controller.selectedItem = selectedItem
        controller.contentType = selectedItem.contentType
        
        return controller
    }
    
    var didUpdate: ((TWContentModel_MTW) -> Void)?
    
    private var contentView = TWContentDetailsScrollableView_MTW()
    private let fileShare = TWFileShare_MTW.share
    
    override var localizedTitle: String {
        switch contentType {
        case .wallpaper:
            return contentType.localizedTitle
        case .guide:
            return "Guide"
        default:
            return selectedItem.title
        }
    }
    
    override var leadingBarIcon: UIImage? {
        #imageLiteral(resourceName: "icon_navigation_back")
    }
    
    private var contentType: TWContentType_MTW = .set
    private var selectedItem: TWContentModel_MTW!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScrollableView()
        layoutScrollableView()
    }
    
    override func didTapLeadingBarBtn() {
        navigationController?.popViewController(animated: false)
    }

}

// MARK: - Private API

private extension TWContentDetailsController_MTW {
    
    func configureScrollableView() {
        vContent.addSubview(contentView)
        contentView.configure_MTW(with: selectedItem)
        contentView.didUpdate = { [weak self] id, isFavourite in
            TWDBManager_MTW.shared.contentManager.update(modelId: id,
                                                         isFavourite: isFavourite)
            
            guard let self = self else { return }
            self.selectedItem.attributes?.favourite = isFavourite
            self.didUpdate?(self.selectedItem)
        }
        contentView.didSaveImage = { [weak self] selectedItem in
            if let selectedItem = selectedItem {
                self?.selectedItem = selectedItem
            }
            
            self?.savePreview()
        }
        
        
        contentView.didSelect = { [weak self] selectedItem in
            if let selectedItem = selectedItem {
                self?.selectedItem = selectedItem
                self?.didUpdate?(selectedItem)
                self?.updateTitle()
            }
        }
        
    }
    
    func layoutScrollableView() {
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func savePreview() {
        guard let image = selectedItem.content.image else { return }
        
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        
        if status == .authorized {
            
            fileShare.saveFile(data: image, fileName: UUID().uuidString, viewController: self) { [weak self] isSaved, error in
                if isSaved {
                    self?.saveImage(image)
                } else {
                    self?.contentView.stopAnimation()
                }
                
                if let error = error {
                    print(error.localizedDescription)
                }
            }
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
        
        let alert = TWAlertController_MTW.loadingSuccessful {
//            self?.didTapLeadingBarBtn()
        }
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            self?.contentView.stopAnimation()
            alert.dismiss(animated: true)
        })

    }
    
}
