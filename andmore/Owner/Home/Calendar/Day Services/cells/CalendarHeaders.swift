//
//  CalendarHeaders.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 04/06/2021.
//

import UIKit
import JTAppleCalendar

class CalendarHeaders: JTACMonthReusableView {
    
    @IBOutlet weak var daylabels: UILabel!
    
    func showDate(from date: String) {
        
        daylabels.text = "MMMM" + " " + "YYYY"
    }
        
}
