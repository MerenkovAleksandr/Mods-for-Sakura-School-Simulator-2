//
//  :: MARK- - TWRecomendationCollectionViewCell_MTW  final class TWRecomendationCollectionViewCell_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWRecomendationCollectionViewCell_MTW: TWBaseCollectionViewCell_MTW {
    
    private(set) var id: UUID?
    private(set) var isFavourite: Bool = false
    
    var imageView = TWImageView_MTW(frame: .zero)
    var vBubble = TWBubbleView_MTW()
    
    var radius: CGFloat = 18.0
    
    var favouriteView: UIView = {
        let view = UIView()
        return view
    }()
    
    var ivFavourite: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override var cornerRadius: CGFloat {
        radius
    }
    
    override var adjustedRect: CGRect {
        .init(x: 3,
              y: 3,
              width: bounds.width - 3,
              height: bounds.height - 3)
    }
    
    override var adjustedShadowRect: CGRect {
        .init(x: 0,
              y: 0,
              width: bounds.width - 5,
              height: bounds.height - 5)
    }
    
    override var backgroundFillColor: UIColor {
        TWColors_MTW.contentSelectorCellShadow
    }
    
    override var shadowBackgroundColor: UIColor {
        TWColors_MTW.contentSelectorCellBackground
    }
    
    
    override func commonInit_MTW() {
        backgroundColor = .clear
        
        addSubview(imageView)
        
        layer.cornerRadius = 8.0
        clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = radius
        
        addSubview(favouriteView)
        
        favouriteView.translatesAutoresizingMaskIntoConstraints = false
        favouriteView.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        favouriteView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        favouriteView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        favouriteView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(vBubble)
        vBubble.translatesAutoresizingMaskIntoConstraints = false
        vBubble.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -5).isActive = true
        vBubble.topAnchor.constraint(equalTo: topAnchor, constant: -5).isActive = true
        vBubble.heightAnchor.constraint(equalToConstant: 44).isActive = true
        vBubble.widthAnchor.constraint(equalToConstant: 54).isActive = true
        vBubble.isHidden = true
        
        applyMask()
        makeLayout()
    }
}

extension TWRecomendationCollectionViewCell_MTW {
    func configure_MTW(with item: TWContentModel_MTW) {
        id = item.id
        isFavourite = item.attributes?.favourite ?? false
        configureIV()
    }
}

// MARK: - Private API

private extension TWRecomendationCollectionViewCell_MTW {
    
    func makeLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12.0)
        }
    }
    
    func applyMask() {
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath()
        let cornerRadius: CGFloat = 15
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: bounds.width - 90, y: 0))
        path.addArc(withCenter: CGPoint(x: bounds.width - 70, y: cornerRadius), radius: cornerRadius, startAngle: .pi * 3 / 2, endAngle: 0, clockwise: true)
        path.addArc(withCenter: CGPoint(x: bounds.width - 40, y: cornerRadius), radius: cornerRadius, startAngle: .pi, endAngle: .pi / 2, clockwise: false)
        path.addArc(withCenter: CGPoint(x: bounds.width - 40, y: cornerRadius * 3), radius: cornerRadius, startAngle: .pi * 3 / 2, endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        path.addLine(to: CGPoint(x: 0, y: bounds.height))
        path.close()

        maskLayer.path = path.cgPath
        imageView.layer.mask = maskLayer
    }
    
    func configureIV() {
        addSubview(favouriteView)

        favouriteView.translatesAutoresizingMaskIntoConstraints = false
        favouriteView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        favouriteView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        favouriteView.widthAnchor.constraint(equalToConstant: 42).isActive = true
        favouriteView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        favouriteView.addSubview(ivFavourite)
        ivFavourite.translatesAutoresizingMaskIntoConstraints = false
        ivFavourite.centerXAnchor.constraint(equalTo: favouriteView.centerXAnchor).isActive = true
        ivFavourite.centerYAnchor.constraint(equalTo: favouriteView.centerYAnchor).isActive = true
        ivFavourite.widthAnchor.constraint(equalToConstant: 14).isActive = true
        ivFavourite.heightAnchor.constraint(equalToConstant: 18).isActive = true
        ivFavourite.image = isFavourite ? #imageLiteral(resourceName: "favourite_selected") : #imageLiteral(resourceName: "favourite")

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didToggleIsFavourite))
        
        favouriteView.isUserInteractionEnabled = true
        favouriteView.addGestureRecognizer(tapGesture)
    }
    
    @objc func didToggleIsFavourite() {
        guard let id else { return }
        
        let fetchRequest = ContentEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        
        let managedContext = TWDBManager_MTW.shared.contentManager.managedContext
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if let entity = result.first {
                entity.contentStared = !isFavourite
                
                try managedContext.save()
                
                isFavourite.toggle()
                
                DispatchQueue.main.async {
                    self.configureIV()
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
