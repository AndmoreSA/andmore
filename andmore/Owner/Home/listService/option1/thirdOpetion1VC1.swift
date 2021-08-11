//
//  thirdOpetion1VC1.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 02/06/2021.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField
import JGProgressHUD

class thirdOpetion1VC1: UITableViewController,UITextFieldDelegate , UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    // MARK:- variables
    var cardID: String!
    var venueName:String!
    var venueID:String!
    var CountryString: String = "NULL"
    var CityString: String = "NULL"
    private var pickerGeneral1 = ["SAR","AED","BHD","KWD","USD","GBP"]
    private var pickerGeneral2 = ["SAR","AED","BHD","KWD","USD","GBP"]
    private var pickerGeneral3 = ["SAR","AED","BHD","KWD","USD","GBP"]

    
    private var CurrencyPicker1: UIPickerView?
    private var CurrencyPicker2: UIPickerView?
    private var CurrencyPicker3: UIPickerView?

    var currentTextField = UITextField()
    var pickerView = UIPickerView()
    
    //MARK:- Outlets
    @IBOutlet weak var hourCurrencyPrice: SkyFloatingLabelTextField!
    @IBOutlet weak var dayCurrencyPrice: SkyFloatingLabelTextField!
    @IBOutlet weak var hourPrice: SkyFloatingLabelTextField!
    @IBOutlet weak var dayPrice: SkyFloatingLabelTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hourPrice.keyboardType = .asciiCapableNumberPad
        dayPrice.keyboardType = .asciiCapableNumberPad

        
        getVenueCountry()
        
        let startToolBar = UIToolbar()
             startToolBar.barStyle = UIBarStyle.default
             startToolBar.isTranslucent = true
             startToolBar.tintColor = UIColor.black
             startToolBar.sizeToFit()
             
             let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.dismissKeyboards))
             let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
             startToolBar.setItems([spaceButton, doneButton], animated: false)
             startToolBar.isUserInteractionEnabled = true
        
        CurrencyPicker1 = UIPickerView()
        CurrencyPicker1?.delegate = self
        hourCurrencyPrice.inputView = CurrencyPicker1
        hourCurrencyPrice.inputAccessoryView = startToolBar
        
        let startToolBar2 = UIToolbar()
              startToolBar2.barStyle = UIBarStyle.default
              startToolBar2.isTranslucent = true
              startToolBar2.tintColor = UIColor.black
              startToolBar2.sizeToFit()
              
              let doneButton2 = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.dismissKeyboards1))
              let spaceButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
              startToolBar2.setItems([spaceButton2, doneButton2], animated: false)
              startToolBar2.isUserInteractionEnabled = true

        CurrencyPicker2 = UIPickerView()
        CurrencyPicker2?.delegate = self
        dayCurrencyPrice.inputView = CurrencyPicker2
        dayCurrencyPrice.inputAccessoryView = startToolBar2

        pickerView.delegate = self
        pickerView.dataSource = self
        hourCurrencyPrice.delegate = self
        dayCurrencyPrice.delegate = self
        
        self.hideKeyboardWhenTappedAround()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
          let userrs = UserDefaults()
          if let data6 = userrs.object(forKey: "typeess") {
          if let message2 = data6 as? String {
          cardID = message2
              }

          }

          let userrw = UserDefaults()
          if let data7 = userrw.object(forKey: "names") {
          if let message3 = data7 as? String {
          venueName = message3
              }
          }
        
          let iddi = UserDefaults()
            if let data7 = iddi.object(forKey: "postID") {
            if let message3 = data7 as? String {
            venueID = message3
            }
        }
    }

    // MARK: - Table view data source
    @objc func dismissKeyboards() {
        let selectedIndex = CurrencyPicker1?.selectedRow(inComponent: 0)
                if selectedIndex == 0 {
                    hourCurrencyPrice.text = pickerGeneral1[selectedIndex!]
                    hourCurrencyPrice.resignFirstResponder()
                    self.view.endEditing(true)
                } else {
                    hourCurrencyPrice.text = pickerGeneral1[selectedIndex!]
                    hourCurrencyPrice.resignFirstResponder()
                    view.endEditing(true)
                }
        
    }
    
    @objc func dismissKeyboards1() {
        let selectedIndex = CurrencyPicker2?.selectedRow(inComponent: 0)
                if selectedIndex == 0 {
                    dayCurrencyPrice.text = pickerGeneral2[selectedIndex!]
                    dayCurrencyPrice.resignFirstResponder()
                    self.view.endEditing(true)
                } else {
                    dayCurrencyPrice.text = pickerGeneral2[selectedIndex!]
                    dayCurrencyPrice.resignFirstResponder()
                    view.endEditing(true)
                }    }
    
    
   

    @IBAction func submitPressed(_ sender: Any) {
        
        if(!hourCurrencyPrice.text!.trimmingCharacters(in: .whitespaces).isEmpty) && (!dayCurrencyPrice.text!.trimmingCharacters(in: .whitespaces).isEmpty) && (!hourPrice.text!.trimmingCharacters(in: .whitespaces).isEmpty) && (!dayPrice.text!.trimmingCharacters(in: .whitespaces).isEmpty) {

        if Reachability.isConnectedToNetwork(){
              let hud = JGProgressHUD(style: .dark)
               hud.indicatorView = JGProgressHUDRingIndicatorView()
               hud.textLabel.text = "Uploading"
               hud.show(in: view)
        
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let hour = hourPrice.text else {return}
        guard let currencyHour = hourCurrencyPrice.text else {return}
        
        guard let Day = dayPrice.text else {return}
        guard let CurrencyDay = dayCurrencyPrice.text else {return}

         let ref = Database.database().reference().child("stores").child("Allbuisness").child(cardID).child(uid).child("Services").child(venueID)
        
        let ref2 =
            Database.database().reference().child("Services").child(CountryString).child(CityString).child(cardID).child(venueID)
        
        
        let priceDetails = [
            
            
            "CurrencyHour":currencyHour,
            "CurrencyDay":CurrencyDay,
            "perHourPrice":Double(hour),
            "perDayPrice":Double(Day)
            
        ] as [String:Any]
        
        
        ref.updateChildValues(priceDetails)
        ref2.updateChildValues(priceDetails)

        
        hud.textLabel.text = "Success !"
        hud.dismiss(afterDelay: 5.0, animated: true)
        self.performSegue(withIdentifier: "toThird", sender: nil)
            
        } else {
            self.createAlert2(title: "check your network", message: "")
        }
            
        } else {
            let alert = UIAlertController(title: "Sorry you forgot to fill the required text", message: "You need to type something", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    // MARK:- Properties
    
    func getVenueCountry() {
        
         guard let uid = Auth.auth().currentUser?.uid else {return}
         let ref = Database.database().reference().child("All").child(uid)
        
            
            ref.observeSingleEvent(of: .value) { (snapshot) in
             print(snapshot)

             let dictionaries = snapshot.value as? NSDictionary

             self.CountryString = dictionaries?["country"] as! String
             self.CityString = dictionaries?["city"] as! String
             
             
             print(self.CityString)
             
             print(self.CountryString)
        
    }
        
    }
    
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
       
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           
           
           if currentTextField == hourCurrencyPrice {
           return pickerGeneral1[row]
           } else if currentTextField == dayCurrencyPrice {
            return pickerGeneral1[row]
           } else {
               return ""
           }
        }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           
           if currentTextField == hourCurrencyPrice {
               return pickerGeneral1.count
           } else if currentTextField == dayCurrencyPrice {
            return pickerGeneral1.count
           } else {
               return 0
           }
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           
           if currentTextField == hourCurrencyPrice {
               hourCurrencyPrice.text = pickerGeneral1[row]
           } else if currentTextField == dayCurrencyPrice {
           dayCurrencyPrice.text = pickerGeneral1[row]
           } else {
               print("No Data..")
           }
       }
       

       func textFieldDidBeginEditing(_ textField: UITextField) {
           self.pickerView.delegate = self
           self.pickerView.dataSource = self
           currentTextField = textField

           if currentTextField == hourCurrencyPrice {
               hourCurrencyPrice.inputView = pickerView
           }
       }
    
    func cancelBooking() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}

        Database.database().reference().child("stores").child("Allbuisness").child(cardID).child(uid).child("Services").child(venueID).setValue(nil)
        
        Database.database().reference().child("Services").child(CountryString).child(CityString).child(cardID).child(venueID).setValue(nil)
    
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Are you sure you want to cancel it?", message: "The venue detailed will be cancelled, you need to start again", preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "Sure", style: .default, handler: { (action:UIAlertAction) in
               self.cancelBooking()
             WindowManager.show(storyboard: .seller, animated: true)
           }))
           
           alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action:UIAlertAction) in
               print("CancelTapped")
           }))
           present(alertController, animated: true, completion: nil)
         
        
    }
    

}
