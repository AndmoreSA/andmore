//
//  boodkingDashboardSystem.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 04/06/2021.
//

import Foundation

class boodkingDashboardSystem: NSObject {
    
    
    let username:String
    let venueName:String
    let userID:String
    let id:String
    let bookingStatys:String
    let companyName:String
    let price:String
    let time1:String
    let time2:String
    let time3:String
    let time4:String
    let time5:String
    let userImage:String
    let userbookedEmail:String
    let userbookednumber:String
    let bookingDate:String
    let creationDate: Date
    let type:String
    var shop:ShopSearch?
    let paymentStatus:String
    let justification:String
    let storeImage:String
    let venueID:String
    let ownerUID:String
    let originPrice:Double
    let discount:String
    let numberofbookings:Double
    let priceafterdiscount:Double
    let paymentTransactionId:String

    init(id: String, shop:ShopSearch, dictionary: [String: Any]) {
        self.shop = shop
        self.id = id
        
        self.originPrice = dictionary["originalPrice"] as? Double ?? 0
        self.discount = dictionary["discounet"] as? String ?? ""
        self.numberofbookings = dictionary["numberofTimes"] as? Double ?? 0
        self.priceafterdiscount = dictionary["pricewithDiscuount"] as? Double ?? 0
        self.price = dictionary["price"] as? String ?? ""

        self.paymentTransactionId = dictionary["paymentTransactionId"] as? String ?? ""
        self.username = dictionary["userbookedName"] as? String ?? ""
        self.venueName = dictionary["StoreName"] as? String ?? ""
        self.venueID = dictionary["venueID"] as? String ?? ""
        self.ownerUID = dictionary["ownerUID"] as? String ?? ""
        self.userID = dictionary["UserID"] as? String ?? ""
        self.justification = dictionary["Justification"] as? String ?? ""
        self.bookingDate = dictionary["Date"] as? String ?? ""
        self.bookingStatys = dictionary["bookingStatus"] as? String ?? ""
        self.paymentStatus = dictionary["paymentStatus"] as? String ?? ""
        self.companyName = dictionary["companyName"] as? String ?? ""
        self.type = dictionary["venueType"] as? String ?? ""
        self.time1 = dictionary["time1"] as? String ?? ""
        self.time2 = dictionary["time2"] as? String ?? ""
        self.time3 = dictionary["time3"] as? String ?? ""
        self.time4 = dictionary["time4"] as? String ?? ""
        self.time5 = dictionary["time5"] as? String ?? ""
        self.userImage = dictionary["userImage"] as? String ?? ""
        self.storeImage = dictionary["storeImage"] as? String ?? ""
        self.userbookedEmail = dictionary["userbookedEmail"] as? String ?? ""
        self.userbookednumber = dictionary["userbookedNumber"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        
        self.originPrice = dictionary["originalPrice"] as? Double ?? 0
        self.discount = dictionary["discounet"] as? String ?? ""
        self.numberofbookings = dictionary["numberofTimes"] as? Double ?? 0
        self.priceafterdiscount = dictionary["pricewithDiscuount"] as? Double ?? 0
        self.price = dictionary["price"] as? String ?? ""
        
        self.paymentTransactionId = dictionary["paymentTransactionId"] as? String ?? ""
        self.username = dictionary["userbookedName"] as? String ?? ""
        self.venueName = dictionary["StoreName"] as? String ?? ""
        self.ownerUID = dictionary["ownerUID"] as? String ?? ""
        self.venueID = dictionary["venueID"] as? String ?? ""
        self.userID = dictionary["UserID"] as? String ?? ""
        self.justification = dictionary["Justification"] as? String ?? ""
        self.bookingDate = dictionary["Date"] as? String ?? ""
        self.bookingStatys = dictionary["bookingStatus"] as? String ?? ""
        self.paymentStatus = dictionary["paymentStatus"] as? String ?? ""
        self.companyName = dictionary["companyName"] as? String ?? ""
        self.type = dictionary["venueType"] as? String ?? ""
        self.time1 = dictionary["time1"] as? String ?? ""
        self.time2 = dictionary["time2"] as? String ?? ""
        self.time3 = dictionary["time3"] as? String ?? ""
        self.time4 = dictionary["time4"] as? String ?? ""
        self.time5 = dictionary["time5"] as? String ?? ""
        self.storeImage = dictionary["storeImage"] as? String ?? ""
        self.userImage = dictionary["userImage"] as? String ?? ""
        self.userbookedEmail = dictionary["userbookedEmail"] as? String ?? ""
        self.userbookednumber = dictionary["userbookedNumber"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }

}
