//
//  homeUserCell.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 08/06/2021.
//

import UIKit

class homeUserCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var serviceNameTxt: UILabel!
    
    override func layoutSubviews() {
        
        // cell rounded section
        self.layer.cornerRadius = 15.0
        self.layer.masksToBounds = true
    }
}
