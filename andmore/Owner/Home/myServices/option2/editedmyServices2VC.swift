//
//  editedmyServices2VC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 02/06/2021.
//

import UIKit
import SkyFloatingLabelTextField
import FirebaseAuth
import FirebaseDatabase
import Firebase
import JGProgressHUD

class editedmyServices2VC: UITableViewController, UITextFieldDelegate , UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var TextCount: UILabel!
    @IBOutlet weak var venueDisciprionText: UITextView!
    @IBOutlet weak var venueName: SkyFloatingLabelTextField!
    @IBOutlet weak var currencyHour: SkyFloatingLabelTextField!
    @IBOutlet weak var currencyDay: SkyFloatingLabelTextField!
    @IBOutlet weak var priceHour: SkyFloatingLabelTextField!
    @IBOutlet weak var priceDay: SkyFloatingLabelTextField!
    @IBOutlet weak var noOfPeopleText: SkyFloatingLabelTextField!

    var shops = [ShopSearch]()
    var selectedShop: ShopSearch?
    var ref: DatabaseReference!
    var venuesName:String = ""
    var venueType:String = ""
    var venueId:String = ""
    var venueCountry:String = ""
    var companyName:String = ""
    var venueCity:String = ""
    var VenueLat: Double = 0
    var VenueLong: Double = 0
    var type:String!
    
    
    private var pickerGeneral1 = ["SAR","AED","BHD","KWD","USD","GBP"]
    private var pickerGeneral2 = ["SAR","AED","BHD","KWD","USD","GBP"]

    
    private var CurrencyPicker1: UIPickerView?
    private var CurrencyPicker2: UIPickerView?

    var currentTextField = UITextField()
    var pickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currencyDay.isEnabled = false
        self.currencyHour.isEnabled = false

        self.venueName.isEnabled = false
        
        self.hideKeyboardWhenTappedAround()
        venueDisciprionText.delegate = self
        
        CurrencyPicker1 = UIPickerView()
        CurrencyPicker1?.delegate = self
        currencyHour.inputView = CurrencyPicker1

        CurrencyPicker2 = UIPickerView()
        CurrencyPicker2?.delegate = self
        currencyDay.inputView = CurrencyPicker2

        
        pickerView.delegate = self
        pickerView.dataSource = self
        currencyHour.delegate = self
        currencyDay.delegate = self
        
        
        if let VenueNames = selectedShop?.venueName {
            venuesName = VenueNames
    }
        
            if let venueIDz = selectedShop?.venueID {
                venueId = venueIDz
        }
        if let venuttype = selectedShop?.venueType {
            venueType = venuttype
    }
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        ref = Database.database().reference()
        
        getVenueLocations()
        loadProfileData()


    }
    
    func getVenueLocations() {
           
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let ref = Database.database().reference().child("All").child(uid)
           
               
               ref.observeSingleEvent(of: .value) { (snapshot) in
                print(snapshot)

                let dictionaries = snapshot.value as? NSDictionary

                self.VenueLat = dictionaries?["lat"] as! Double ?? 0
                self.VenueLong = dictionaries?["long"] as! Double ?? 0
                self.venueCountry = dictionaries?["country"] as! String
                self.venueCity = dictionaries?["city"] as! String
                self.companyName = dictionaries?["fullName"] as! String
       }
           
       }
    
    // MARK:- Properties
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
               return 1
           }
          
          func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
              
              
              if currentTextField == currencyHour {
              return pickerGeneral1[row]
              } else if currentTextField == currencyDay {
               return pickerGeneral2[row]
              } else {
                  return ""
              }
           }
          
          func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
              
              if currentTextField == currencyHour {
                  return pickerGeneral1.count
              } else if currentTextField == currencyDay {
               return pickerGeneral2.count
              } else {
                  return 0
              }
          }
          
          func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
              
              if currentTextField == currencyHour {
                  currencyHour.text = pickerGeneral1[row]
                  self.view.endEditing(true)
              } else if currentTextField == currencyDay {
              currencyDay.text = pickerGeneral2[row]
              self.view.endEditing(true)
              } else {
                  print("No Data..")
              }
          }
          

          func textFieldDidBeginEditing(_ textField: UITextField) {
              self.pickerView.delegate = self
              self.pickerView.dataSource = self
              currentTextField = textField

              if currentTextField == currencyHour {
                  currencyHour.inputView = pickerView
              }
          }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = venueDisciprionText.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else {return false}
        
        let updateText = currentText.replacingCharacters(in: stringRange, with: text)
        
        TextCount.text = "\(300 - updateText.count)"
        
        return updateText.count < 300
    }

    func loadProfileData() {
        
        guard let userId = Auth.auth().currentUser?.uid else {return}
        let ref =
            Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(userId).child("Services").child(venueId).observe(.value, with: { (snapshot) in
                let values = snapshot.value as? NSDictionary
            
            // MARK:- 1
                
                self.venueName.text = values?["VenueName"] as? String ?? ""
                self.noOfPeopleText.text = values?["NumberofPeople"] as? String ?? ""
            
            
            self.venueDisciprionText.text = values?["VenueDiscription"]as? String ?? ""

            // MARK:- 6
                           
                self.currencyHour.text = values?["CurrencyHour"] as? String ?? ""

                self.currencyDay.text = values?["CurrencyDay"] as? String ?? ""
                 let hour = values?["perHourPrice"] as? Double ?? 0
                 let day = values?["perDayPrice"] as? Double ?? 0

                self.priceHour.text = "\(String(format: "%.02f", hour))"
                self.priceDay.text = "\(String(format: "%.02f", day))"
        })
    }
    
  
    @IBAction func upload(_ sender: Any) {
        uploadingToserver()
    }
    
    func uploadingToserver() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let name = venueName.text else {return}
        guard let people = noOfPeopleText.text else {return}
        guard let hour = priceHour.text else {return}
        guard let currencyHour = currencyHour.text else {return}
        guard let venueDisc = venueDisciprionText.text else {return}

        guard let Day = priceDay.text else {return}
        guard let CurrencyDay = currencyDay.text else {return}

        
        let hud = JGProgressHUD(style: .dark)
                    hud.indicatorView = JGProgressHUDRingIndicatorView()
                    hud.textLabel.text = "Uploading"
                    hud.show(in: view)
                  
        let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueId)
        
        let ref2 = Database.database().reference().child("Services").child(self.venueCountry).child(self.venueCity).child(venueType).child(venueId)
        
        
        let venueDetails = [
        
            "VenueName": name,
            "VenueDiscription":venueDisc,
            "NumberofPeople":people,
            "perHourPrice":Double(hour),
            "perDayPrice":Double(Day),
            "CurrencyHour":currencyHour,
            "CurrencyDay":CurrencyDay,
            "fullName":companyName,
        ] as [String:Any]
        
        
             
              
              
        ref.updateChildValues(venueDetails) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            ref2.updateChildValues(venueDetails)
            print("profile Successfully Updated")
            hud.textLabel.text = "Success !"
            hud.dismiss(afterDelay: 5.0, animated: true)
            let userDefaults = UserDefaults()
            userDefaults.set(self.venuesName, forKey: "venueNameess")
            userDefaults.set(self.venueId, forKey: "venueID")
            userDefaults.set(self.venueType, forKey: "venueTypesK")
            self.performSegue(withIdentifier: "finalStep", sender: nil)
            
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "finalStep" {
                    
            if let selectedPhone = sender as? ShopSearch,
                let destinationVC = segue.destination as? UINavigationController {
                  if let childVc = destinationVC.topViewController as? editedPrices2VC {
                      childVc.selectedShop = selectedPhone
                  }
            }
        }
    }
    
    @IBAction func backbuttonPressed(_ sender: Any) {
        
        WindowManager.show(storyboard: .seller, animated: true)
    }

}
