//
//  editServicesImagesCell.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 04/06/2021.
//

import UIKit

class editServicesImagesCell: UICollectionViewCell {
    
    @IBOutlet weak var venueImage: UIImageView!

    var image: String? {
         didSet {
             guard let imagg = image else {return}
             guard let url = URL(string: imagg) else {return}
             venueImage.sd_setImage(with: url)
         }
     }
    
}
