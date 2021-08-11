//
//  allmethodspaymentVC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 08/06/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Loaf
import JGProgressHUD

class allmethodspaymentVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    
    //MARK:- Outlets
    @IBOutlet weak var allpayemtnsTableView: UITableView!
    
    //MARK:- Variables
    var paymentsImages = ["applepay","unnamed","visawallet","stcPay"]
    let customAppleLoginBtnApplePay = UIButton()
    let customAppleLoginBtnMada = UIButton()
    let customAppleLoginBtnCreditCard = UIButton()
    let customAppleLoginBtnRewards = UIButton()
    let customAppleLoginBtnStcPay = UIButton()
    var payemtnsNames = ["Apple Pay","Mada", "Credit Card","STC Pay"]
    
    // MARK:- Payment Vairbels
    var companyName:String = ""
    var companyUID:String = ""
    var venueName:String = ""
    var venueType:String = ""
    var venueID:String = ""
    var capacity:String = ""
    var checkIn:String = ""
    var status:String = "Paid"
    var tax:String = "15%"
    var numberoftimes:String = ""
    var price:String = ""
    var final:Double = 0
    var firstPrice:Double = 0
    var pricewithDiscount:Double = 0
    var discounet:String = ""
    var userName:String = ""
    var userphoneNumber:String = ""
    var useremail:String = ""
    var diz:String = ""
    var userImage:String = ""
    var storeImage:String = ""
    var city:String = ""
    var country:String = ""
    var venueEmail:String = ""
    var userUniqueID:String = ""
    var arrSelectedDatae = [String]()
//    var paymentProviderSTC: stcPayCardView?
    var id:String = ""
    var refNumber:String = ""
    var fullPrice:Double = 0
    var BronzeLevel:Double = 0
    var Conference:Double = 0
    var Private:Double = 0
    var Shared:Double = 0
    var Training:Double = 0
    var Hall:Double = 0
    
    var Dammam:Double = 0
    var Hassa:Double = 0
    var Khobar:Double = 0
    var Riyadh:Double = 0
    var Hafer:Double = 0
    var Qassim:Double = 0
    var Medina:Double = 0
    var Makkah:Double = 0
    var Jeddah:Double = 0
    var Jubail:Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        MakingSureThatAllVariablesWereMovedSenc()
    }
    
    //MARK:- TableView Properties
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payemtnsNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allpayemtnsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! allmethodsCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.img.image = UIImage(named: paymentsImages[indexPath.item])
        cell.name.text = payemtnsNames[indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            let roro = payemtnsNames[indexPath.row]
            print(roro)
            if roro == "Apple Pay" {
                self.customAppleLoginBtnApplePay.isHidden = false
                self.customAppleLoginBtnMada.isHidden = true
                self.customAppleLoginBtnCreditCard.isHidden = true
                self.customAppleLoginBtnStcPay.isHidden = true
                BookRequestButton0()
            } else if roro == "Mada" {
                self.customAppleLoginBtnApplePay.isHidden = true
                self.customAppleLoginBtnMada.isHidden = false
                self.customAppleLoginBtnCreditCard.isHidden = true
                self.customAppleLoginBtnStcPay.isHidden = true
                BookRequestButton1()
            } else if roro == "Credit Card" {
                self.customAppleLoginBtnApplePay.isHidden = true
                self.customAppleLoginBtnMada.isHidden = true
                self.customAppleLoginBtnCreditCard.isHidden = false
                self.customAppleLoginBtnStcPay.isHidden = true
                BookRequestButton2()
            } else if roro == "STC Pay" {
                self.customAppleLoginBtnApplePay.isHidden = true
                self.customAppleLoginBtnMada.isHidden = true
                self.customAppleLoginBtnCreditCard.isHidden = true
                self.customAppleLoginBtnStcPay.isHidden = false
                BookRequestButton3()
            } else {
                self.customAppleLoginBtnApplePay.isHidden = true
                self.customAppleLoginBtnMada.isHidden = true
                self.customAppleLoginBtnCreditCard.isHidden = true
                self.customAppleLoginBtnStcPay.isHidden = true
            }
        }
    }
    
    //MARK:- Properties
    func MakingSureThatAllVariablesWereMovedSenc() {
        
        let namsex = UserDefaults()
        if let data44 = namsex.object(forKey: "times") {
            if let message22 = data44 as? [String] {
                arrSelectedDatae = message22
            }
        }
            
        print(companyName)
        print(companyUID)
        print(venueName)
        print(venueType)
        print(venueID)
        print(capacity)
        print(checkIn)
        print("Paid")
        print("15%")
        print(numberoftimes)
        print(price)
        print(final)
        print(firstPrice)
        print(discounet)
        print(userName)
        print(userphoneNumber)
        print(useremail)
        print(diz)
        print(userImage)
        print(storeImage)
        print(city)
        print(country)
        print(venueEmail)
        print(userUniqueID)
        print(arrSelectedDatae)
    }
    
    func BookRequestButton0() {
//        let customAppleLoginBtn = UIButton()
        customAppleLoginBtnApplePay.layer.cornerRadius = 8
        customAppleLoginBtnApplePay.layer.borderWidth = 2
        customAppleLoginBtnApplePay.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        customAppleLoginBtnApplePay.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        customAppleLoginBtnApplePay.setTitle("Apple Pay", for: .normal)
        customAppleLoginBtnApplePay.setTitleColor(UIColor.white, for: .normal)
        customAppleLoginBtnApplePay.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        customAppleLoginBtnApplePay.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 12)
        customAppleLoginBtnApplePay.addTarget(self, action: #selector(AddNewCard0), for: .touchUpInside)
       self.view.addSubview(customAppleLoginBtnApplePay)
        
        customAppleLoginBtnApplePay.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
        customAppleLoginBtnApplePay.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8),
        customAppleLoginBtnApplePay.heightAnchor.constraint(equalToConstant: 34.0),
        customAppleLoginBtnApplePay.widthAnchor.constraint(equalToConstant: 280),
        customAppleLoginBtnApplePay.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
           ])
    }
    

    
    @objc func AddNewCard0() {
        print("Apple Pay")
        let userDefaults = UserDefaults()
        userDefaults.set(self.venueName, forKey: "venuename1")
        userDefaults.set(self.companyName, forKey: "companyname1")
        userDefaults.set(self.userName, forKey: "username1")
        userDefaults.set(self.userphoneNumber, forKey: "phoneNumber1")
        userDefaults.set(self.useremail, forKey: "email1")
        userDefaults.set(self.diz, forKey: "postid")
        userDefaults.set(self.companyUID, forKey: "storeID")
        userDefaults.set("paid", forKey: "condition")
        userDefaults.set(self.price, forKey: "price1")
        userDefaults.set(self.numberoftimes, forKey: "number1")
        userDefaults.set(self.discounet, forKey: "discount1")
        userDefaults.set(self.firstPrice, forKey: "origi1")
        userDefaults.set(self.final, forKey: "afterprice")
        userDefaults.set(self.pricewithDiscount, forKey: "pricewithDiscount")
        self.cash()
    }
    
    //MARK:-Zero Step - Credit Card
    func BookRequestButton1() {
        customAppleLoginBtnMada.layer.cornerRadius = 8
        customAppleLoginBtnMada.layer.borderWidth = 2
        customAppleLoginBtnMada.backgroundColor = #colorLiteral(red: 0.052175574, green: 0.5155863166, blue: 0.6571595073, alpha: 1)
        customAppleLoginBtnMada.layer.borderColor = #colorLiteral(red: 0.052175574, green: 0.5155863166, blue: 0.6571595073, alpha: 1)
        customAppleLoginBtnMada.setTitle("Pay Now", for: .normal)
        customAppleLoginBtnMada.setTitleColor(UIColor.white, for: .normal)
        customAppleLoginBtnMada.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        customAppleLoginBtnMada.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 12)
        customAppleLoginBtnMada.addTarget(self, action: #selector(AddNewCard1), for: .touchUpInside)
       self.view.addSubview(customAppleLoginBtnMada)
        
        customAppleLoginBtnMada.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
        customAppleLoginBtnMada.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8),
        customAppleLoginBtnMada.heightAnchor.constraint(equalToConstant: 34.0),
        customAppleLoginBtnMada.widthAnchor.constraint(equalToConstant: 280),
        customAppleLoginBtnMada.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
           ])
    }
    
    @objc func AddNewCard1() {
        let userDefaults = UserDefaults()
        userDefaults.set(self.venueName, forKey: "venuename1")
        userDefaults.set(self.companyName, forKey: "companyname1")
        userDefaults.set(self.userName, forKey: "username1")
        userDefaults.set(self.userphoneNumber, forKey: "phoneNumber1")
        userDefaults.set(self.useremail, forKey: "email1")
        userDefaults.set(self.diz, forKey: "postid")
        userDefaults.set(self.companyUID, forKey: "storeID")
        userDefaults.set("paid", forKey: "condition")
        userDefaults.set(self.price, forKey: "price1")
        userDefaults.set(self.numberoftimes, forKey: "number1")
        userDefaults.set(self.discounet, forKey: "discount1")
        userDefaults.set(self.firstPrice, forKey: "origi1")
        userDefaults.set(self.final, forKey: "afterprice")
        userDefaults.set(self.pricewithDiscount, forKey: "pricewithDiscount")
        self.cash()
        
    }
    
    func BookRequestButton2() {
        customAppleLoginBtnCreditCard.layer.cornerRadius = 8
        customAppleLoginBtnCreditCard.layer.borderWidth = 2
        customAppleLoginBtnCreditCard.backgroundColor = #colorLiteral(red: 0.052175574, green: 0.5155863166, blue: 0.6571595073, alpha: 1)
        customAppleLoginBtnCreditCard.layer.borderColor = #colorLiteral(red: 0.052175574, green: 0.5155863166, blue: 0.6571595073, alpha: 1)
        customAppleLoginBtnCreditCard.setTitle("Pay Now", for: .normal)
        customAppleLoginBtnCreditCard.setTitleColor(UIColor.white, for: .normal)
        customAppleLoginBtnCreditCard.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        customAppleLoginBtnCreditCard.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 12)
        customAppleLoginBtnCreditCard.addTarget(self, action: #selector(AddNewCard2), for: .touchUpInside)
       self.view.addSubview(customAppleLoginBtnCreditCard)
        
        customAppleLoginBtnCreditCard.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
        customAppleLoginBtnCreditCard.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8),
        customAppleLoginBtnCreditCard.heightAnchor.constraint(equalToConstant: 34.0),
        customAppleLoginBtnCreditCard.widthAnchor.constraint(equalToConstant: 280),
        customAppleLoginBtnCreditCard.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
           ])
    }
    
    @objc func AddNewCard2() {
        let userDefaults = UserDefaults()
        userDefaults.set(self.venueName, forKey: "venuename1")
        userDefaults.set(self.companyName, forKey: "companyname1")
        userDefaults.set(self.userName, forKey: "username1")
        userDefaults.set(self.userphoneNumber, forKey: "phoneNumber1")
        userDefaults.set(self.useremail, forKey: "email1")
        userDefaults.set(self.diz, forKey: "postid")
        userDefaults.set(self.companyUID, forKey: "storeID")
        userDefaults.set("paid", forKey: "condition")
        userDefaults.set(self.price, forKey: "price1")
        userDefaults.set(self.numberoftimes, forKey: "number1")
        userDefaults.set(self.discounet, forKey: "discount1")
        userDefaults.set(self.firstPrice, forKey: "origi1")
        userDefaults.set(self.final, forKey: "afterprice")
        userDefaults.set(self.pricewithDiscount, forKey: "pricewithDiscount")
        self.cash()
    }
    
    func BookRequestButton3() {
        customAppleLoginBtnStcPay.layer.cornerRadius = 8
        customAppleLoginBtnStcPay.layer.borderWidth = 2
        customAppleLoginBtnStcPay.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        customAppleLoginBtnStcPay.layer.borderColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        customAppleLoginBtnStcPay.setTitle("Pay Now", for: .normal)
        customAppleLoginBtnStcPay.setTitleColor(UIColor.white, for: .normal)
        customAppleLoginBtnStcPay.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        customAppleLoginBtnStcPay.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 12)
        customAppleLoginBtnStcPay.addTarget(self, action: #selector(stcpayPay), for: .touchUpInside)
       self.view.addSubview(customAppleLoginBtnStcPay)
        
        customAppleLoginBtnStcPay.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
        customAppleLoginBtnStcPay.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8),
        customAppleLoginBtnStcPay.heightAnchor.constraint(equalToConstant: 34.0),
        customAppleLoginBtnStcPay.widthAnchor.constraint(equalToConstant: 280),
        customAppleLoginBtnStcPay.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
           ])
    }
    
    @objc func stcpayPay() {
        
        let userDefaults = UserDefaults()
        userDefaults.set(self.venueName, forKey: "venuename1")
        userDefaults.set(self.companyName, forKey: "companyname1")
        userDefaults.set(self.userName, forKey: "username1")
        userDefaults.set(self.userphoneNumber, forKey: "phoneNumber1")
        userDefaults.set(self.useremail, forKey: "email1")
        userDefaults.set(self.diz, forKey: "postid")
        userDefaults.set(self.companyUID, forKey: "storeID")
        userDefaults.set("paid", forKey: "condition")
        userDefaults.set(self.price, forKey: "price1")
        userDefaults.set(self.numberoftimes, forKey: "number1")
        userDefaults.set(self.pricewithDiscount, forKey: "pricewithDiscount")
        userDefaults.set(self.discounet, forKey: "discount1")
        userDefaults.set(self.firstPrice, forKey: "origi1")
        userDefaults.set(self.final, forKey: "afterprice")

        self.cash()
    }
    
    //MARK:- Third Step - Credit Card
    func cash() {
        
        print(diz)
        print(venueName)
        print(venueID)
        print(checkIn)
        print(companyUID)
        print(price)
        print(companyName)

        
             guard let uid = Auth.auth().currentUser?.uid else {return}
        
             let appointment = [
                
                 "Date": checkIn,
                 "postid":diz,
                "paymentTransactionId":id,
                "paymentService":"Moyasar",
                "ref":refNumber,
                 "venueName":venueName,
                 "venueID":venueID,
                 "userBookingStatus":"",
                 "bookingStatus":"Approved",
                 "paymentStatus":"Paid",
                 "StoreName":venueName,
                 "fullName":companyName,
                 "UserID":uid,
                 "numberofTimes":Double(numberoftimes),
                 "venueCity":city,
                 "venueType":venueType,
                 "storeID":companyUID,
                 "userbookedName":self.userName,
                 "storeImage":self.storeImage,
                 "userImage":self.userImage,
                 "userbookedNumber":self.userphoneNumber,
                 "userbookedEmail":self.useremail,
                 "creationDate":Date().timeIntervalSince1970,
                
                "discounet":discounet,
                "originalPrice":firstPrice,
                "pricewithDiscuount":pricewithDiscount,
                 "price":"\(fullPrice)"
                 ] as [String : Any]
             
         Database.database().reference().child("TimeBooked").child(companyUID).child(venueName).child(checkIn).child(uid).setValue(nil)
             

             
             for i in 0..<arrSelectedDatae.count {

                        let time = arrSelectedDatae[i]
                        
                        let values = [
                            "time\(i + 1)": time
                        ] as [String:Any]
                 
        Database.database().reference().child("users").child("profile").child(uid).child("myAppointments").child(checkIn).child(venueID).child(diz).child("times").updateChildValues(values)
                
                
        Database.database().reference().child("VenueAppointments").child("Active").child(venueID).child(diz).child("times").updateChildValues(values)
                 
        Database.database().reference().child("users").child("profile").child(uid).child("myHistoryReservations").child(diz).child("times").updateChildValues(values)
             
        Database.database().reference().child("Services").child(country).child(city).child(venueType).child(venueID).child("mySchedule").child(price).child(venueID).child("dates").child(checkIn).observe(.value) { (snapshot) in
             
        if let snaps = snapshot.value as? [String:Any] {
            for each in snaps {
            let uid = each.key
            if(uid == time) {
             
        Database.database().reference().child("Services").child(self.country).child(self.city).child(self.venueType).child(self.venueID).child("mySchedule").child(self.price).child(self.venueID).child("dates").child(self.checkIn).child(uid).setValue(nil)
                                     
                Database.database().reference().child("stores").child("Allbuisness").child(self.venueType).child(self.companyUID).child("mySchedule").child(self.price).child(self.venueID).child("dates").child(self.checkIn).child(uid).setValue(nil)
             
                        }
                    }
                }
            }
                 
        Database.database().reference().child("users").child("profile").child(uid).child("myAppointments").child(checkIn).child(venueID).child(diz).updateChildValues(appointment)
                 
        Database.database().reference().child("users").child("profile").child(uid).child("myHistoryReservations").child(diz).updateChildValues(appointment)
                 
        Database.database().reference().child("VenueAppointments").child("Active").child(venueID).child(diz).updateChildValues(appointment)
                 
             }
             
            performSegue(withIdentifier: "booked", sender: nil)
             
             let userDefaults = UserDefaults()
            userDefaults.set(venueName, forKey: "venuename1")
            userDefaults.set(companyName, forKey: "companyname1")
            userDefaults.set(self.userName, forKey: "username1")
            userDefaults.set(self.userphoneNumber, forKey: "phoneNumber1")
            userDefaults.set(self.useremail, forKey: "email1")
            userDefaults.set(diz, forKey: "postid")
            userDefaults.set(companyUID, forKey: "storeID")
            userDefaults.set("paid", forKey: "condition")
            userDefaults.set(price, forKey: "price1")
            userDefaults.set(numberoftimes, forKey: "number1")
            userDefaults.set(discounet, forKey: "discount1")
            userDefaults.set(firstPrice, forKey: "origi1")
            userDefaults.set(pricewithDiscount, forKey: "pricewithDiscount")
            userDefaults.set(final, forKey: "afterprice")

    }


}
