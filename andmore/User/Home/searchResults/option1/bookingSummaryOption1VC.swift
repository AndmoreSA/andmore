//
//  bookingSummaryOption1VC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 08/06/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage
import Loaf
import JGProgressHUD

class bookingSummaryOption1VC: UITableViewController, UICollectionViewDelegate , UICollectionViewDataSource {

    //Outlets
    @IBOutlet weak var companyNameTxt: UILabel!
    @IBOutlet weak var venueNameTxt: UILabel!
    @IBOutlet weak var venueTypeTxt: UILabel!
    @IBOutlet weak var capacityVenueTxt: UILabel!
    @IBOutlet weak var venueSelectedDate: UILabel!
    @IBOutlet weak var chosenTimeCollectionView: UICollectionView!
    @IBOutlet weak var currencyTxt: UILabel!
    @IBOutlet weak var costPriceTXT: UILabel!
    @IBOutlet weak var discountTxt: UILabel!
    @IBOutlet weak var taxTxt: UILabel!
    @IBOutlet weak var finalPriceTxt: UILabel!
    @IBOutlet weak var finalCurrencyTxt: UILabel!
    @IBOutlet weak var venueImage: UIImageView!
    @IBOutlet weak var nofOfTimes: UILabel!
    @IBOutlet weak var resultFinalTxt: UILabel!
    @IBOutlet weak var finalCurrencyTxt2: UILabel!
    @IBOutlet weak var priceafterdeduction: UILabel!
    
    
    
    
    
    
    
    
    //Vairbels
    var status:String = "Paid"
    var discounet:String = ""
    var tax:String = ""
    var numberoftimes:String = ""
    var type:String = ""
    var deletetime:String = ""
    var companyName:String = ""
    var venueName:String = ""
    var venueID:String = ""
    var venueEmail:String = ""
    var keystrings:String = ""
    var checkIn:String = ""
    var userUniqueID:String = ""
    var diz:String = ""
    var userName:String = ""
    var phoneNumber:String = ""
    var email:String = ""
    var userImage:String = ""
    var storeImage:String = ""
    var city:String = ""
    var country:String = "Saudi Arabia"
    var capacity:String = ""
    var price:String = ""
    var final:Double = 0
    var firstPrice:Double = 0
    var pricewithDiscount:Double = 0
    

    var arrSelectedDatae = [String]()


    var selectedTime = [userChosenTime]()

    
    var selectedShop: venueSearch! {
        didSet {
             if selectedShop.venueType != nil {
                type = selectedShop.venueType
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        let namsex = UserDefaults()
        if let data34 = namsex.object(forKey: "idz") {
            if let message12 = data34 as? String {
                diz = message12
//                print(message12)

            }
        }
        
        if let data44 = namsex.object(forKey: "times") {
            if let message22 = data44 as? [String] {
                arrSelectedDatae = message22
//                print(message22)

            }
        }
        
        if let data33 = namsex.object(forKey: "service2") {
              if let message2 = data33 as? String {
                  price = message2
//                  print(message2)

              }
          }
    
                
        //        let namew = UserDefaults()
                if let data33 = namsex.object(forKey: "city1") {
                    if let message4 = data33 as? String {
                        city = message4
//                        print(message4)

                    }
                }
        

        
            if let VenueNames = selectedShop?.venueName {
            venueNameTxt.text = VenueNames
                venueName = VenueNames
//                print(VenueNames)
        } else {
            venueNameTxt.isHidden = true
        }
        
        if let venueIDz = selectedShop?.venueID {
            venueID = venueIDz
        }
        
            if let VenueTypea = selectedShop?.venueType {
            venueTypeTxt.text = VenueTypea
                type = VenueTypea
//                print(VenueTypea)
        } else {
            venueTypeTxt.isHidden = true
        }
        
            if let VenuePeople = selectedShop?.noOFPEOPLE {
            capacityVenueTxt.text = VenuePeople
                capacity = VenuePeople
//                print(VenuePeople)
        } else {
            capacityVenueTxt.isHidden = true
        }
        
            if let Venuediscount = selectedShop?.priceTypeDiscount {
            discountTxt.text = Venuediscount
//                print(Venuediscount)
        } else {
            discountTxt.isHidden = true
        }
        
            if let VenueFinalCurrency = selectedShop?.finalCurrency {
            finalCurrencyTxt.text = VenueFinalCurrency
//                print(VenueFinalCurrency)
        } else {
            finalCurrencyTxt.isHidden = true
        }
        
            if let VenueFinalCurrency2 = selectedShop?.finalCurrency {
            finalCurrencyTxt2.text = VenueFinalCurrency2
//                print(VenueFinalCurrency2)
        } else {
            finalCurrencyTxt2.isHidden = true
        }
        

            if let VenueFirstCurrency = selectedShop?.currencyHour {
            currencyTxt.text = VenueFirstCurrency
                print(VenueFirstCurrency)
        } else {
            currencyTxt.isHidden = true
        }
        

        
            if let VenueFinalPrice = selectedShop?.finalPrice {
            finalPriceTxt.text = "\(String(VenueFinalPrice))"
                pricewithDiscount = VenueFinalPrice
                print(VenueFinalPrice)
        } else {
            finalPriceTxt.isHidden = true
        }
        

        decidePriceHourORDay()
        
        
        
        guard let image = selectedShop?.venueImage1 else {return}
        guard let url = URL(string: image) else {return}
        venueImage.sd_setImage(with: url)
        
        retreiveVenueInfo()
        
        
        let namse = UserDefaults()
        if let data33 = namse.object(forKey: "date1") {
              if let message2 = data33 as? String {
                self.venueSelectedDate.text = message2
                checkIn = message2
                  print(message2)

              }
          }
        
        if let data33 = namsex.object(forKey: "date1") {
              if let message5 = data33 as? String {
                  checkIn = message5
//                  print(message5)

              }
          }
        
        retreiveUserChosenTime()
        retreiveUserCount()
        retreiveUserInfo()
        venueShow()
        venueShows()
    }
    
    func decidePriceHourORDay() {
        
        if price == "Hour" {
            if let VenueFirstPrice = selectedShop?.perHourPrice {
            costPriceTXT.text = "\(String(VenueFirstPrice))"
                firstPrice = VenueFirstPrice
                print(VenueFirstPrice)
        } else {
            costPriceTXT.isHidden = true
            }
        } else {
                if let VenueFirstPrice = selectedShop?.perDayPrice{
                costPriceTXT.text = "\(String(VenueFirstPrice))"
                    firstPrice = VenueFirstPrice
                    print(VenueFirstPrice)
            } else {
                costPriceTXT.isHidden = true
            }
        }
    }
    
        func BookwithCardButton() {
            let customAppleLoginBtn = UIButton()
           customAppleLoginBtn.layer.cornerRadius = 8
           customAppleLoginBtn.layer.borderWidth = 2
           customAppleLoginBtn.backgroundColor = #colorLiteral(red: 0.2274667025, green: 0.508351326, blue: 0.6444326639, alpha: 1)
           customAppleLoginBtn.layer.borderColor = #colorLiteral(red: 0.2274667025, green: 0.508351326, blue: 0.6444326639, alpha: 1)
           customAppleLoginBtn.setTitle("Place Order", for: .normal)
           customAppleLoginBtn.setTitleColor(UIColor.white, for: .normal)
           customAppleLoginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
           customAppleLoginBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 12)
           customAppleLoginBtn.addTarget(self, action: #selector(bookwithCardPressed), for: .touchUpInside)
           self.view.addSubview(customAppleLoginBtn)
           // Setup Layout Constraints to be in the center of the screen
           customAppleLoginBtn.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               customAppleLoginBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8),
               customAppleLoginBtn.heightAnchor.constraint(equalToConstant: 34.0),
            customAppleLoginBtn.widthAnchor.constraint(equalToConstant: 280),
            customAppleLoginBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
               ])
        }
    

        @objc func bookwithCardPressed() {
            
            if Reachability.isConnectedToNetwork(){
                self.performSegue(withIdentifier: "order", sender: nil)
            } else {
                Loaf("Check Your network", state: .warning, sender: self).show()
            }

        }
            
            @objc func actionHandleAppleSignina() {
                guard let uid = Auth.auth().currentUser?.uid else {return}
                  guard let VenueUid = selectedShop?.uid else {return}
                  guard let venueNames = selectedShop?.venueName else {return}
                  
                let fullPrice = Double(String(format:"%.2f", self.final))!


                          let appointment = [
                              "Date": checkIn,
                              "postid":diz,
                              "venueName":venueNames,
                              "venueID":venueID,
                            "paymentTransactionId":"",
                            "paymentService":"Moyasar",
                              "userBookingStatus":"Waiting for Approval",
                              "bookingStatus":"pending",
                              "paymentStatus":"Not Paid",
                              "StoreName":venueNames,
                              "fullName":companyNameTxt.text,
                              "UserID":uid,
                              "venueEmail":venueEmail,
                              "venueCity":city,
                              "venueCountry":country,
                              "capacity":capacity,
                              "firstPrice":firstPrice,
                              "venueType":type,
                              "storeID":VenueUid,
                            "numberofTimes":Double(nofOfTimes.text!),
                              "discounet":discountTxt.text,
                              "originalPrice":firstPrice,
                              "pricewithDiscuount":Double(finalPriceTxt.text!),
                              "userbookedName":self.userName,
                              "storeImage":self.storeImage,
                              "userImage":self.userImage,
                              "userbookedNumber":self.phoneNumber,
                              "userbookedEmail":self.email,
                              "creationDate":Date().timeIntervalSince1970,
                              "price":"\(fullPrice)"
                              ] as [String : Any]
                          
                              Database.database().reference().child("TimeBooked").child(VenueUid).child(venueNames).child(checkIn).child(uid).setValue(nil)
                          

                          
                                    for i in 0..<arrSelectedDatae.count {

                                     let time = arrSelectedDatae[i]
                                     
                                     let values = [
                                         "time\(i + 1)": time
                                     ] as [String:Any]
                              
                            Database.database().reference().child("users").child("profile").child(uid).child("myAppointments").child(checkIn).child(venueID).child(diz).child("times").updateChildValues(values)
                                        
                                        
                                        
                                        
                            Database.database().reference().child("users").child("profile").child(uid).child("myAppointments").child(checkIn).child(venueID).child(diz).updateChildValues(appointment)
                                        
                                        
                                        
                            Database.database().reference().child("users").child("profile").child(uid).child("myPendingAppointments").child(checkIn).child(venueID).child(diz).child("times").updateChildValues(values)
                                        
                            Database.database().reference().child("users").child("profile").child(uid).child("myHistoryReservations").child(diz).child("times").updateChildValues(values)
                              
                            Database.database().reference().child("VenueAppointments").child("Active").child(venueID).child(diz).child("times").updateChildValues(values)
                              
                          
                            Database.database().reference().child("Venues").child(country).child(city).child(type).child(venueID).child("mySchedule").child(price).child(deletetime).child("dates").child(checkIn).observe(.value) { (snapshot) in
                          
                              if let snaps = snapshot.value as? [String:Any] {
                              for each in snaps {
                              let uid = each.key
                              if(uid == time) {

                                Database.database().reference().child("Venues").child(self.country).child(self.city).child(self.type).child(self.venueID).child("mySchedule").child(self.price).child(self.deletetime).child("dates").child(self.checkIn).child(uid).setValue(nil) { (err, ref) in
                                      if err != nil {
                                        print(err!)
                                        return
                                    }
                                      Database.database().reference().child("stores").child("Allbuisness").child(VenueUid).child("mySchedule").child("Hour").child(self.deletetime).child("dates").child(self.checkIn).child(uid).setValue(nil)
                                    }
                                }
                            }
                        }
                    }
                              

                              
                Database.database().reference().child("users").child("profile").child(uid).child("myPendingAppointments").child(checkIn).child(venueID).child(diz).updateChildValues(appointment)
                                        
                Database.database().reference().child("users").child("profile").child(uid).child("myPendingPayments").child(diz).updateChildValues(appointment)
                              
                Database.database().reference().child("users").child("profile").child(uid).child("myHistoryReservations").child(diz).updateChildValues(appointment)
                              
                Database.database().reference().child("VenueAppointments").child("Active").child(venueID).child(diz).updateChildValues(appointment)
                              
              }
                
              performSegue(withIdentifier: "eggeg", sender: nil)
              
              let userDefaults = UserDefaults()
              userDefaults.set(venueNames, forKey: "venuename1")
              userDefaults.set(companyNameTxt.text, forKey: "companyname1")
              userDefaults.set(self.userName, forKey: "username1")
              userDefaults.set(self.phoneNumber, forKey: "phoneNumber1")
              userDefaults.set(self.email, forKey: "email1")
              userDefaults.set(diz, forKey: "postid")
              userDefaults.set(VenueUid, forKey: "storeID")
              userDefaults.set("Not paid yet", forKey: "condition")
              userDefaults.set("pending", forKey: "bookingStatus")
              userDefaults.set(resultFinalTxt.text, forKey: "price1")
                      
            }

   
    
    // MARK: - Retrieving Properties
    
    func retreiveVenueInfo() {
        
        guard let uid = selectedShop?.uid else {return}
        
        Database.database().reference().child("All").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            
            guard let dict = snapshot.value as? [String:Any] else {return}
            
            self.companyNameTxt.text = dict["fullName"] as? String
            self.companyName = (dict["fullName"] as? String)!
            self.city = (dict["city"] as? String)!
            self.venueEmail = (dict["email"] as? String)!
            self.storeImage = (dict["profileImageURL"] as? String)!
                        
                self.BookwithCardButton()
        }
        
    }
    
    
    func retreiveUserInfo() {
        
        guard let Useruid = Auth.auth().currentUser?.uid else {return}
        self.userUniqueID = Auth.auth().currentUser!.uid
        
        Database.database().reference().child("users").child("profile").child(Useruid).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            
            guard let dict = snapshot.value as? [String:Any] else {return}
            
            self.userName = dict["fullName"] as! String
            self.phoneNumber = dict["phoneNumber"] as! String
            self.email = dict["email"] as! String
            self.userImage = dict["profileImageURL"] as? String ?? ""
        }
        
    }
    
    func venueShow() {
        
        guard let venueNames = selectedShop?.venueName else {return}

        let ref = Database.database().reference().child("Services").child(country).child(city).child(type).child(venueID).child("mySchedule").child(price)

           ref.observe(.value) { (snapshot) in
            
            if let snaps = snapshot.value as? [String:Any] {
                for each in snaps {
                    let uid = each.key
                    self.deletetime = each.key
                }
            }
        }
    }
    
    func venueShows() {
        
         guard let venueNames = selectedShop?.venueName else {return}
        guard let VenueUid = selectedShop?.uid else {return}

        let ref = Database.database().reference().child("stores").child("Allbuisness").child(type).child(VenueUid).child("mySchedule").child("Hour")

            ref.observe(.value) { (snapshot) in
//            print(snapshot)
             
             if let snaps = snapshot.value as? [String:Any] {
                 for each in snaps {
                     let uid = each.key
                     self.keystrings = each.key
                 }
             }
         }
     }
    
    
    
    func retreiveUserChosenTime() {
        guard let UserUid = Auth.auth().currentUser?.uid else {return}
        guard let VenueUid = selectedShop?.uid else {return}
        guard let venueNames = selectedShop?.venueName else {return}

        
        Database.database().reference().child("TimeBooked").child(VenueUid).child(venueNames).child(checkIn).child(UserUid).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            self.selectedTime.removeAll()

                if let snapDict =  snapshot.value as? [String:AnyObject]{
                        for each in snapDict{
                            let timeSlot = userChosenTime()
                            timeSlot.time = each.value as! String
//                                        timeSlot.slot = each.value as! Int
                            self.selectedTime.append(timeSlot)
                            
                            print(timeSlot)
                            self.selectedTime.sort { $0.time.compare($1.time, options: .numeric) == .orderedAscending }
                        }
                    
                        self.chosenTimeCollectionView.reloadData()
            }
        }
    }
    
    func retreiveUserCount() {
        
            guard let UserUid = Auth.auth().currentUser?.uid else {return}
            guard let VenueUid = selectedShop?.uid else {return}
            guard let venueNames = selectedShop?.venueName else {return}
            Database.database().reference().child("TimeBooked").child(VenueUid).child(venueNames).child(checkIn).child(UserUid).observeSingleEvent(of: .value) { (snapshot) in
                print(snapshot)
                print(snapshot.childrenCount)
                
                self.nofOfTimes.text = "\(snapshot.childrenCount)"
                self.numberoftimes = "\(snapshot.childrenCount)"
                
                let multiplethem = Double(self.nofOfTimes.text!)!
                let multiplethem2 = Double(self.finalPriceTxt.text!)!
                let y = String(multiplethem * multiplethem2 * 1.15)
                let x = Double(y)!
                self.final = round(x * 1000)/1000
                self.resultFinalTxt.text = "\(String(format:"%.2f", self.final))"
                print(self.final)
                }
            }

    // MARK: - Table view data source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedTime.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = chosenTimeCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! chosenTimeSummary1Cell
        
        cell.timeLabel.text = selectedTime[indexPath.row].time
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.item)!")
    }
    
    @IBAction func backPressed(_ sender: Any) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let VenueUid = selectedShop?.uid else {return}
        guard let venueNames = selectedShop?.venueName else {return}
            Database.database().reference().child("TimeBooked").child(VenueUid).child(venueNames).child(checkIn).child(uid).setValue(nil)
            Database.database().reference().child("users").child("profile").child(uid).child("myAppointments").child(checkIn).child(venueNames).child(diz).setValue(nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK:- Actions
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? allmethodspaymentVC
        destinationVC?.companyName = selectedShop.shopName
        destinationVC?.venueName = selectedShop.venueName
        destinationVC?.venueType = selectedShop.venueType
        destinationVC?.checkIn = checkIn
        destinationVC?.companyUID = selectedShop.uid
        destinationVC?.capacity = selectedShop.noOFPEOPLE
        destinationVC?.venueID = selectedShop.venueID
        destinationVC?.numberoftimes = numberoftimes
        destinationVC?.discounet = selectedShop.priceTypeDiscount
        destinationVC?.firstPrice = firstPrice
        destinationVC?.final = final
        destinationVC?.userName = userName
        destinationVC?.userphoneNumber = phoneNumber
        destinationVC?.useremail = email
        destinationVC?.diz = diz
        destinationVC?.userImage = userImage
        destinationVC?.storeImage = storeImage
        destinationVC?.city = city
        destinationVC?.country = country
        destinationVC?.venueEmail = venueEmail
        destinationVC?.userUniqueID = userUniqueID
        destinationVC?.price = price
        destinationVC?.pricewithDiscount = pricewithDiscount
    }
}
