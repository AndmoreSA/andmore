//
//  bookingServicesCell.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 04/06/2021.
//

import UIKit

class bookingServicesCell: UITableViewCell {

    @IBOutlet weak var venueName: UILabel!

    
     var venueSearches: ShopSearch? {
         didSet {
             
         venueName.text = venueSearches?.venueName

         }
     }


}
