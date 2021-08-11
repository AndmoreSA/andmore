//
//  myAppoitnments1Cell.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 08/06/2021.
//

import UIKit
import Firebase

class myAppoitnments1Cell: UITableViewCell , UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    // Outlets
    @IBOutlet weak var timeBookedLabel: UILabel!
    @IBOutlet weak var venueNameTxt: UILabel!
    @IBOutlet weak var companyNameTxt: UILabel!
    @IBOutlet weak var companyImage: UIImageView!
    @IBOutlet weak var timeCollectionView: UICollectionView!
    @IBOutlet weak var fullDaylabel: UILabel!
    @IBOutlet weak var pendingLbl: UILabel!
    @IBOutlet weak var paymentlbl: UILabel!
    
    
    var TimeSlotList = Array<TimeSlot>()
    var UserSearches: userAppointmentModel? {
        didSet {
            pendingLbl.text = UserSearches?.bookingStatus
            timeBookedLabel.text = UserSearches?.date
            venueNameTxt.text = UserSearches?.storeName
            companyNameTxt.text = UserSearches?.company
            paymentlbl.text = UserSearches?.userbookingStatus
            
            guard let image = UserSearches?.storeImage else {return}
            guard let url = URL(string: image) else {return}
            self.companyImage.sd_setImage(with: url)
            
            retreiveUserChosenTime()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
            
        timeCollectionView.delegate = self
        timeCollectionView.dataSource = self
        
        companyImage.layer.cornerRadius = companyImage.frame.size.width / 2
        companyImage.clipsToBounds = true
  }

    
    func retreiveUserChosenTime() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let venue = UserSearches?.venueID else {return}
        guard let id = UserSearches?.postid else {return}
        guard let selecteddate = UserSearches?.date else {return}
        Database.database().reference().child("users").child("profile").child(uid).child("myAppointments").child(selecteddate).child(venue).child(id).child("times").observeSingleEvent(of: .value) { (snapshot) in
             print(snapshot)
             self.TimeSlotList.removeAll()

                 if let snapDict =  snapshot.value as? [String:AnyObject]{
                         for each in snapDict{
                            self.fullDaylabel.isHidden = true
                             let timeSlot = TimeSlot()
                             timeSlot.time = each.value as! String
                             self.TimeSlotList.append(timeSlot)
                             print(timeSlot)
                             self.TimeSlotList.sort { $0.time.compare($1.time, options: .numeric) == .orderedAscending }
                         }
                         self.timeCollectionView.reloadData()
                 } else {
                    self.fullDaylabel.isHidden = false
                    self.timeCollectionView.reloadData()
                    self.TimeSlotList.removeAll()
            }
            }
         }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TimeSlotList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = timeCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! timetimeeCell
        
        cell.timeLabe.text = TimeSlotList[indexPath.row].time
        
        return cell
    }
    
    
}
