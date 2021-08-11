//
//  searchResultsoption2Cell.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 08/06/2021.
//

import UIKit

class searchResultsoption2Cell: UITableViewCell {

    
    // MARK:- Outlets
    @IBOutlet weak var percentageView: UIView!
    @IBOutlet weak var discountTxt: UILabel!
    @IBOutlet weak var offLabel: UILabel!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var venueDistance: UILabel!
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var venueCapacity: UILabel!
    @IBOutlet weak var venueType: UILabel!
    @IBOutlet weak var currencyTxt: UILabel!
    @IBOutlet weak var priceTxt: UILabel!
    @IBOutlet weak var finalCurrencyTxt: UILabel!
    @IBOutlet weak var finalPriceTxt: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    
    
    var venueSearches: venueSearch? {
           didSet {
            
            if venueSearches?.currencyHour == "" {
                currencyTxt.text = "SAR"
            } else {
                currencyTxt.text = venueSearches?.currencyHour
            }
            
            if venueSearches?.finalCurrency == "" {
                finalCurrencyTxt.text = "SAR"
            } else {
                finalCurrencyTxt.text = venueSearches?.finalCurrency
            }
               
           venueName.text = venueSearches?.venueName
           venueType.text = venueSearches?.venueType
            companyName.text = venueSearches?.shopName
           venueCapacity.text = venueSearches?.noOFPEOPLE
            

            priceTxt.text = "\(String(format: "%.02f", venueSearches?.finalPrice ?? 0))"
            discountTxt.text = venueSearches?.priceTypeDiscount
            
            if venueSearches?.priceTypeDiscount == "0%" {
                
                self.percentageView.isHidden = true
                self.discountTxt.isHidden = true
                self.offLabel.isHidden = true
                self.currencyTxt.isHidden = true
                self.priceTxt.isHidden = true
                self.lineView.isHidden = true
                
            } else {
                
                self.percentageView.isHidden = false
                self.discountTxt.isHidden = false
                self.offLabel.isHidden = false
                self.currencyTxt.isHidden = false
                self.priceTxt.isHidden = false
                self.lineView.isHidden = false
                
            }

            venueType.text = venueSearches?.priceTypeSelection
            
            if venueSearches?.priceTypeSelection == "Hour" {
                          finalPriceTxt.text = "\(String(format: "%.02f", venueSearches?.perHourPrice ?? 0))"
            } else if venueSearches?.priceTypeSelection == "Day" {
                           finalPriceTxt.text = "\(String(format: "%.02f", venueSearches?.perDayPrice ?? 0))"
            }
           }
       }

}
