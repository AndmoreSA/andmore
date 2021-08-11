//
//  myservicess2Cell.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 04/06/2021.
//

import UIKit

class myservicess2Cell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var noOfPeople: UILabel!
    @IBOutlet weak var venuePrice: UILabel!
    @IBOutlet weak var venueCurrency: UILabel!
    @IBOutlet weak var venueDiscription: UILabel!
    
    
    
    //MARK:- Variables
    
    var venueSearches: ShopSearch? {
        didSet {
            
        venueName.text = venueSearches?.venueName
            venueDiscription.text = venueSearches?.discription
        venueCurrency.text = venueSearches?.finalCurrency
        noOfPeople.text = venueSearches?.noOFPEOPLE
        venuePrice.text = "\(String(format: "%.02f", venueSearches?.finalPrice ?? 0))"
        }
    }

}
