//
//  shopsSearch.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 02/06/2021.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import Firebase

class ShopSearch: NSObject {
    
    
    //Venue General Info
    var isFollowed = false

    var time: String = ""
    var slot: Int = 0
    var id: String?
    var uid: String
    let shopName: String
    let sellerType: String
    let profileImageUrl: String?
    let venueImage1: String?
    let venueImage2: String?
    let venueImage3: String?
    let creationDate: Date
    

    let country: String
    let city: String
    let phone: String
    let opeing: String
    let email: String
    let venueName:String
    let venueID:String
    let venueType:String
    let discription:String

    
    
    
    let noOFPEOPLE:String
    
    // Venue Pricing
    let currencyHour: String
    let currencyDay: String
    let perHourPrice: Double
    let perDayPrice: Double
    let finalCurrency: String
    let finalPrice: Double?
    
    let priceTypeSelection: String
    let priceTypeDiscount: String
    
    
    // Venue location


    var distance: Double?
    private var _Latitude: Double!
    private var _longitude: Double!
    
    var latitude:Double! {
        return _Latitude
    }
    
    var longitude:Double! {
        return _longitude
    }
    
    var location:CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: self.location)
    }
    
   

    
    
    
    init(id: String, dictionary: [String: Any]) {
        
        self.id = id
        self.uid = dictionary["uid"] as? String ?? ""
        self.sellerType = dictionary["ShopType"] as? String ?? ""
        self.discription = dictionary["VenueDiscription"] as? String ?? ""
        self.shopName = dictionary["fullName"] as? String ?? ""
        self.venueID = dictionary["VenueId"] as? String ?? ""
        self.venueName = dictionary["VenueName"] as? String ?? ""
        self.venueType = dictionary["venueType"] as? String ?? ""
        self.city = dictionary["city"] as? String ?? ""
        self.country = dictionary["country"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.opeing = dictionary["zipCodeField"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageURL"] as? String
        self.venueImage1 = dictionary["imageUrl1"] as? String
        self.venueImage2 = dictionary["imageUrl2"] as? String
        self.venueImage3 = dictionary["imageUrl3"] as? String
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)

        self.phone = dictionary["phoneNumber"]
            as? String ?? ""
        

        
        
        
        if let latitude = dictionary["lat"] as? Double {
            self._Latitude = latitude
        }
        
        if let longitude = dictionary["long"] as? Double {
            self._longitude = longitude
        }
        
      self.currencyHour = dictionary["CurrencyHour"] as? String ?? ""
      self.currencyDay = dictionary["CurrencyDay"] as? String ?? ""
      self.perHourPrice = dictionary["perHourPrice"] as? Double ?? 0
       self.perDayPrice = dictionary["perDayPrice"] as? Double ?? 0
       self.finalCurrency = dictionary["FinalCurrency"] as? String ?? ""
        self.finalPrice = dictionary["FinalPrice"] as? Double ?? 0
        
        self.priceTypeSelection = dictionary["PriceTypeSelection"] as? String ?? ""
        self.priceTypeDiscount = dictionary["PriceTypeDiscount"] as? String ?? ""
        
        self.noOFPEOPLE = dictionary["NumberofPeople"] as? String ?? ""
        
       
        
    }
    
    
    static func prepareValues(key: String, values: [String:Any]) -> (lat:String,long:String) {
        var _lat = ""
        var _long = ""
        
        if let _values = values[key] as? [String:Any] {
            if let lat = _values["lat"] as? Double {
                _lat = String(describing: lat)
                
                if let long = _values["long"] as? Double {
                    _long = String(describing: long)
                }
            }
        }
        return("\(_lat)","\(_long)")
    }
    
}

struct shop {
    let coordinate: CLLocation
}


internal class shopDetail {
    internal let id: String
    internal let lat: String
    internal let long: String
    
    
    init(key:String, values: [String:Any]) {
        let userValue = shopDetail.prepareValues(key: key, values: values)
        self.id = key
        self.lat = userValue.lat
        self.long = userValue.long
    }
    
    init(id:String) {
        self.id = id
        self.lat = ""
        self.long = ""
    }
    
    static func prepareValues(key: String, values: [String:Any]) -> (lat:String,long:String) {
        var _lat = ""
        var _long = ""
        
        if let _values = values[key] as? [String:Any] {
            if let lat = _values["lat"] as? Double {
                _lat = String(describing: lat)
                
                if let long = _values["long"] as? Double {
                    _long = String(describing: long)
                }
            }
        }
        return("\(_lat)","\(_long)")
    }
    

    
    
}
