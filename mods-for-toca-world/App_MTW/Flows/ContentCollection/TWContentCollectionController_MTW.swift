//
//  TWContentCollectionController_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWContentCollectionController_MTW: TWNavigationController_MTW {
    
    class func instantiate_MTW(with contentType: TWContentType_MTW)
    -> TWContentCollectionController_MTW {
        let viewController = TWContentCollectionController_MTW()
        
        viewController.contentType = contentType

        return viewController
    }
    
    internal var contentType: TWContentType_MTW = .set
    
    private var vContentCollection = TWContentCollectionView_MTW()
    private var dropbox: TWDBManager_MTW { .shared }
    
    override var localizedTitle: String {
        contentType.localizedTitle
    }
    
    override var leadingBarIcon: UIImage? {
        #imageLiteral(resourceName: "icon_navigation_home")
    }
    
    override var trailingBarIcon: UIImage? {
        contentType == .wallpaper
        ? nil
        : vContentCollection.isSearching ? nil : #imageLiteral(resourceName: "icon_search")
    }
    
    override func didTapLeadingBarBtn() {
        navigationController?.popViewController(animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView_MTW()
        layoutCollectionView()
        showSearchView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard TWInternetManager_MTW.shared.checkInternetConnectivity_MTW() else {
            present(UIAlertController.connectionIssue { [weak self] in
                self?.showContentPreloader()
            }, animated: true)
            return
        }
        
        if dropbox.contentManager.isContentReady(for: contentType) {
            vContentCollection.loadContent()
            fetchContentFromDropbox { [weak self] in
                self?.vContentCollection.loadContent()
            }
            return
        }
        showContentPreloader()
    }
    
}

// MARK: - TWContentCollectionViewDelegate_MTW

extension TWContentCollectionController_MTW: TWContentCollectionViewDelegate_MTW {
    
    func didUpdateSearchViews() {
        updateSearchViews()
    }
    
    func didSelect_MTW(item: TWContentModel_MTW) {
        navigateTo(item: item)
    }
    
}

// MARK: - Private API

private extension TWContentCollectionController_MTW {
    
    func fetchContentFromDropbox(completion: @escaping () -> Void) {
        TWDBManager_MTW.shared.fetchContent(for: contentType) {
            DispatchQueue.main.async { completion() }
        }
    }
    
    func showContentPreloader() {
        let preloader = TWAlertController_MTW.loadingIndicator { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        }
        
        present(preloader, animated: false) { [weak self] in
            guard let self else { return }
            self.fetchContentFromDropbox {
                preloader.dismissWithFade_MTW { [weak self] in
                    self?.vContentCollection.loadContent()
                }
            }
        }
    }
    
    func configureCollectionView_MTW() {
        vContent.addSubview(vContentCollection)
        vContentCollection.delegate = self
    }
    
    func layoutCollectionView() {
        vContentCollection.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func updateSearchViews() {
        vNavigation.update_MTW(trailingItem: trailingBarIcon)
        
        view.setNeedsLayout()
    }
    
    func navigateTo(item: TWContentModel_MTW) {
        let controller = TWContentDetailsController_MTW
            .instantiate_MTW(selectedItem: item)
        controller.didUpdate = { [weak self] model in
            self?.vContentCollection.update_MTW(model: model)
        }
        navigationController?.pushViewController(controller,
                                                 animated: false)
    }
    
    func showSearchView() {
        vContentCollection.isSearching.toggle()
        updateSearchViews()
    }

}
