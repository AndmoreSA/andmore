//
//  detailedActiveVC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 04/06/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Loaf
import JGProgressHUD
import MessageUI

class detailedActiveVC: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, MFMailComposeViewControllerDelegate {

    
   
    // MARK:- Outlets
    @IBOutlet weak var paymentStatus: UILabel!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var reservationDate: UILabel!
    @IBOutlet weak var reservationTimeCollectionView: UICollectionView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bookingStatus: UILabel!
    @IBOutlet weak var bookingPrice: UILabel!
    @IBOutlet weak var emaillabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var cancelBtnP: UIBarButtonItem!
    @IBOutlet weak var pastBtnp: UIBarButtonItem!

    
     // MARK:- Variables
        var arrSelectedDatae = [String]()

        var selectedShop: boodkingDashboardSystem? {
            didSet {
                name = selectedShop!.venueName
                print(name)
            }
        }
        var segment1:String!
        var segment2:String!
        var TimeSlotList = [TimeSlot]()
        var sttdd = [String]()
        var bookedID:String = ""
        var name:String = ""
        var cities:String = ""
        var countries:String = ""
        var owneruid:String = ""
        var types:String = ""
        var paymentSt:String = ""
        var storeImage:String = ""
        var companyName:String = ""
        var str:String = ""
        var venueID:String = ""

            
            override func viewDidLoad() {
                super.viewDidLoad()
                
                title = selectedShop?.username
                retrieve()
                retreiveUserChosenTime()
                retrieveVenueInfo()
                
                if paymentStatus.text == "Paid" {
                    pastBtnp.isEnabled = true
                    cancelBtnP.isEnabled = false
                } else {
                    cancelBtnP.isEnabled = true
                    pastBtnp.isEnabled = false
                }
                
            }
            
            func retrieveVenueInfo() {
                guard let uid = Auth.auth().currentUser?.uid else {return}
                
                Database.database().reference().child("All").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                    let dict = snapshot.value as? NSDictionary
                    self.companyName = dict?["fullName"] as? String ?? ""
                    self.storeImage = dict? ["profileImageURL"] as? String ?? ""
                    self.cities = dict?["city"] as? String ?? ""
                    self.countries = dict?["country"] as? String ?? ""
                    self.owneruid = dict?["uid"] as? String ?? ""
                }
            }
            
            func retrieve() {
                
                if let confirmationNumber = selectedShop?.id {
                    confirmationLabel.text = confirmationNumber
                    self.bookedID = confirmationNumber
                } else {
                    confirmationLabel.isHidden = true
                }
                        
                //2
                
                if let venueNames = selectedShop?.venueName {
                    venueName.text = venueNames
                    self.name = venueNames
                } else {
                    venueName.isHidden = true
                }
                
                if let venueIDZ = selectedShop?.venueID {
                    venueID = venueIDZ
                }
                
                if let venueType = selectedShop?.type {
                    self.types = venueType
                }
                
                
                //3
                
                if let bookedDate = selectedShop?.bookingDate {
                    reservationDate.text = bookedDate
                } else {
                    reservationDate.isHidden = true
                }

                //4
                
                if let status = selectedShop?.bookingStatys {
                    bookingStatus.text = status
                } else {
                    bookingStatus.isHidden = true
                }
                
                if let status2 = selectedShop?.paymentStatus {
                    paymentSt = status2
                    paymentStatus.text = status2
                } else {
                    paymentStatus.isHidden = true
                }
                
                //5
                if let price = selectedShop?.price {
                    bookingPrice.text = "\(price)"
                } else {
                    bookingPrice.isHidden = true
                }
                
                //6
                
                if let usernames = selectedShop?.username {
                    userNameLabel.text = usernames
                } else {
                    userNameLabel.isHidden = true
                }
                
                
                //7
                
                if let email = selectedShop?.userbookedEmail {
                    emaillabel.text = email
                } else {
                    emaillabel.isHidden = true
                }
                
                //8
                
                if let phone = selectedShop?.userbookednumber {
                    phoneLabel.text = phone
                } else {
                    phoneLabel.isHidden = true
                }
            }
            
            
        func retreiveUserChosenTime() {

        Database.database().reference().child("VenueAppointments").child("Active").child(venueID).child(bookedID).child("times").observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            self.TimeSlotList.removeAll()

                if let snapDict =  snapshot.value as? [String:Any]{
                        for each in snapDict{
                            let timeSlot = TimeSlot()
                            timeSlot.time = each.value as! String
                            let p = each.value
                            self.TimeSlotList.append(timeSlot)
                            print(p)
                            self.TimeSlotList.sort { $0.time.compare($1.time, options: .numeric) == .orderedAscending }
                    }
                    let timeSlot = TimeSlot()
                    self.TimeSlotList.append(timeSlot)
                    self.reservationTimeCollectionView.reloadData()
                }
            }
        }

         // MARK:- CollectionViews
            
            func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

                return TimeSlotList.count
            }
            
            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = reservationTimeCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! timeactiveCell
                    
                cell.timeLabel.text = TimeSlotList[indexPath.row].time
                
                self.str = TimeSlotList[indexPath.row].time
                
                arrSelectedDatae.append(str)
                print(str)
                print(arrSelectedDatae)
                
                return cell
            }
            
            // MARK:- Actions
            @IBAction func backbtnPressed(_ sender: Any) {
                self.dismiss(animated: true, completion: nil)
            }
            
            
        func CancelBooking(string:String) {
                
                CancelChosenTime()
                
                let hud = JGProgressHUD(style: .dark)
                       hud.indicatorView = JGProgressHUDRingIndicatorView()
                       hud.textLabel.text = "Uploading"
                       hud.show(in: view)
                       
                       guard let venue = selectedShop?.venueName else {return}
                       print(venue)
                       guard let bookedID = selectedShop?.id else {return}
                       
                       guard let bookedDate = selectedShop?.bookingDate else {return}
                       guard let usernames = selectedShop?.username else {return}
                       guard let phone = selectedShop?.userbookednumber else {return}
                       guard let email = selectedShop?.userbookedEmail else {return}
                       guard let image = selectedShop?.userImage else {return}
                       guard let price = selectedShop?.price else {return}
                       guard let userUID = selectedShop?.userID else {return}


                       
                       let ref = Database.database().reference().child("VenueAppointments").child("cancel").child(venueID).child(bookedID)
            
                    let ref3 = Database.database().reference().child("users").child("profile").child(userUID).child("myAppointments").child(bookedDate).child(venueID).child(bookedID)
                       
                        let venueDetails = [
                            "Justification":string,
                            "UserID":userUID,
                            "price":price,
                            "VenueName":venue,
                            "StoreName":venue,
                            "companyName":companyName,
                            "ownerUID":owneruid,
                            "venueID":venueID,
                            "userBookingStatus":"",
                            "bookingStatus": "Rejected",
                           "Date": bookedDate,
                           "userbookedName":usernames,
                           "userbookedNumber":phone,
                           "userbookedEmail":email,
                           "userImage":image
                        ] as [String:Any]
                       
                       ref.updateChildValues(venueDetails) { (err, ref) in
                            if err != nil {
                                  print(err)
                              } else {
                        ref3.updateChildValues(venueDetails)
                          hud.textLabel.text = "Success !"
                          hud.dismiss(afterDelay: 5.0, animated: true)
                          self.dismiss(animated: true, completion: nil)
                                Database.database().reference().child("VenueAppointments").child("Active").child(self.venueID).child(bookedID).setValue(nil)
                              }
                       }
                       
                
            }
            
            func sendEmailToOwner() {                                    self.pastBooking()
                }
            
        func pastChosenTime() {

         Database.database().reference().child("VenueAppointments").child("Active").child(venueID).child(bookedID).child("times").observeSingleEvent(of: .value) { (snapshot) in
                 print(snapshot)
            
                     if let snapDict =  snapshot.value as? [String:AnyObject]{
                             for each in snapDict{
                                 let timeSlot = TimeSlot()
                                 timeSlot.time = each.value as! String
                                 self.TimeSlotList.append(timeSlot)
                                                             
                                 for i in 0..<self.arrSelectedDatae.count {
                                     let time = self.arrSelectedDatae[i]
                                     let values = [
                                         "time\(i + 1)": time
                                     ] as [String:Any]
                                    Database.database().reference().child("VenueAppointments").child("past").child(self.venueID).child(self.bookedID).child("times").updateChildValues(values)
                                     
                                 }
                             }
                         }
                    }
             }
        
        func CancelChosenTime() {

         Database.database().reference().child("VenueAppointments").child("Active").child(venueID).child(bookedID).child("times").observeSingleEvent(of: .value) { (snapshot) in
                 print(snapshot)
            
                     if let snapDict =  snapshot.value as? [String:AnyObject]{
                             for each in snapDict{
                                 let timeSlot = TimeSlot()
                                 timeSlot.time = each.value as! String
                                 self.TimeSlotList.append(timeSlot)
                                                             
                                 for i in 0..<self.arrSelectedDatae.count {
                                     let time = self.arrSelectedDatae[i]
                                     let values = [
                                         "time\(i + 1)": time
                                     ] as [String:Any]
                                    Database.database().reference().child("VenueAppointments").child("cancel").child(self.venueID).child(self.bookedID).child("times").updateChildValues(values)
                                     
                                 }
                             }
                         }
                    }
             }
            
            func pastBooking() {
                
                pastChosenTime()
                
                let hud = JGProgressHUD(style: .dark)
                hud.indicatorView = JGProgressHUDRingIndicatorView()
                hud.textLabel.text = "Uploading"
                hud.show(in: view)
                guard let uid = Auth.auth().currentUser?.uid else {return}
                guard let venue = selectedShop?.venueName else {return}
                guard let venueID = selectedShop?.venueID else {return}
                guard let bookedID = selectedShop?.id else {return}
                guard let bookedDate = selectedShop?.bookingDate else {return}
                guard let usernames = selectedShop?.username else {return}
                guard let phone = selectedShop?.userbookednumber else {return}
                guard let email = selectedShop?.userbookedEmail else {return}
                guard let image = selectedShop?.userImage else {return}
                guard let price = selectedShop?.price else {return}
                guard let userUID = selectedShop?.userID else {return}
                
                
                let ref = Database.database().reference().child("VenueAppointments").child("past").child(venueID).child(bookedID)
                
                let ref2 = Database.database().reference().child("users").child("profile").child(userUID).child("RatingNotification").childByAutoId()
                
                let rpo = ref2.key
                guard let paymentid = selectedShop?.paymentTransactionId else {return}
                
                 let venueDetails = [
                    "UserID":userUID,
                 "companyName":companyName,
                 "ownerUID":owneruid,
                 "StoreName":venue,
                 "VenueName":venue,
                 "venueID":venueID,
                     "price":price,
                     "userImage":image,
                     "bookingStatus": "completed",
                    "paymentTransactionId":paymentid,
                    "paymentService":"Moyasar",
                    "Date": bookedDate,
                    "userbookedName":usernames,
                    "userbookedNumber":phone,
                    "userbookedEmail":email,
                    "creationDate":Date().timeIntervalSince1970
                 ] as [String:Any]
                
                let venueDetails2 = [
                    "ownerUID":owneruid,
                    "companyName":companyName,
                    "venueCountru":countries,
                    "venuecity":cities,
                    "venueType":types,
                    "venueName":venue,
                    "StoreName":venue,
                    "paymentTransactionId":paymentid,
                    "paymentService":"Moyasar",
                    "venueID":venueID,
                   "UserID":userUID,
                    "price":price,
                    "bookingStatus": "completed",
                   "Date": bookedDate,
                   "userImage":image,
                   "userbookedName":usernames,
                   "userbookedNumber":phone,
                   "userbookedEmail":email,
                   "creationDate":Date().timeIntervalSince1970
                ] as [String:Any]
                
                ref.updateChildValues(venueDetails) { (err, ref) in
                     if err != nil {
                           print(err)
                       } else {
                        
                        let val = [uid:1]
                           
                   hud.textLabel.text = "Success !"
                   hud.dismiss(afterDelay: 5.0, animated: true)
                   ref2.updateChildValues(venueDetails2)
                   Database.database().reference().child("users").child("profile").child(userUID).child("RatingNotification").child(rpo!).child("checked").setValue(0)
                   Database.database().reference().child("Notifications").child("Reservations").child("Done").child(userUID).setValue(val)
                   Database.database().reference().child("VenueAppointments").child("Active").child(venueID).child(bookedID).setValue(nil)
                   self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            
            
            @IBAction func pastPressed(_ sender: Any) {
                let alertController = UIAlertController(title: "Reservation is completed?", message: "is the user have already come and finish his reservation? if yes please move it to past booking", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Past", style: .default, handler: { (action:UIAlertAction) in
                    self.sendEmailToOwner()
                }))
                
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action:UIAlertAction) in
                    print("CancelTapped")
                }))
                
                alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
                
                present(alertController, animated: true, completion: nil)

            }
            
            
            @IBAction func cancelPressed(_ sender: Any) {
                let alertController = UIAlertController(title: "Are you really sure that you want to cancel the user booking?", message: "if you already agreed between you and the user to cancel this booking, please press the button", preferredStyle: .alert)
                
                alertController.addTextField { (text) in
                    text.placeholder = "Justification"
                }
                
                alertController.addAction(UIAlertAction(title: "Agreed to reject", style: .default, handler: { (action:UIAlertAction) in
                    
                    if let tex = alertController.textFields?[0] {
                        if tex.text!.count > 0 {
                            let pop = tex.text
                            self.CancelBooking(string:pop!)
                        } else {
    //                        Loaf("Error: Please write something", state: .error, sender: self).show(.average)
                            Loaf("Error: Please write something", state: .error, location: .top, sender: self).show(.average)
                            print("write something")
                        }
                    }

                }))
                
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action:UIAlertAction) in
                    print("CancelTapped")
                }))
                
                alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
                present(alertController, animated: true, completion: nil)
                
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
            if indexPath.section == 4 && indexPath.row == 0 {
            let mailComposeViewController = self.configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
            }
            
        }
    
}

