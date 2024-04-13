//
//  TWCharacterSelectorController_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWCharacterSelectorController_MTW: TWContentPlainCollectionController_MTW {
     
     enum SelectorItem: Hashable {
          case new,
               preview(TWCharacterPreview_MTW)
     }
     
     typealias DataSource = UICollectionViewDiffableDataSource<Int, SelectorItem>
     typealias Snapshot = NSDiffableDataSourceSnapshot<Int, SelectorItem>
     typealias Cell = TWCharacterEditorCollectionViewCell_MTW
     
     private var dataSource: DataSource?
     private var content: [TWCharacterPreview_MTW] = []
     private var coverView: UIView?
     private var subMenu: TWSubMenu_MTW?
     
     override var localizedTitle: String {
          TWContentSelectorItem_MTW.characters.localizedTitle
     }
     
     override func configureController() {
          configureDataSource()
          fetchCharacters()
          applySnapshot()
     }
     
     override func generateLayoutPhone() -> UICollectionViewLayout {
          let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                heightDimension: .fractionalHeight(1.0))
          let item = NSCollectionLayoutItem(layoutSize: itemSize)
          
          let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .fractionalWidth(0.5))
          
          let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
          
          let section = NSCollectionLayoutSection(group: group)
          
          return UICollectionViewCompositionalLayout(section: section)
     }
     
     override func generateLayoutPad() -> UICollectionViewLayout {
          let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                                heightDimension: .fractionalHeight(1.0))
          let item = NSCollectionLayoutItem(layoutSize: itemSize)
          
          let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .fractionalWidth(0.33))
          
          let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
          
          let section = NSCollectionLayoutSection(group: group)
          
          return UICollectionViewCompositionalLayout(section: section)
     }
     
     override func registerCells() {
          collectionView.register(Cell.nib,
                                  forCellWithReuseIdentifier: Cell.reuseIdentifier)
     }
     
     override func collectionView(_ collectionView: UICollectionView,
                                  didSelectItemAt indexPath: IndexPath) {
          guard let item = dataSource?.itemIdentifier(for: indexPath) else {
               return
          }
          
          let flow: UIViewController
          
          switch item {
          case .new:
               flow = TWCharacterEditorController_MTW.instantiate_MTW()
          case let .preview(character):
               flow = TWCharacterDetailsController_MTW.instantiate_MTW(with: character)
          }
          
          navigationController?.pushViewController(flow, animated: true)
     }
     
     override func collectionView(_ collectionView: UICollectionView,
                                  willDisplay cell: UICollectionViewCell,
                                  forItemAt indexPath: IndexPath) {
          if indexPath.row == (self.content.count - 1),
             !isContentLimitReached {
              loadNextPage()
          }
     }
     
     override func viewWillAppear(_ animated: Bool) {
          isContentLimitReached = false
          
          dataSource?.apply(Snapshot(), animatingDifferences: false)
          
          fetchCharacters()
          
          collectionView.reloadData()
     }
     
}

// MARK: - Private API

private extension TWCharacterSelectorController_MTW {
     
     func configureDataSource() {
          dataSource = DataSource(collectionView: collectionView) {
               collectionView, indexPath, item in
               
               if let cell = collectionView
                    .dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier,
                                         for: indexPath) as? Cell {
                    switch item {
                    case .new:
                         cell.configure()
                    case let .preview(character):
                         cell.configure(with: character)
                         cell.didCallSubMenu = { [weak self] sender, character in
                              self?.toggleSubMenu(sender: sender,
                                                  character: character)
                         }
                    }
                    
                    return cell
               }
               
               return nil
          }
     }
     
     func loadNextPage() {
          let fetchContent = contentManager.fetchCharacters(page: currentPage + 1)
          
          guard fetchContent != content else {
              isContentLimitReached = true
              return
          }
          
          currentPage += 1
          
          content = fetchContent
          
          applySnapshot()
     }
     
     func fetchCharacters() {
          content = dropbox.contentManager.fetchCharacters(page: currentPage)
          
          applySnapshot()
     }
     
     func applySnapshot() {
          var snapshot = Snapshot()
          snapshot.appendSections([.zero])
          snapshot.appendItems([.new])
          snapshot.appendItems(content.map { .preview($0) })
          
          DispatchQueue.main.async {
               self.dataSource?.apply(snapshot, animatingDifferences: true)
          }
     }
     
     func toggleSubMenu(sender: UIView, character: TWCharacterPreview_MTW) {
          let sourceRect = sender.convert(sender.bounds, to: view)
          let origin = CGPoint(x: sourceRect.minX - 100, y: sourceRect.midY - 20)
          let deleteOrigin = CGPoint(x: sourceRect.minX - 80, y: sourceRect.minY + 30)
          let size: CGSize = view.iPad
          ? .init(width: 180.0, height: 150.0)
          : .init(width: 120.0, height: 117.0)
          let frame = CGRect(origin: origin, size: size)
          let coverView = UIView(frame: view.bounds)
          let subMenu = TWSubMenu_MTW(frame: frame)
          let tapGesture = UITapGestureRecognizer(target: self,
                                                  action: #selector(dismissSubMenu))
          coverView.backgroundColor = .clear
          subMenu.alpha = .zero
          
          view.isUserInteractionEnabled = false
          view.addSubview(coverView)
          view.addSubview(subMenu)
          
          UIView.animate(withDuration: 0.3, animations: {
               subMenu.alpha = 1.0
          }, completion: { _ in
               self.coverView = coverView
               self.coverView?.isUserInteractionEnabled = true
               self.coverView?.addGestureRecognizer(tapGesture)
               self.subMenu = subMenu
               self.subMenu?.didPerform = { [weak self] action in
                    self?.dismissSubMenu()
                    self?.handle(character: character, action: action)
               }
               self.view.isUserInteractionEnabled = true
          })
     }
     
     @objc
     func dismissSubMenu() {
          guard let subMenu,
                let coverView = coverView else { return }
          
          view.isUserInteractionEnabled = false
          
          UIView.animate(withDuration: 0.3, animations: {
               subMenu.alpha = .zero
          }, completion: { _ in
               subMenu.removeFromSuperview()
               coverView.removeFromSuperview()
               self.subMenu = nil
               self.coverView = nil
               self.view.isUserInteractionEnabled = true
          })
     }
     
     func handle(character: TWCharacterPreview_MTW,
                 action: TWSubMenu_MTW.TWAction_MTW) {
          switch action {
          case .edit:
               let controller = TWCharacterEditorController_MTW
                    .instantiate_MTW(character: character)
               navigationController?
                    .pushViewController(controller, animated: true)
          case .delete:
               showDeleteConfirmation { [weak self] in
                    self?.dropbox.contentManager.delete(character: character)
                    self?.fetchCharacters()
               }
          }
     }
     
     func showDeleteConfirmation(onDelete handler: @escaping () -> Void) {
          let title = NSLocalizedString("Text63ID", comment: "")
//          title.attributedText = TWAttributtedStrings_MTW
//              .recomendationsTitleAttrString(with: localizedTitle,
//                                             foregroundColor: TWColors_MTW.contentSelectorCellSelectedForeground)
          let message = NSLocalizedString("Text64ID", comment: "")
          let closeTitle = NSLocalizedString("Text37ID", comment: "")
          let deleteTitle = NSLocalizedString("Text38ID", comment: "")
          let alert = TWAlertController_MTW
               .show_MTW(with: title,
                            message: message,
                            leading: .init(title: closeTitle),
                            trailing: .init(title: deleteTitle,
                                            style: .desctructive,
                                            handler: handler))
          present(alert, animated: false)
     }
     
}
