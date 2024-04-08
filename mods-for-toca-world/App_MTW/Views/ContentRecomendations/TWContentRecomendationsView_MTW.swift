//
//  TWContentRecomendationsView_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWContentRecomendationsView_MTW: UIView {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, TWContentModel_MTW>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, TWContentModel_MTW>
    typealias Cell = TWRecomendationCollectionViewCell_MTW
    
    var didSelect: ((TWContentModel_MTW) -> Void)?
    
    private var collectionView: UICollectionView!
    private var lblTitle = UILabel()
    
    private var dataSource: DataSource?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit_MTW()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit_MTW()
    }
    
}

// MARK: - UICollectionViewDelegate

extension TWContentRecomendationsView_MTW: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let model = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        didSelect?(model)
    }
    
}

// MARK: - Public API

extension TWContentRecomendationsView_MTW {
    
    func configure(models: [TWContentModel_MTW]) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.zero])
        snapshot.appendItems(models)
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
}

// MARK: - Private API

private extension TWContentRecomendationsView_MTW {
    
    var inset: CGFloat {
        iPad
        ? bounds.width * 0.4
        : bounds.width * 0.05
    }
    
    func commonInit_MTW() {
        backgroundColor = .clear
        
        configureTitleLabel()
        configureCollectionView_MTW()
        configureStackView()
        
        configureDataSource()
    }
    
    func configureStackView() {
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(lblTitle)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(view)
        stackView.addArrangedSubview(collectionView)
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        lblTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(inset)
            $0.top.bottom.trailing.equalToSuperview()
        }
    }
    
    func configureTitleLabel() {
        let localizedTitle = NSLocalizedString("Text58ID", comment: "")
        
        lblTitle = UILabel()
        lblTitle.attributedText = TWAttributtedStrings_MTW
            .recomendationsTitleAttrString(with: localizedTitle,
                                           foregroundColor: TWColors_MTW.navigationBarForeground)
    }
    
    func configureCollectionView_MTW() {
        collectionView = UICollectionView(frame: bounds,
                                          collectionViewLayout: generateLayout())
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(Cell.classForCoder(),
                                forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }
    
    func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView) {
            collectionView, indexPath, model in
            
            if let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier,
                                     for: indexPath) as? Cell {
                cell.imageView.configure(with: model.content.image)
                
                return cell
            }
            
            return nil
        }
    }
    
    func generateLayout() -> UICollectionViewLayout {
        iPad ? generateLayoutPad() : generateLayoutPhone()
    }
    
    func generateLayoutPad() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                              heightDimension: .absolute(120.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: .zero, leading: 12.0, bottom: .zero, trailing: 12.0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(120.0))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets = .init(top: .zero,
                                    leading: inset,
                                    bottom: .zero,
                                    trailing: inset)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        
        return UICollectionViewCompositionalLayout(section: .init(group: group),
                                                   configuration: config)
    }
    
    func generateLayoutPhone() -> UICollectionViewLayout {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.itemSize = .init(width: 88.0, height: 88.0)
        collectionViewLayout.minimumLineSpacing = 12.0
        collectionViewLayout.minimumInteritemSpacing = 12.0
        collectionViewLayout.sectionInset = .init(top: .zero,
                                                  left: inset,
                                                  bottom: .zero,
                                                  right: inset)
        
        return collectionViewLayout
    }
    
}


