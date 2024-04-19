//  Created by Systems
//

import Foundation
import UIKit

class CustomPageControl_MTW: UIPageControl {

    @IBInspectable var currentPageImage: UIImage? = UIImage(named: "page_1")
    
    @IBInspectable var otherPagesImage: UIImage? = UIImage(named: "page_0")
    
    override var numberOfPages: Int {
        didSet {
            updateDots_MTW()
        }
    }
    
    override var currentPage: Int {
        didSet {
            updateDots_MTW()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        if #available(iOS 14.0, *) {
            defaultConfigurationForiOS14AndAbove_MTW()
        } else {
            pageIndicatorTintColor = .clear
            currentPageIndicatorTintColor = .clear
            clipsToBounds = false
        }
    }
    
    private func defaultConfigurationForiOS14AndAbove_MTW() {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        if #available(iOS 14.0, *) {
            for index in 0..<numberOfPages {
                let image = index == currentPage ? currentPageImage : otherPagesImage
                setIndicatorImage(image, forPage: index)
            }

            // give the same color as "otherPagesImage" color.
            pageIndicatorTintColor =  .lightGray
            //
            //  rgba(209, 209, 214, 1)
            // give the same color as "currentPageImage" color.
            //
            
            currentPageIndicatorTintColor = .black
            /*
             Note: If Tint color set to default, Indicator image is not showing. So, give the same tint color based on your Custome Image.
             */
        }
    }
    
    private func updateDots_MTW() {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        if #available(iOS 14.0, *) {
            defaultConfigurationForiOS14AndAbove_MTW()
        } else {
            for (index, subview) in subviews.enumerated() {
                let imageView: UIImageView
                if let existingImageview = getImageView_MTW(forSubview: subview) {
                    imageView = existingImageview
                } else {
                    imageView = UIImageView(image: otherPagesImage)
                    
                    imageView.center = subview.center
                    subview.addSubview(imageView)
                    subview.clipsToBounds = false
                }
                imageView.image = currentPage == index ? currentPageImage : otherPagesImage
            }
        }
    }
    
    private func getImageView_MTW(forSubview view: UIView) -> UIImageView? {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        if let imageView = view as? UIImageView {
            return imageView
        } else {
            let view = view.subviews.first { (view) -> Bool in
                return view is UIImageView
            } as? UIImageView
            
            return view
        }
    }
}
