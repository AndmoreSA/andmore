//
//  myservicesCell.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 02/06/2021.
//

import UIKit

class myservicesCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var storeLogo: UIImageView!
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var noOfPeople: UILabel!
    @IBOutlet weak var venuePrice: UILabel!
    @IBOutlet weak var venueCurrency: UILabel!
    @IBOutlet weak var venueType: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }
    
    
    
    //MARK:- Variables
    
    var venueSearches: ShopSearch? {
        didSet {
            
        venueName.text = venueSearches?.venueName
            storeName.text = venueSearches?.shopName
        venueCurrency.text = venueSearches?.finalCurrency
        venueType.text = venueSearches?.priceTypeSelection
        noOfPeople.text = venueSearches?.noOFPEOPLE
        venuePrice.text = "\(String(format: "%.02f", venueSearches?.finalPrice ?? 0))"

        guard let imageUrl1 = venueSearches?.venueImage1 else { return }
        guard let url1 = URL(string: imageUrl1) else {return}
        
        storeLogo.sd_setImage(with: url1)
        }
    }

}
