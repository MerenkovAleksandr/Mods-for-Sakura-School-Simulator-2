//
//  TWContentSelectorController_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWContentSelectorController_MTW: TWNavigationController_MTW,
                                             NetworkStatusMonitorDelegate_MTW {
    
    private var contentCollectionView = TWContentSelectorCollectionView_MTW()
    private var dropbox: TWDBManager_MTW { .shared }
    
    override var localizedTitle: String {
        NSLocalizedString("Text39ID", comment: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureContentView()
        layoutCollectionView()
        
        NetworkStatusMonitor_MTW.shared.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.isUserInteractionEnabled = true
        contentCollectionView.reload_MTW()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard TWInternetManager_MTW.shared.checkInternetConnectivity_MTW() else {
            present(UIAlertController.connectionIssue { [weak self] in
                self?.view.isUserInteractionEnabled = true
                self?.contentCollectionView.reload_MTW()
            }, animated: true)
            return
        }
    }
    
    func alert_MTW() {
        present(UIAlertController.connectionIssue(handler: {}), animated: true)
    }
    
}

// MARK: - TWContentSelectorDelegate_MTW

extension TWContentSelectorController_MTW: TWContentSelectorDelegate_MTW {
    
    func didSelect(item: TWContentSelectorItem_MTW) {
        view.isUserInteractionEnabled = false
        
        switch item {
        case .mods where item.isContentLocked:
            showPremiumController(style: .unlockFuncProduct)
        case .mods:
            navigate(to: TWContentCollectionController_MTW
                .instantiate_MTW(with: item.contentType))
        case .characters where item.isContentLocked:
            showPremiumController(style: .unlockContentProduct)
        case .characters:
            navigate(to: TWCharacterSelectorController_MTW())
        case .sets, .wallpapers, .maps:
            navigate(to: TWContentCollectionController_MTW
                .instantiate_MTW(with: item.contentType))
        case .guides:
            navigate(to: TWContentPlainCollectionController_MTW())
        case .sounds:
            navigate(to: TWSoundsCollectionController_MTW())
        case .characterRandomizer:
            navigate(to: TWCharacterRandomizerController_MTW())
        }
    }
    
}

// MARK: - Private API

private extension TWContentSelectorController_MTW {
    
    func configureContentView() {
        vContent.addSubview(contentCollectionView)
        contentCollectionView.delegate = self
    }
    
    func layoutCollectionView() {
        contentCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func navigate(to controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: false)
    }
    
    func showPremiumController(style: PremiumMainControllerStyle_MTW) {
        let controller = PremiumMainController_MTW()
        controller.productBuy = style
        controller.modalPresentationStyle = .fullScreen
        
        present(controller, animated: true)
    }
    
}
