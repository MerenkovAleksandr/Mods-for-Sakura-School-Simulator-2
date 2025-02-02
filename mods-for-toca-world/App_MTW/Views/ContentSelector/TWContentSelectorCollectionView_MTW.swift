//
//  TWContentSelectorCollectionView_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

protocol TWContentSelectorDelegate_MTW: AnyObject {
    func didSelect(item: TWContentSelectorItem_MTW)
}

final class TWContentSelectorCollectionView_MTW: UIView {
    
    enum Section: Int, CaseIterable {
        case mainSection = 0
        case subSection = 1
    }
    
    typealias Item = TWContentSelectorItem_MTW
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias Cell = TWContentSelectorCollectionViewCell_MTW
    typealias PlainTextCell = TWContentSelectorCollectionViewCell_MTW
    
    weak var delegate: TWContentSelectorDelegate_MTW?
    
    private var collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: .init())
    
    private var dataSource: DataSource?
    private var selectedItem: Item?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        
        makeLayout()
        configureCollectionView_MTW()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UIcollectionViewDelegate

extension TWContentSelectorCollectionView_MTW: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let snapshot = dataSource?.snapshot(),
              let section = Section(rawValue: indexPath.section) else {
            return
        }

        let item = snapshot.itemIdentifiers(inSection: section)[indexPath.row]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.delegate?.didSelect(item: item)
        })
    }
    
}

// MARK: - Public API

extension TWContentSelectorCollectionView_MTW {
    
    func reload_MTW() {
        collectionView.reloadData()
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
    }
    
}

// MARK: - Private API

private extension TWContentSelectorCollectionView_MTW {
    
    func makeLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCollectionView_MTW() {
        collectionView.collectionViewLayout = generateLayout()
        collectionView.backgroundColor = nil
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = false
        
        registerCells_MTW()
        configureDataSource()
        applyInitialSnapshot()
    }
    
    // MARK: - UICollectionViewCompositionalLayout
    
    func generateLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout {
            (sectionIndex: Int, environment: NSCollectionLayoutEnvironment)
            -> NSCollectionLayoutSection? in
            switch Section.allCases[sectionIndex] {
            case .mainSection:
                return self.generateMainSectionLayout()
            case .subSection:
                return self.generateSubSectionLayout()
            }
        }
    }
    
    func generateMainSectionLayout() -> NSCollectionLayoutSection {
        iPad ? generateMainSectionLayoutPad() : generateMainSectionLayoutPhone()
    }
    
    func generateMainSectionLayoutPhone() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                              heightDimension: .fractionalHeight(1.4))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let secondItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.65),
                                                                                   heightDimension: .fractionalHeight(1.4)))
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.24))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item, secondItem])
        group.contentInsets = NSDirectionalEdgeInsets(top: 2.0,
                                                      leading: .zero,
                                                      bottom: 2.0,
                                                      trailing: .zero)
        
        group.contentInsets = .init(top: 15.0, leading: 21.0, bottom: .zero, trailing: 21.0)
        group.interItemSpacing = .fixed(10)
        
        return .init(group: group)
    }
    
    func generateMainSectionLayoutPad() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                              heightDimension: .fractionalHeight(1.4))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let secondItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.65),
                                                                                   heightDimension: .fractionalHeight(1.4)))
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.24))
        
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item, secondItem])
        group.contentInsets = .init(top: .zero, leading: bounds.width / 4, bottom: .zero, trailing: bounds.width / 4)
        group.interItemSpacing = .fixed(10)
        
        return .init(group: group)
    }
    
    func generateSubSectionLayout() -> NSCollectionLayoutSection {
        iPad ? generateSubSectionLayoutPad() : generateSubSectionLayoutPhone()
    }
    
    func generateSubSectionLayoutPhone() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                              heightDimension: .fractionalHeight(1.8))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.25))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 2.0,
                                                      leading: .zero,
                                                      bottom: 2.0,
                                                      trailing: .zero)
        
        group.contentInsets = .init(top: 85.0, leading: 21.0, bottom: .zero, trailing: 21.0)
        group.interItemSpacing = .fixed(10)
        
        return .init(group: group)
    }
    
    func generateSubSectionLayoutPad() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                              heightDimension: .fractionalHeight(1.7))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.25))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets = .init(top: 130.0, leading: bounds.width / 4, bottom: .zero, trailing: bounds.width / 4)
        group.interItemSpacing = .fixed(10)
        
        return .init(group: group)
    }
    
    // MARK: - UICollectionViewDiffableDataSource
    
    func registerCells_MTW() {
        collectionView.register(Cell.nib,
                                forCellWithReuseIdentifier: Cell.reuseIdentifier)
        collectionView.register(PlainTextCell.nib,
                                forCellWithReuseIdentifier: PlainTextCell.reuseIdentifier)
    }
    
    func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView) {
            collectionView, indexPath, item in
            if item.isPlainTextCell,
               let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: PlainTextCell.reuseIdentifier,
                                     for: indexPath) as? PlainTextCell {
                
                cell.configure_MTW(with: item)
                return cell
            }
            
            if let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier,
                                     for: indexPath) as? Cell {
                
                cell.configure_MTW(with: item,
                               isContentLocked: item.isContentLocked)
                
                return cell
            }
            
            return nil
        }
    }
    
    func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(TWContentSelectorItem_MTW.mainSectionItems,
                             toSection: Section.mainSection)
        snapshot.appendItems(TWContentSelectorItem_MTW.subSectionItems,
                             toSection: Section.subSection)
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
}
