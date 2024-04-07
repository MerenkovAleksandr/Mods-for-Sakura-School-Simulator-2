//
//  TWContentCollectionView_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

protocol TWContentCollectionViewDelegate_MTW: AnyObject {
    var contentType: TWContentType_MTW { get }
    
    func didSelect_MTW(item: TWContentModel_MTW)
    func didUpdateSearchViews()
}

final class TWContentCollectionView_MTW: UIView {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, TWContentModel_MTW>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, TWContentModel_MTW>
    typealias Cell = TWContentCollectionViewCell_MTW
    
    @IBOutlet var view: UIView!
    @IBOutlet private var searchBarPlaceholder: UIView!
    @IBOutlet private var searchBarOverlay: UIView!
    @IBOutlet private var searchBarView: TWContentSearchBar_MTW!
    @IBOutlet private var categoryCollectionView: TWContentCategorySelectorView_MTW!
    @IBOutlet private var contentCollectionView: UICollectionView!
    @IBOutlet private var searchBarHeight: NSLayoutConstraint!
    
    weak var delegate: TWContentCollectionViewDelegate_MTW?
    
    var isSearching: Bool = false {
        didSet { updateSearchViews() }
    }
    
    private var state = TWContentState_MTW()
    private var dataSource: DataSource?
    
    private var currentPage = 1
    private var isContentLimitReached = false
    
    private var dropbox: TWDBManager_MTW { .shared }
    private var contentManager: TWContentManager_MTW { dropbox.contentManager }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromNib_MTW()
        configureSubviews_MTW()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UICollectionViewDelegate

extension TWContentCollectionView_MTW: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let snapshot = dataSource?.snapshot() else { return }
        
        let model = snapshot.itemIdentifiers[indexPath.row]
        
        guard let item = state.content.first(where: {
            $0.id == model.id }),
              item.content.data != nil else { return }
        
        closeSearchBar()
        
        delegate?.didUpdateSearchViews()
        delegate?.didSelect_MTW(item: item)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard state.content.indices.contains(indexPath.row) else { return }
        
        let model = state.content[indexPath.row]
        
        if model.content.image == nil {
            loadImage(for: model)
        }
        
        if indexPath.row == (self.state.content.count - 1),
           !isContentLimitReached {
            self.loadNextPage()
        }
    }
    
}

// MARK: - TWContentSearchBarDelegate_MTW

extension TWContentCollectionView_MTW: TWContentSearchBarDelegate_MTW {
    
    func didSelect(item: TWContentModel_MTW) {
        closeSearchBar()
        delegate?.didSelect_MTW(item: item)
    }
    
    
    var drawWithOverlay: Bool {
        isSearching && state.hasSearchResult
    }
    
    func search_MTW(_ text: String?) {
        updateSearchResults(accordingTo: text ?? "")
    }
    
    func didTapClose() {
        isSearching = false
        
        closeSearchBar()
        delegate?.didUpdateSearchViews()
    }
    
}

// MARK: - Public API

extension TWContentCollectionView_MTW {
    
    func loadContent() {
        guard let contentType = delegate?.contentType else { return }
        
        let content = contentManager.fetchContent(contentType: contentType,
                                                  category: state.selectedCategory,
                                                  page: currentPage)
        let categories = contentManager.fetchCategories(for: contentType)
        
        state.update(content: content)
        categoryCollectionView.add_MTW(customCategories: categories)
        
        applySnapshot()
    }
    
    func didTapSearchBtn() {
        isSearching = true
        contentCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func updateSearchViews() {
        searchBarOverlay.visibility(isVisible: isSearching)
        searchBarPlaceholder.visibility(isVisible: isSearching)
        searchBarView.visibility(isVisible: isSearching)
        searchBarView.display_MTW(searchResults: state.searchResults)
        
        updateSearchBarHeight()
        
        view.setNeedsLayout()
        
        searchBarView.setNeedsDisplay()
        
        if isSearching {
            searchBarView.activate_MTW()
        }
    }
    
    func update_MTW(model: TWContentModel_MTW) {
        state.update_MTW(model: model)
        applySnapshot()
    }
}

// MARK: - Private API

private extension TWContentCollectionView_MTW {
    
    func loadViewFromNib_MTW() {
        view = loadFromNib_MTW(in: bounds)
        view.backgroundColor = .clear
        addSubview(view)
    }
    
    func configureSubviews_MTW() {
        configureSearchBarViews()
        configureContentCollectionView()
        configureCaterogySelectView()
    }
    
    func configureSearchBarViews() {
        updateSearchViews()
        
        searchBarView.delegate = self
    }
    
    func configureContentCollectionView() {
        contentCollectionView.collectionViewLayout = generateLayout()
        contentCollectionView.register(Cell.nib,
                                       forCellWithReuseIdentifier: Cell.reuseIdentifier)
        contentCollectionView.delegate = self
    }
    
    func configureCaterogySelectView() {
        categoryCollectionView.didSelect = { [weak self] category in
            guard let self,
                  self.state.update_MTW(category: category) else { return }
            self.reloadPages()
        }
    }
    
    func generateLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout(section: generateSectionLayout())
    }
    
    func generateSectionLayout() -> NSCollectionLayoutSection {
        iPad ? generateSectionLayoutPad() : generateSectionLayoutPhone()
    }
    
    func generateSectionLayoutPhone() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.55))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        group.contentInsets = .init(top: 15.0, leading: 21.0, bottom: .zero, trailing: 21.0)
        group.interItemSpacing = .fixed(15)
        
        return .init(group: group)
    }
    
    func generateSectionLayoutPad() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.35))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets = .init(top: .zero, leading: 63.0, bottom: .zero, trailing: 63.0)
        
        return .init(group: group)
    }
    
    func updateSearchResults(accordingTo searchText: String) {
        guard let contentType = delegate?.contentType else { return }
        
        let searchResults = contentManager.fetchContent(contentType: contentType,
                                                        with: searchText)
        
        state.update(searchResults: searchResults.filter({
            $0.content.data != nil
        }))
        
        updateSearchViews()
    }
    
    func closeSearchBar() {
        state.clearSearchResults()
        searchBarView.deactivate_MTW()
    }
    
    func configureDataSource() {
        dataSource = DataSource(collectionView: contentCollectionView) {
            [weak self] collectionView, indexPath, contentModel in
            guard let self,
                  let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier,
                                     for: indexPath) as? Cell else { return nil }
            cell.configure_MTW(with: contentModel)
            cell.didUpdate = { [weak self] in
                guard let self,
                      let id = cell.id,
                      var model = self.state.content.first(where: { $0.id == id })
                else { return }
                
                model.attributes?.favourite = cell.isFavourite
                
                self.update_MTW(model: model)
            }
            
            return cell
        }
    }
    
    func applySnapshot() {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.zero])
        snapshot.appendItems(state.content)
        
        DispatchQueue.main.async {
            self.dataSource?.apply(snapshot, animatingDifferences: true)
            self.contentCollectionView.reloadData()
        }
    }
    
    func loadNextPage() {
        guard let contentType = delegate?.contentType else { return }
        
        let fetchContent = contentManager.fetchContent(contentType: contentType,
                                                       category: state.selectedCategory,
                                                       page: currentPage + 1)
        guard fetchContent != state.content else {
            isContentLimitReached = true
            return
        }
        
        currentPage += 1
        
        state.update(content: fetchContent)
        
        applySnapshot()
    }
    
    func reloadPages() {
        guard let contentType = delegate?.contentType else { return }
        
        contentCollectionView.setContentOffset(.zero, animated: false)
        
        state.update(content: contentManager
            .fetchContent(contentType: contentType,
                          category: state.selectedCategory))
        currentPage = 1
        isContentLimitReached = false
        
        applySnapshot()
    }
    
    func loadImage(for model: TWContentModel_MTW) {
        dropbox.fetchImage(for: model, completion: { [weak self] data in
            guard let self,
                  let data
            else { return }
            
            var newModel = model
            newModel.addImage_MTW(data)
            
            self.state.update_MTW(model: newModel)
            
            self.updateImage(for: newModel)
        })
    }
    
    func updateImage(for model: TWContentModel_MTW) {
        guard let indexPath = dataSource?.indexPath(for: model),
              let cell = contentCollectionView.cellForItem(at: indexPath) as? Cell
        else { return }
        
        cell.configure_MTW(with: model)
    }
    
    func updateSearchBarHeight() {
        let placeholder = searchBarPlaceholder.bounds.height
        let height = {
            guard drawWithOverlay else { return placeholder}
            let resultCount = state.searchResults.count
            if resultCount >= 3 {
                return placeholder * 4
            }
            return CGFloat(resultCount + 1) * placeholder
        }()
        searchBarHeight.constant = height
        searchBarView.setNeedsDisplay()
    }
    
}
