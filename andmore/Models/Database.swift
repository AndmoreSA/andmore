//
//  Database.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 08/06/2021.
//

import Foundation
import Firebase

extension Database {
    
    static func fetchShopwithUID(name:String,type:String,country:String,city:String, completion: @escaping (venueSearch)-> ()) {

        Database.database().reference().child("Services").child(country).child(city).child(type).child(name).observeSingleEvent(of: .value) { (snapshot) in
            guard let shopDictionary = snapshot.value as? [String:Any] else {return}
            let shop = venueSearch(name: name, dictionary: shopDictionary)
            completion(shop)
        }
    }
    
    static func fetchUserithAppointmetn(uidUser:String,selectedDate:String,uidShop:String, id:String, completion: @escaping (userAppointmentModel)-> ()) {

        Database.database().reference().child("users").child("profile").child(uidUser).child("myAppointments").child(selectedDate).child(uidShop).child(id).observeSingleEvent(of: .value) { (snapshot) in
            guard let shopDictionary = snapshot.value as? [String:Any] else {return}
            let shop = userAppointmentModel(id: id, dictionary: shopDictionary)
            completion(shop)

        }
    }
    
    static func fetchShopwithUID3(name:String,type:String,country:String,city:String,id:String,price:String,date:String, completion: @escaping (venueCalendar)-> ()) {

        Database.database().reference().child("Services").child(country).child(city).child(type).child(name).child("mySchedule").child(price).child(id).child("dates").child(date).observeSingleEvent(of: .value) { (snapshot) in
                guard let shopDictionary = snapshot.value as? [String:Any] else {return}
                let shop = venueCalendar(id: id, dictionary: shopDictionary)
                completion(shop)
            }
        }
    
    
    static func fetchShopwithUID2(name:String,type:String,country:String,city:String,id:String,price:String, completion: @escaping (venueSearch)-> ()) {

        Database.database().reference().child("Services").child(country).child(city).child(type).child(name).child("mySchedule").child(price).child(id).child("dates").observeSingleEvent(of: .value) { (snapshot) in
                guard let shopDictionary = snapshot.value as? [String:Any] else {return}
            let shop = venueSearch(name: name, dictionary: shopDictionary)
                completion(shop)
            }
        }
}
