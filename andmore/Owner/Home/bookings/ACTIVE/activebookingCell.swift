//
//  activebookingCell.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 04/06/2021.
//

import UIKit

protocol approveDelegate {
    func approve(username:String,bookedID:String,venueName:String,bookingDate:String,VenueID:String)
}

class activebookingCell: UITableViewCell {
    
    // MARK:- Outlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var dateBooked: UILabel!
    @IBOutlet weak var statusBooked: UILabel!
    @IBOutlet weak var approveBtn: UIButton!
    
    
    var delegate1: approveDelegate?

    
    var venue:boodkingDashboardSystem? {
        didSet {
            userName.text = venue?.username
            dateBooked.text = venue?.bookingDate
            statusBooked.text = venue?.bookingStatys

            if venue?.bookingStatys == "pending" {
                approveBtn.isHidden = false
            } else {
                approveBtn.isHidden = true
            }
               
            guard let imageUrl1 = venue?.userImage else { return }
            guard let url1 = URL(string: imageUrl1) else {return}
            
            userImage.sd_setImage(with: url1)
            
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        approveBtn.layer.cornerRadius = approveBtn.bounds.height/2

        userImage.layer.cornerRadius = userImage.frame.size.width / 2
              userImage.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func approvePressed(_ sender: Any) {
        self.delegate1?.approve(username: venue!.userID,bookedID:venue!.id,venueName:venue!.venueName,bookingDate:venue!.bookingDate, VenueID: venue!.venueID)
    }
    
}
