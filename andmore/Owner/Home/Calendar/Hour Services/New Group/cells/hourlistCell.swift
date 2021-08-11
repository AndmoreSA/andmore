//
//  hourlistCell.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 04/06/2021.
//

import UIKit

class hourlistCell: UITableViewCell {
    
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var venueType: UILabel!
    
    var venueSearches: scheduleModel? {
        didSet {
            venueName.text = venueSearches?.venueName
            venueType.text = venueSearches?.venueType
        }
    }

}
