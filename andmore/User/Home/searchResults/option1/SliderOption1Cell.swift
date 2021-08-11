//
//  SliderOption1Cell.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 08/06/2021.
//

import UIKit

class SliderOption1Cell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: String? {
        didSet {
            guard let imagg = image else {return}
            guard let url = URL(string: imagg) else {return}
            imageView.sd_setImage(with: url)
        }
    }
    
}
