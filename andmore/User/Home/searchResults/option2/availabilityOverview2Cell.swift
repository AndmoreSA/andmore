//
//  availabilityOverview2Cell.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 08/06/2021.
//

import UIKit

class availabilityOverview2Cell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    override func layoutSubviews() {
        
        // cell rounded section
        self.layer.cornerRadius = 15.0
        self.layer.borderWidth = 0.5
        self.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        self.layer.masksToBounds = true
    }
    
}
