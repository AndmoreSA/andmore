//
//  stage3VC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 08/06/2021.
//

import UIKit

class stage3VC: UIViewController , UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var serviceTxt: UITextField!
    
    private var DatePicker: UIDatePicker?
    var PriceType:[String] = []
    var pickerView = UIPickerView()
    var picker_0 = UIPickerView()
    var picker_1 = UIPickerView()
    var currentSelection: Int = 0
    var serviceType:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveInfo()
        textProperties()
        self.hideKeyboardWhenTappedAround()
    }
    
    func retrieveInfo() {
       let namse = UserDefaults()
       if let data3 = namse.object(forKey: "service1") {
       if let message1 = data3 as? String {
        serviceType = message1
           print(message1)
               }
           }
        }
    
    func textProperties() {
        let startToolBar5 = UIToolbar()
        startToolBar5.barStyle = UIBarStyle.default
        startToolBar5.isTranslucent = true
        startToolBar5.tintColor = UIColor.black
        startToolBar5.sizeToFit()

        let doneButton5 = UIBarButtonItem(title: "Today", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.dismissKeyboards4))
                let enddoneButton5 = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.dismissKeyboards5))
        let spaceButton5 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        startToolBar5.setItems([enddoneButton5,spaceButton5, doneButton5], animated: false)
        startToolBar5.isUserInteractionEnabled = true
        
        dateTxt.inputAccessoryView = startToolBar5
        
        let startToolBar4 = UIToolbar()
        startToolBar4.barStyle = UIBarStyle.default
        startToolBar4.isTranslucent = true
        startToolBar4.tintColor = UIColor.black
        startToolBar4.sizeToFit()
        
        let doneButton4 = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.dismissKeyboards3))
        let spaceButton4 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        startToolBar4.setItems([spaceButton4, doneButton4], animated: false)
        startToolBar4.isUserInteractionEnabled = true
        
        serviceTxt.inputAccessoryView = startToolBar4

        
        PriceType = ["Hour", "Day"]
        currentSelection = 0;
        picker_1.delegate = self
        picker_1.dataSource = self
        picker_1.tag = 1
        serviceTxt.inputView = picker_1
        
        DatePicker = UIDatePicker()
        DatePicker?.datePickerMode = .date
        DatePicker?.preferredDatePickerStyle = .wheels
        DatePicker?.minimumDate = Date()
        let loc = Locale(identifier: "en")
        self.DatePicker?.locale = loc
        dateTxt.inputView = DatePicker
        DatePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
    }
    
    @objc func dateChanged(datePicker:UIDatePicker) {
     
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-M-d"
     dateFormatter.locale = Locale(identifier: "en")
        dateTxt.text = dateFormatter.string(from: datePicker.date)
         view.endEditing(true)
         
     }
    
    @objc func dismissKeyboards3() {
        let selectedIndex = picker_1.selectedRow(inComponent: 0)
        serviceTxt.text = PriceType[selectedIndex]
        serviceTxt.resignFirstResponder()
        view.endEditing(true)
    }
    
    @objc func dismissKeyboards4() {

        let datePicker = UIDatePicker()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d"
        dateFormatter.locale = Locale(identifier: "en")
        dateTxt.text = dateFormatter.string(from: datePicker.date)
        dateTxt.resignFirstResponder()
    }

    @objc func dismissKeyboards5() {
        dateTxt.inputView = DatePicker
        dateTxt.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
                 return PriceType[row]
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
                return PriceType.count
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        serviceTxt.text = PriceType[row]
       }
    
    //MARK:-Actions
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated:true,completion:nil)
    }
    
    @IBAction func continueBtnPressed(_ sender: Any) {
        let userDefaults = UserDefaults()
        userDefaults.set(dateTxt.text, forKey: "date1")
        userDefaults.set(serviceTxt.text, forKey: "service2")
        
        if serviceType == "Men Salons" {
            performSegue(withIdentifier: "goToResult4", sender: nil)
        } else if serviceType == "Women Salons" {
            performSegue(withIdentifier: "goToResult4", sender: nil)
        } else if serviceType == "Home Salons" {
            performSegue(withIdentifier: "goToResult4", sender: nil)
        } else if serviceType == "Wedding Halls" {
            performSegue(withIdentifier: "goToResult3", sender: nil)
        } else if serviceType == "Photography shop" {
            performSegue(withIdentifier: "goToResult4", sender: nil)
        } else if serviceType == "Event Orgnizor" {
            performSegue(withIdentifier: "goToResult4", sender: nil)
        } else {
            performSegue(withIdentifier: "goToResult3", sender: nil)
        }
    }

}
