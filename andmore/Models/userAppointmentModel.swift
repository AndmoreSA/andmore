//
//  userAppointmentModel.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 08/06/2021.
//

import Foundation

class userAppointmentModel: NSObject {
    
    let company:String
    let date:String
    let storeID:String
    let postid:String
    let storeName:String
    let time1: String
    let time2: String
    let time3: String
    let time4: String
    let time5: String
    let time6: String
    let time7: String
    let time8: String
    let storeImage:String
    let paymentStatus:String
    let userEmail:String
    let userName:String
    let userPhone:String
    let creationDate: Date
    let city:String
    let bookingStatus:String
    let userbookingStatus:String
    let venueID:String
    let origin:Double
    let discount:String
    let numberofbooking:Double
    let pricewithdiscount:Double
    let price: String


    
    init(id: String, dictionary: [String:Any]) {
        
        self.origin = dictionary["originalPrice"] as? Double ?? 0
        self.discount = dictionary["discounet"] as? String ?? ""
        self.numberofbooking = dictionary["numberofTimes"] as? Double ?? 0
        self.pricewithdiscount = dictionary["pricewithDiscuount"] as? Double ?? 0
        self.price = dictionary["price"] as? String ?? ""
        self.company = dictionary["fullName"] as? String ?? ""
        self.userName = dictionary["userbookedName"] as? String ?? ""
        self.city = dictionary["venueCity"] as? String ?? ""
        self.userEmail = dictionary["userbookedEmail"] as? String ?? ""
        self.userPhone = dictionary["userbookedNumber"] as? String ?? ""
        self.userbookingStatus = dictionary["userBookingStatus"] as? String ?? ""
        self.paymentStatus = dictionary["paymentStatus"] as? String ?? ""
        self.bookingStatus = dictionary["bookingStatus"] as? String ?? ""
        self.storeImage = dictionary["storeImage"] as? String ?? ""
        self.date = dictionary["Date"] as? String ?? ""
        self.storeID = dictionary["StoreID"] as? String ?? ""
        self.venueID = dictionary["venueID"] as? String ?? ""
        self.storeName = dictionary["StoreName"] as? String ?? ""
        self.postid = dictionary["postid"] as? String ?? ""
        self.time1 = dictionary["time1"] as? String ?? ""
        self.time2 = dictionary["time2"] as? String ?? ""
        self.time3 = dictionary["time3"] as? String ?? ""
        self.time4 = dictionary["time4"] as? String ?? ""
        self.time5 = dictionary["time5"] as? String ?? ""
        self.time6 = dictionary["time6"] as? String ?? ""
        self.time7 = dictionary["time7"] as? String ?? ""
        self.time8 = dictionary["time8"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
