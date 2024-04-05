//
//  TWColorSlider_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWColorSlider_MTW: UIView {
    
    typealias ContentCell = TWEditorElementCollectionViewCell_MTW
    typealias ContentDataSource = UICollectionViewDiffableDataSource
    <Int, ColorsDataModel>
    typealias ContentSnapshot = NSDiffableDataSourceSnapshot
    <Int, ColorsDataModel>
    
    var didSelectColor: ((TWCharacterColor_MTW) -> Void)?
    
    private var gradientLayer = CAGradientLayer()
    private var thumbLayer = CAShapeLayer()
    private var items: [ColorsDataModel] = [ ]
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    private var dataSource: ContentDataSource? = nil
    private var selectedColor: TWCharacterColor_MTW? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit_MTW()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit_MTW()
    }
    
    override func draw(_ rect: CGRect) {}
    
}

// MARK: - UICollectionViewDelegate

extension TWColorSlider_MTW: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let selectedColor = dataSource?.itemIdentifier(for: indexPath), let colorType = TWCharacterColor_MTW(rawValue: selectedColor.colorString)  else { return }
        didSelectColor?(colorType)
        setColor_MTW(selectedColor.color)
    }
    
}

// MARK: - Public API

extension TWColorSlider_MTW {
    
    func setColor_MTW(_ selectedColor: UIColor) {
        applySnapshot(with: selectedColor)
    }
}

// MARK: - Private API

private extension TWColorSlider_MTW {
    
    func commonInit_MTW() {
        backgroundColor = .clear
        
        TWCharacterColor_MTW.allCases.forEach { [weak self] color in
            self?.items.append(ColorsDataModel(color: color.color, colorString: color.rawValue, isSelected: false))
        }
        
        configureCollectionView_MTW()
        configureDataSource()
        
        applySnapshot()
    }
    
    func configureCollectionView_MTW() {
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.collectionViewLayout = collectionViewLayout()
        collectionView.register(ContentCell.self,
                           forCellWithReuseIdentifier: ContentCell.reuseIdentifier)
        
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.sectionInset = .init(top: 4.0,
                                                  left: .zero,
                                                  bottom: 4.0,
                                                  right: .zero)
        collectionViewLayout.minimumLineSpacing = 12.0
        collectionViewLayout.minimumInteritemSpacing = 12.0
        collectionViewLayout.itemSize = .init(width: 80.0, height: 80.0)
        
        return collectionViewLayout
    }
    
    func configureDataSource() {
        dataSource = ContentDataSource(collectionView: collectionView) {
            [weak self] collectionView, indexPath, item in
            if let self,
               let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: ContentCell.reuseIdentifier,
                                     for: indexPath) as? ContentCell {
                
                cell.configure(with: item.color,
                               isSelected: item.isSelected)
                return cell
            }
            
            return nil
        }
    }
    
    private func dismissSelection() {
        for i in 0..<items.count {
            items[i].isSelected = false
        }
    }
    
    private func checkSelected(with color: UIColor = TWCharacterColor_MTW.default.color) {
        dismissSelection()
        for index in 0..<items.count {
            if items[index].color == color {
                items[index].isSelected = true
            }
        }
    }
    
    func applySnapshot(with color: UIColor = TWCharacterColor_MTW.default.color) {
        var snapshot = ContentSnapshot()
        snapshot.appendSections([.zero])
        
        self.checkSelected(with: color)
        snapshot.appendItems(items)
        
        self.dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
}
