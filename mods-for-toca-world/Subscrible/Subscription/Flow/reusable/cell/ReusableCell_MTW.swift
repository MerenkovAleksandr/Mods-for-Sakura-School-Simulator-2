//  Created by Systems
//


import UIKit

class TWReusableCell_MTW: UICollectionViewCell {
    
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell_MTW()
    }
    
    func setupCell_MTW() {
        cellLabel.textColor = .white
        
        contentContainer.layer.cornerRadius = 8
        titleContainer.layer.cornerRadius = 8
        
        cellImage.layer.cornerRadius = 8
        cellImage.layer.borderColor = UIColor.black.cgColor
        cellImage.layer.borderWidth = 2
    }
}
