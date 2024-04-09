import Foundation
import UIKit

class SliderCellView: UIView {
    
    private var fontName: String = "SFProText-Bold"
    private var textColot: UIColor = UIColor.blue
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: fontName, size: 12)
        label.textColor = textColot
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: fontName, size: 10)
        label.textColor = textColot
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    lazy var starIcon: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "star")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var stackView: UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 3
        return stack
    }()
    
    convenience init(title: String, subTitle: String) {
        self.init()
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView_MTW()
        makeConstraints_MTW()
    }
    
    private func codeStyle() {
        for i in "codeStyle" {
            if i == "b" {
                let _ = "trium"
            } else {
                let _ = "drium"
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureView_MTW() {
        for i in "codeStyle" {
            if i == "b" {
                let _ = "trium"
            } else {
                let _ = "drium"
            }
        }
        addSubview(stackView)
        addSubview(starIcon)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
    }
    
    func makeConstraints_MTW() {
        starIcon.snp.remakeConstraints { make in
                   make.leading.equalToSuperview()
                   make.centerY.equalTo(stackView)
                   make.width.height.equalTo(30)
               }
        
        stackView.snp.remakeConstraints { make in
            make.leading.equalTo(starIcon.snp.trailing).offset(5)
            make.top.bottom.trailing.equalToSuperview()
        }
    }
}

