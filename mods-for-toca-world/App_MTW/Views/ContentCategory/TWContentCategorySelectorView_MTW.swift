//
//  TWContentCategorySelectorView_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWContentCategorySelectorView_MTW: UIView {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, TWContentItemCategory_MTW>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, TWContentItemCategory_MTW>
    typealias Cell = TWContentCategoryCollectionViewCell_MTW
    typealias BubbleCell = TWContentCategoryBubbleCollectionViewCell_MTW
    
    var didSelect: ((_ category: TWContentItemCategory_MTW) -> Void)?
    
    private var collectionView: UICollectionView!
    private var selectedCategory: TWContentItemCategory_MTW = .all
    private var dataSource: DataSource?
    private var snapshot: Snapshot?
    
    private var categories = TWContentItemCategory_MTW.dafault
    
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

extension TWContentCategorySelectorView_MTW: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        
        guard category != selectedCategory else { return }
        
        selectedCategory = category
        
        collectionView.reloadData()
        
        didSelect?(selectedCategory)
    }
    
}

// MARK: - Public API

extension TWContentCategorySelectorView_MTW {
    
    func add_MTW(customCategories: [String]) {
        var newCategories = TWContentItemCategory_MTW.dafault
        newCategories.append(contentsOf: customCategories.map {
            TWContentItemCategory_MTW.custom($0)
        })
        categories = newCategories
        
        applySnapshot()
    }
    
}

// MARK: - Private API

private extension TWContentCategorySelectorView_MTW {
    
    var leftInset: CGFloat {
        iPad ? 63.0 : 21.0
    }
    
    func commonInit_MTW() {
        backgroundColor = nil
        
        configureCollectionView_MTW()
        makeLayout()
        
        configureDataSource()
        applySnapshot()
    }
    
    func configureCollectionView_MTW() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionViewLayout.sectionInset = .init(top: .zero,
                                                  left: leftInset,
                                                  bottom: .zero,
                                                  right: .zero)
        collectionViewLayout.minimumLineSpacing = 12.0
        collectionViewLayout.minimumInteritemSpacing = 12.0
        
        collectionView = UICollectionView(frame: bounds,
                                          collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.register(Cell.classForCoder(),
                                forCellWithReuseIdentifier: Cell.reuseIdentifier)
        collectionView.register(BubbleCell.classForCoder(),
                                forCellWithReuseIdentifier: BubbleCell.reuseIdentifier)
        
        addSubview(collectionView)
    }
    
    func makeLayout() {
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView) {
            collectionView, indexPath, category in
            let isSelected = category == self.selectedCategory
            
            if category == .all {
                if let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: BubbleCell.reuseIdentifier,
                        for: indexPath) as? BubbleCell {
                    cell.configure(category, isSelected: isSelected)
                    
                    return cell
                }
                
                return nil
            }
            
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Cell.reuseIdentifier,
                for: indexPath) as? Cell {
                cell.configure(category, isSelected: isSelected)
                
                return cell
            }
            
            return nil
        }
    }
    
    func applySnapshot() {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.zero])
        snapshot.appendItems(categories)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
}
