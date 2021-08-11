//
//  servicesImageSliderCell.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 03/06/2021.
//

import UIKit
import SDWebImage

class servicesImageSliderCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: String? {
        didSet {
            guard let imagg = image else {return}
            guard let url = URL(string: imagg) else {return}
            imageView.sd_setImage(with: url)
        }
    }
}
