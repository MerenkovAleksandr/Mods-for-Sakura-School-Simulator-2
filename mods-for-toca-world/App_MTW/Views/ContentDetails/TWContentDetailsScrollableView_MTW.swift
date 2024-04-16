//
//  TWContentDetailsScrollableView_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWContentDetailsScrollableView_MTW: UIView {
    
    @IBOutlet var view: UIView!
    
    @IBOutlet var vContentDetails: TWContentDetailsView_MTW!
    @IBOutlet var vRecomendationsCover: UIView!
    @IBOutlet var vRecomendations: TWContentRecomendationsView_MTW!
    
    var didUpdate: ((UUID,Bool) -> Void)?
    var didSaveImage: ((TWContentModel_MTW?) -> Void)?
    var didSelect: ((TWContentModel_MTW?) -> Void)?
    var selectedItem: TWContentModel_MTW?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit_MTW()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit_MTW()
    }
    
}

// MARK: - Public API

extension TWContentDetailsScrollableView_MTW {
    
    func configure_MTW(with item: TWContentModel_MTW) {
        let regularContent = item.contentType != .guide
                
        vContentDetails.delegate = self
        vContentDetails.configure_MTW(with: item)
        vContentDetails.didUpdate = { [weak self] in
            guard let self = self,
                  let id = vContentDetails.id,
                  let callback = self.didUpdate else { return }
            callback(id, vContentDetails.isFavourite)
        }
        
        if regularContent {
            fetchRecomendations(for: item)
        } else {
            vRecomendationsCover.hide_MTW()
        }
        
        vContentDetails.setNeedsDisplay()
    }
    
    func fetchRecomendations(for item: TWContentModel_MTW) {
        let models = TWDBManager_MTW.shared.contentManager
            .fetchRecomendation(for: item.contentType,
                                exclude: item.id,
                                limit: iPad ? 4 : 5)
        if models.isEmpty {
            vRecomendations.hide_MTW()
            return
        }
        
        configureRecomendations(models)
    }
    
    func configureRecomendations(_ models: [TWContentModel_MTW]) {
        vRecomendations.configure(models: models)
        vRecomendations.didSelect = { [weak self] model in
            self?.configure_MTW(with: model)
            self?.selectedItem = model
            self?.didSelect?(model)
        }
    }
    
}

// MARK: - TWContentDetailsDelegate_MTW

extension TWContentDetailsScrollableView_MTW: TWContentDetailsDelegate_MTW {
    func didTapActionButton() {
        didSaveImage?(self.selectedItem)
    }

    func stopAnimation() {
        vContentDetails.stopAnimation()
    }
}

// MARK: - Private API

private extension TWContentDetailsScrollableView_MTW {
    
    func commonInit_MTW() {
        backgroundColor = .clear
        loadViewFromNib_MTW()
    }
    
    func loadViewFromNib_MTW() {
        view = loadFromNib_MTW(in: bounds)
        view.backgroundColor = .clear
        addSubview(view)
    }
    
}

