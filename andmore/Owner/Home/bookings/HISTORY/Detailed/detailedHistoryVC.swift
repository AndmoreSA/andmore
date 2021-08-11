//
//  detailedHistoryVC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 04/06/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD
import MessageUI

class detailedHistoryVC: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, MFMailComposeViewControllerDelegate {

    
       // MARK:- Outlets
       @IBOutlet weak var confirmationLabel: UILabel!
       @IBOutlet weak var venueName: UILabel!
       @IBOutlet weak var reservationDate: UILabel!
       @IBOutlet weak var reservationTimeCollectionView: UICollectionView!
       @IBOutlet weak var userNameLabel: UILabel!
       @IBOutlet weak var bookingPrice: UILabel!
       @IBOutlet weak var emaillabel: UILabel!
       @IBOutlet weak var phoneLabel: UILabel!

    // MARK:- Variables
         var selectedShop: boodkingDashboardSystem? {
             didSet {
                 name = selectedShop!.venueName
                 print(name)
                
             }
         }


         var TimeSlotList = Array<TimeSlot>()
         var bookedID:String = ""
         var name:String = ""
    var venueID:String = ""
         
         
         override func viewDidLoad() {
             super.viewDidLoad()
             
             title = selectedShop?.username
             retrieve()
             retreiveUserChosenTime()


         }
    
         
         func retrieve() {
             
             
             if let confirmationNumber = selectedShop?.id {
                 confirmationLabel.text = confirmationNumber
                 self.bookedID = confirmationNumber
             } else {
                 confirmationLabel.isHidden = true
             }
            
            if let venueIDZ = selectedShop?.venueID {
                venueID = venueIDZ
            }
             
             
             // 2
             
             if let venueNames = selectedShop?.venueName {
                 venueName.text = venueNames
                 self.name = venueNames
             } else {
                 venueName.isHidden = true
             }
             
             
             // 3
             
             if let bookedDate = selectedShop?.bookingDate {
                 reservationDate.text = bookedDate
             } else {
                 reservationDate.isHidden = true
             }

             
             // 6
             
             if let usernames = selectedShop?.username {
                 userNameLabel.text = usernames
             } else {
                 userNameLabel.isHidden = true
             }
             
             
             // 7
             
             if let email = selectedShop?.userbookedEmail {
                 emaillabel.text = email
             } else {
                 emaillabel.isHidden = true
             }
             
             // 8
             
             if let phone = selectedShop?.userbookednumber {
                 phoneLabel.text = phone
             } else {
                 phoneLabel.isHidden = true
             }
           
           // 9
           
           if let pricee = selectedShop?.price {
               bookingPrice.text = pricee
           } else {
               bookingPrice.isHidden = true
           }
         }
         
         
            func retreiveUserChosenTime() {

               Database.database().reference().child("VenueAppointments").child("past").child(venueID).child(bookedID).child("times").observeSingleEvent(of: .value) { (snapshot) in
                     print(snapshot)
                     self.TimeSlotList.removeAll()

                         if let snapDict =  snapshot.value as? [String:AnyObject]{
                                 for each in snapDict{
                                     let timeSlot = TimeSlot()
                                     timeSlot.time = each.value as! String
                                     self.TimeSlotList.append(timeSlot)
                                     print(timeSlot)
                                     self.TimeSlotList.sort { $0.time.compare($1.time, options: .numeric) == .orderedAscending }
                                 }
                            let timeSlot = TimeSlot()
                            self.TimeSlotList.append(timeSlot)
                                 self.reservationTimeCollectionView.reloadData()
                             }
                     
                     
                         }
                 }
         
         
      // MARK:- CollectionViews
                  
      func numberOfSections(in collectionView: UICollectionView) -> Int {
             return 1
         }
         
         func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

                 return TimeSlotList.count
         }
         
         func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                 let cell = reservationTimeCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! timeHistoryCell
                 
                     cell.timeLabel.text = TimeSlotList[indexPath.row].time
             
                     return cell
         }
       
         func configuredMailComposeViewController() -> MFMailComposeViewController {
                let mailComposerVC = MFMailComposeViewController()
                mailComposerVC.mailComposeDelegate = self
                mailComposerVC.setToRecipients(["support@findsquare.co"])
                mailComposerVC.setSubject("App FeedBack")
                mailComposerVC.setMessageBody("Hi team!\n\nI we are \(name) would like to share the following feedback...\n", isHTML: false)
                return mailComposerVC
            }
            
            func showSendMailErrorAlert() {
                let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your Device Could not Send E-mail. Please Check E-mail Configuration And Try Again", delegate: self, cancelButtonTitle: "OK")
                sendMailErrorAlert.show()
            }
            func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
                controller.dismiss(animated: true)
            }
         
         
         override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             if indexPath.section == 3 && indexPath.row == 0 {
             let mailComposeViewController = self.configuredMailComposeViewController()
             if MFMailComposeViewController.canSendMail() {
                 self.present(mailComposeViewController, animated: true, completion: nil)
             } else {
                 self.showSendMailErrorAlert()
             }
             }
             
         }
      // MARK:- Actions
      @IBAction func backbtnPressed(_ sender: Any) {
          self.dismiss(animated: true, completion: nil)
      }
}
