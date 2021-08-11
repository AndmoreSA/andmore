//
//  venueCalendar.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 08/06/2021.
//

import Foundation

class venueCalendar: NSObject {
    
    
    //Venue General Info
    
    var time: String = ""
    var slot: Int = 0
    var id: String
    let uid: String
    let shopName: String
    let sellerType: String
    let profileImageUrl: String?
    let venueImage1: String?
    let venueImage2: String?
    let venueImage3: String?

    let country: String
    let city: String
    let phone: String
    let opeing: String
    let email: String
    var venueName:String
    let venueType:String
    
    // Venue Properties
    
    let allowFoodandDrink: String
    let allowBugs: String
    let allowComfortable: String
    let allowFlexibleCancelation: String
    let allowFreePapersandPins: String
    let allowTelephone:String
    let allowWifi:String
    let allowOnSite:String
    let noOFPEOPLE:String
    
    

    
    // Venue timing
    
    let fromSunday: String
    let fromMonday: String
    let fromTuesday: String
    let fromWednesday: String
    let fromThursday: String
    let fromFriday: String
    let fromSaturday: String

    let toSunday: String
    let toMonday: String
    let toTuesday: String
    let toWednesday: String
    let toThursday: String
    let toFriday: String
    let toSaturday: String
    
    // Venue Pricing
    let currencyHour: String
    let currencyDay: String
    let currencyMonth: String
    let perHourPrice: Double
    let perDayPrice: Double
    let perMonthPrice: Double
    let finalCurrency: String
    let finalPrice: Double?
    
    let priceTypeSelection: String
    let priceTypeDiscount: String
    
    
    // Venue location
    
   

    
    
    
    init(id:String, dictionary: [String: Any]) {
//        self.venueName = name
        self.id = id
        self.uid = dictionary["uid"] as? String ?? ""
        self.sellerType = dictionary["ShopType"] as? String ?? ""
        self.shopName = dictionary["companyName"] as? String ?? ""
        self.venueName = dictionary["VenueName"] as? String ?? ""
        self.venueType = dictionary["venueType"] as? String ?? ""
        self.city = dictionary["cityField"] as? String ?? ""
        self.country = dictionary["countryField"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.opeing = dictionary["zipCodeField"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageURL"] as? String
        self.venueImage1 = dictionary["imageUrl1"] as? String
        self.venueImage2 = dictionary["imageUrl2"] as? String
        self.venueImage3 = dictionary["imageUrl3"] as? String


        self.phone = dictionary["phoneNumber"]
            as? String ?? ""
        
        self.allowFoodandDrink = dictionary["Allow Food & Drink"] as? String ?? ""
        self.allowBugs = dictionary["Blugs"] as? String ?? ""
        self.allowComfortable = dictionary["Comfortable & bright"] as? String ?? ""
        self.allowFlexibleCancelation = dictionary["Flexible Cancellation"] as? String ?? ""
        self.allowFreePapersandPins = dictionary["Free Papers & Pins"] as? String ?? ""
        self.allowTelephone = dictionary["Free Telephone"] as? String ?? ""
        self.allowWifi = dictionary["wifi"] as? String ?? ""
        self.allowOnSite = dictionary["On Site Administrator"] as? String ?? ""
        
//        if let latitude = dictionary["lat"] as? Double {
//            self._Latitude = latitude
//        }
//
//        if let longitude = dictionary["long"] as? Double {
//            self._longitude = longitude
//        }
        
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
        
        self.fromSunday = dictionary["sundayFrom"] as? String ?? ""
        self.fromMonday = dictionary["mondayFrom"] as? String ?? ""
        self.fromTuesday = dictionary["tuesdayFrom"] as? String ?? ""
        self.fromWednesday = dictionary["wednesdayFrom"] as? String ?? ""
        self.fromThursday = dictionary["thursdayFrom"] as? String ?? ""
        self.fromFriday = dictionary["fridayFrom"] as? String ?? ""
        self.fromSaturday = dictionary["saturdayFrom"] as? String ?? ""
        
        
        self.toSunday = dictionary["sundayTo"] as? String ?? ""
        self.toMonday = dictionary["mondayTo"] as? String ?? ""
        self.toTuesday = dictionary["tuesdayTo"] as? String ?? ""
        self.toWednesday = dictionary["wednesdayTo"] as? String ?? ""
        self.toThursday = dictionary["thursdayTo"] as? String ?? ""
        self.toFriday = dictionary["fridayTo"] as? String ?? ""
        self.toSaturday = dictionary["saturdayTo"] as? String ?? ""
        
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
