//
//  cancelledBookingCell.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 04/06/2021.
//

import UIKit

class cancelledBookingCell: UITableViewCell {

    
    // MARK:- Outlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var dateBooked: UILabel!
    @IBOutlet weak var statusBooked: UILabel!
    
       var venue:boodkingDashboardSystem? {
             didSet {
                 userName.text = venue?.username
                 dateBooked.text = venue?.bookingDate
                 statusBooked.text = venue?.bookingStatys
                    
                guard let imageUrl1 = venue?.userImage else { return }
                 guard let url1 = URL(string: imageUrl1) else {return}
                 
                 userImage.sd_setImage(with: url1)
                 
             }
         }
         
         

         override func awakeFromNib() {
             super.awakeFromNib()
             userImage.layer.cornerRadius = userImage.frame.size.width / 2
                   userImage.clipsToBounds = true
             
         }

    
}
