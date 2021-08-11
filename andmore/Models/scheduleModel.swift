//
//  scheduleModel.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 04/06/2021.
//

import Foundation
import UIKit

class scheduleModel:NSObject {
    
    let venueName:String
    let venueType:String
    let uid: String
    let venueID: String
    
    init(id: String, dictionary: [String: Any]) {
        
    self.uid = dictionary["uid"] as? String ?? ""
    self.venueName = dictionary["venueName"] as? String ?? ""
    self.venueType = dictionary["venueType"] as? String ?? ""
    self.venueID = dictionary["venueID"] as? String ?? ""
    }
}
