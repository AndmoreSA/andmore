//
//  venueSearch.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 08/06/2021.
//

import Foundation
import CoreLocation


struct venueSearch {
    
    var name: String?
    var shop: String?
    var price:Double?
    var location: CLLocationCoordinate2D?
    var venueImage11: String?
    var latitude2:Double?
    var longitude2:Double?
    
    
    //Venue General Info
    
    var time: String = ""
    var slot: Int = 0
    var id: String?
    var uid: String
    var shopName: String
    var sellerType: String
    var profileImageUrl: String?
    var venueImage1: String?
    var venueImage2: String?
    var venueImage3: String?

    var country: String
    var city: String
    var phone: String
    var opeing: String
    var email: String
    var venueName:String
    var venueType:String
    var venueID:String
    var noOFPEOPLE:String
    var discription:String
    
    // Venue Pricing
    var currencyHour: String
    var currencyDay: String
    var currencyMonth: String
    var perHourPrice: Double
    var perDayPrice: Double
    var perMonthPrice: Double
    var finalCurrency: String
    var finalPrice: Double
    var VenueGender:String
    
    var priceTypeSelection: String
    var priceTypeDiscount: String
    private var _Latitude: Double!
    private var _longitude: Double!
    
    // Venue location
    var latitude:Double! {
        return _Latitude
    }
    
    var longitude:Double! {
        return _longitude
    }

    
    init(name: String?,
         location: CLLocationCoordinate2D?,shop:String?,price:Double?,venueImage1:String?, latitude:Double?,longitude:Double, dictionary: [String: Any]) {
        self.name = name
        self.shop = shop
        self.price = price
        self.location = location
        self.venueImage1 = venueImage1
        self.latitude2 = latitude
        self.longitude2 = longitude
        self.uid = dictionary["uid"] as? String ?? ""
               self.sellerType = dictionary["ShopType"] as? String ?? ""
               self.shopName = dictionary["fullName"] as? String ?? ""
               self.venueName = dictionary["VenueName"] as? String ?? ""
        self.VenueGender = dictionary["VenueGender"] as? String ?? ""
        self.venueID = dictionary["VenueId"] as? String ?? ""
               self.venueType = dictionary["venueType"] as? String ?? ""
               self.city = dictionary["city"] as? String ?? ""
               self.country = dictionary["country"] as? String ?? ""
               self.email = dictionary["email"] as? String ?? ""
               self.opeing = dictionary["zipCodeField"] as? String ?? ""
               self.profileImageUrl = dictionary["profileImageURL"] as? String
               self.venueImage1 = dictionary["imageUrl1"] as? String
               self.venueImage2 = dictionary["imageUrl2"] as? String
               self.venueImage3 = dictionary["imageUrl3"] as? String
               self.discription = dictionary["VenueDiscription"] as? String ?? ""


               self.phone = dictionary["phoneNumber"]
                   as? String ?? ""

        self.currencyHour = dictionary["CurrencyHour"] as? String ?? ""
             self.currencyDay = dictionary["CurrencyDay"] as? String ?? ""
             self.currencyMonth = dictionary["CurrencyMonth"] as? String ?? ""
             self.perHourPrice = dictionary["perHourPrice"] as? Double ?? 0
              self.perDayPrice = dictionary["perDayPrice"] as? Double ?? 0
              self.perMonthPrice = dictionary["perMonthPrice"] as? Double ?? 0
              self.finalCurrency = dictionary["FinalCurrency"] as? String ?? ""
               self.finalPrice = dictionary["FinalPrice"] as? Double ?? 0
               
               self.priceTypeSelection = dictionary["PriceTypeSelection"] as? String ?? ""
               self.priceTypeDiscount = dictionary["PriceTypeDiscount"] as? String ?? ""
               
               self.noOFPEOPLE = dictionary["NumberofPeople"] as? String ?? ""

        
    }
    
    
    
    
    init(name: String, dictionary: [String: Any]) {
//        self.id = id
        self.venueName = name
        self.uid = dictionary["uid"] as? String ?? ""
        self.sellerType = dictionary["ShopType"] as? String ?? ""
        self.shopName = dictionary["fullName"] as? String ?? ""
        self.venueName = dictionary["VenueName"] as? String ?? ""
        self.venueType = dictionary["venueType"] as? String ?? ""
        self.VenueGender = dictionary["VenueGender"] as? String ?? ""
        self.city = dictionary["city"] as? String ?? ""
        self.country = dictionary["country"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.opeing = dictionary["zipCodeField"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageURL"] as? String
        self.venueImage1 = dictionary["imageUrl1"] as? String
        self.venueImage2 = dictionary["imageUrl2"] as? String
        self.venueImage3 = dictionary["imageUrl3"] as? String
        self.discription = dictionary["VenueDiscription"] as? String ?? ""

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
      self.currencyMonth = dictionary["CurrencyMonth"] as? String ?? ""
      self.perHourPrice = dictionary["perHourPrice"] as? Double ?? 0
       self.perDayPrice = dictionary["perDayPrice"] as? Double ?? 0
       self.perMonthPrice = dictionary["perMonthPrice"] as? Double ?? 0
       self.finalCurrency = dictionary["FinalCurrency"] as? String ?? ""
        self.finalPrice = dictionary["FinalPrice"] as? Double ?? 0
        
        self.priceTypeSelection = dictionary["PriceTypeSelection"] as? String ?? ""
        self.priceTypeDiscount = dictionary["PriceTypeDiscount"] as? String ?? ""
        
        self.noOFPEOPLE = dictionary["NumberofPeople"] as? String ?? ""
        
      
        self.name = dictionary["VenueName"] as? String ?? ""
               self.shop = dictionary["VenueName"] as? String ?? ""
               self.price = dictionary["FinalPrice"] as? Double ?? 0
        self.location = nil
               self.venueImage11 = dictionary["imageUrl1"] as? String
               self.latitude2 = dictionary["lat"] as? Double ?? 0
               self.longitude2 = dictionary["long"] as? Double ?? 0
        self.venueID = dictionary["VenueId"] as? String ?? ""
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
