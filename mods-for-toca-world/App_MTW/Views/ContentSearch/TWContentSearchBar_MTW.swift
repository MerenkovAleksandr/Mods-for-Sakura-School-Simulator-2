//
//  TWContentSearchBar_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

// MARK: - TWContentSearchable_MTW

protocol TWContentSearchable_MTW {
    var title: String { get }
    var id: UUID { get }
    var searchText: String { get }
}

extension TWContentSearchable_MTW {
    var searchText: String { title.lowercased() }
}

protocol TWContentSearchBarDelegate_MTW: AnyObject {
    var drawWithOverlay: Bool { get }
    
    func search_MTW(_ text: String?)
    func didTapClose()
    func didSelect(item: TWContentModel_MTW)
}

final class TWContentSearchBar_MTW: TWBaseView_MTW {
    
    typealias Cell = TWContentSearchResultTableViewCell_MTW
    
    weak var delegate: TWContentSearchBarDelegate_MTW?
    
    @IBOutlet private var view: UIView!
    @IBOutlet private var searchBarTextField: TWContentSearchBarTextField_MTW!
    @IBOutlet private var btnClose: UIButton!
    @IBOutlet private var tvSearchResults: UITableView!
    
    private var itemsToDisplay = [TWContentModel_MTW]()
    
    override var gradientColors: [CGColor] {[
        TWColors_MTW.navigationBarGradientStart.cgColor,
        TWColors_MTW.navigationBarGradientEnd.cgColor
    ]}
    
    override func commonInit_MTW() {
        super.commonInit_MTW()
        
        view = loadFromNib_MTW(in: bounds)
        view.backgroundColor = .clear
        
        addSubview(view)
        backgroundColor = .clear
        
        configureSubviews_MTW()
    }
    
    override var cornerRadius: CGFloat {
        searchBarTextField.bounds.height / 3
    }
    
    override var backgroundLayerPath: UIBezierPath {
        .init(roundedRect: adjustedRect, cornerRadius: cornerRadius)
    }
    
    @IBAction func closeButtonAction_MTW(_ sender: Any) {
        searchBarTextField.resignFirstResponder()
        delegate?.didTapClose()
    }
    
}

// MARK: - UITextFieldDelegate

extension TWContentSearchBar_MTW: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchBarTextField {
            searchBarTextField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.search_MTW(textField
            .text?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased())
    }
}

// MARK: - UITableViewDataSource

extension TWContentSearchBar_MTW: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemsToDisplay.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = {
            if let cell = tableView
                .dequeueReusableCell(withIdentifier: Cell.reuseIdentifier)
                as? Cell {
                return cell
            }
            return Cell(style: .default, reuseIdentifier: Cell.reuseIdentifier)
        }()
        
        cell.backgroundColor = .clear
        cell.backgroundView = .clearView
        cell.configure_MTW(with: itemsToDisplay[indexPath.row].title)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        bounds.height / 4
    }
    
}

// MARK: - UITableViewDelegate

extension TWContentSearchBar_MTW: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(item: itemsToDisplay[indexPath.row])
    }
    
}

// MARK: - Public API

extension TWContentSearchBar_MTW {
    
    func activate_MTW() {
        searchBarTextField.becomeFirstResponder()
    }
    
    func deactivate_MTW() {
        searchBarTextField.text = nil
        searchBarTextField.resignFirstResponder()
        itemsToDisplay.removeAll()
        tvSearchResults.reloadData()
    }
    
    func display_MTW(searchResults: [TWContentModel_MTW]) {
        tvSearchResults.visibility(isVisible: drawWithOverlay)
        itemsToDisplay = searchResults
        tvSearchResults.reloadData()
    }
    
}

// MARK: - Private API

private extension TWContentSearchBar_MTW {
    
    var drawWithOverlay: Bool {
        delegate?.drawWithOverlay ?? false
    }
    
    var searchBarTintColor: UIColor {
        TWColors_MTW.navigationSearchForeground
    }
    
    func configureSubviews_MTW() {
        configureTextField()
        configurePlaceholder()
        configureCloseButton()
        configureTableView_MTW()
    }
    
    func configureTextField() {
        searchBarTextField.delegate = self
        searchBarTextField.tintColor = searchBarTintColor
        searchBarTextField.keyboardType = .alphabet
        searchBarTextField.autocapitalizationType = .none
        searchBarTextField.autocorrectionType = .no
        searchBarTextField.defaultTextAttributes = TWAttributtedStrings_MTW
            .searchBarTextFieldTextAttridbutes
        searchBarTextField.adjustsFontSizeToFitWidth = false
    }
    
    func configureCloseButton() {
        let localizedString = NSLocalizedString("Text37ID", comment: "").uppercased()
        let attributtedString = TWAttributtedStrings_MTW
            .searchBarAttrString(with: localizedString,
                                 foregroundColor: searchBarTintColor)
        btnClose.setAttributedTitle(attributtedString, for: .normal)
    }
    
    func configurePlaceholder() {
        let localizedString = NSLocalizedString("Text37ID", comment: "")
        let attributes =  TWAttributtedStrings_MTW
            .searchBarTextFieldTextAttridbutes
        
        let attributtedString = TWAttributedString_MTW
            .init(string: localizedString,
                  attributes: attributes)
    }
    
    func configureTableView_MTW() {
        tvSearchResults.register(Cell.classForCoder(),
                           forCellReuseIdentifier: Cell.reuseIdentifier)
        tvSearchResults.tintColor = TWColors_MTW.navigationBarForeground
        tvSearchResults.showsVerticalScrollIndicator = false
        tvSearchResults.delegate = self
        tvSearchResults.dataSource = self
        tvSearchResults.separatorStyle = .none
        tvSearchResults.rowHeight = 36.0
        tvSearchResults.tableFooterView = .clearView
    }
    
}

// MARK: - TWContentSearchBarTextField_MTW


final class TWContentSearchBarTextField_MTW: UITextField {
    
    override func canPerformAction(_ action: Selector,
                                   withSender sender: Any?) -> Bool { false }
    
}

// MARK: - TWContentSearchResultTableViewCell_MTW

final class TWContentSearchResultTableViewCell_MTW: UITableViewCell {
    
    static let reuseIdentifier = String(describing: TWContentSearchResultTableViewCell_MTW.self)
    
    private var lblTitle = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .clear
        contentView.addSubview(lblTitle)
        
        selectionStyle = .gray
        selectedBackgroundView = .clearView
        
        let hightlight: UIView = {
            let view = UIView()
            view.backgroundColor = foregroundColor.withAlphaComponent(0.4)
            
            return view
        }()
        
        selectedBackgroundView?.addSubview(hightlight)
        
        let margin = iPad ? 6.0 : 3.0
        
        hightlight.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(margin)
            $0.trailing.equalToSuperview().inset(margin)
            $0.top.bottom.equalToSuperview()
        }
        
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Public API

extension TWContentSearchResultTableViewCell_MTW {
    
    func configure_MTW(with item: String) {
        lblTitle.attributedText = TWAttributtedStrings_MTW
            .searchResultAttrString(with: item,
                                    foregroundColor: foregroundColor)
    }
    
}

// MARK: - Private API

private extension TWContentSearchResultTableViewCell_MTW {
    
    var offset: CGFloat { iPad ? 48.0 : 36.0 }
    
    var foregroundColor: UIColor {
        TWColors_MTW.navigationBarForeground
    }
    
    func makeLayout() {
        lblTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(offset)
            $0.trailing.equalToSuperview().inset(offset)
            $0.top.equalToSuperview().offset(4.0)
            $0.bottom.equalToSuperview().inset(4.0)
        }
    }
    
}
