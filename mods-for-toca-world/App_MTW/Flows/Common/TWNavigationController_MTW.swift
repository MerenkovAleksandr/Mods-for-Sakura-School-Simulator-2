//
//  TWNavigationController_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

class TWNavigationController_MTW: TWBaseController_MTW {
    
    var iPad: Bool { view.iPad }
    
    var vNavigation = TWNavigationBarView_MTW()
    var vContent = UIView.clearView
    
    var localizedTitle: String { "" }
    var leadingBarIcon: UIImage? { nil }
    var trailingBarIcon: UIImage? { nil }
    
    var vOffset: CGFloat {
        iPad ? 24.0 : 2.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubviews_MTW()
        
        makeLayout()
    }
    
    func updateTitle() {
        configureNavigationView()
    }
    
    func makeLayout() {
        layoutNavigationView()
        layoutContentView()
    }
    
    func layoutNavigationView() {
        vNavigation.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(vOffset)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(iPad ? 0.95 : 0.9)
            $0.height.equalTo(vNavigation.snp.width).multipliedBy(iPad ? 0.1 : 1.0/4.0)
        }
    }
    
    func layoutContentView() {
        vContent.snp.makeConstraints {
            $0.top.equalTo(vNavigation.snp.bottom).offset(vOffset)
            $0.leading.equalTo(view)
            $0.trailing.equalTo(view)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12.0)
            $0.bottom.equalTo(view.snp.bottom).inset(4.0)
        }
    }
    
    func didTapLeadingBarBtn() {}
    
    func didTapTrailingBarBtn() {}
    
}

// MARK: - TWNavigationBarDelegate_MTW

extension TWNavigationController_MTW: TWNavigationBarDelegate_MTW {}

// MARK: - Private API

private extension TWNavigationController_MTW {
    
    var foregroundColor: UIColor {
        TWColors_MTW.navigationBarForeground
    }
    
    func configureSubviews_MTW() {
        [vNavigation, vContent].forEach { subview in
            view.addSubview(subview)
        }
        
        configureNavigationView()
    }
    
    func configureNavigationView() {
        vNavigation.delegate = self
        vNavigation.configure_MTW(localizedTitle: localizedTitle,
                              leadingIcon: leadingBarIcon,
                              trailingIcon: trailingBarIcon)
    }
    
}
