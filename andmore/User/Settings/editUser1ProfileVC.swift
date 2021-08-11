//
//  editUser1ProfileVC.swift
//  andmore
//
//

import UIKit
import FirebaseAuth
import Firebase
import SDWebImage
import SkyFloatingLabelTextField
import JGProgressHUD
import Loaf

class editUser1ProfileVC: UITableViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate,  UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    // MARK:- Outlets

    @IBOutlet weak var genderSegmments: UISegmentedControl!
    @IBOutlet weak var countrylabel: SkyFloatingLabelTextField!
    @IBOutlet weak var cityLabel: SkyFloatingLabelTextField!
    @IBOutlet weak var edulevel: SkyFloatingLabelTextField!
    @IBOutlet weak var expLabel: SkyFloatingLabelTextField!
    @IBOutlet weak var skillsLabel: SkyFloatingLabelTextField!
    @IBOutlet weak var specilityLabel: SkyFloatingLabelTextField!
    @IBOutlet weak var linkedinLabel: SkyFloatingLabelTextField!
    @IBOutlet weak var twitterLabel: SkyFloatingLabelTextField!
    @IBOutlet weak var bioText: SkyFloatingLabelTextField!
    @IBOutlet weak var bioCount: UILabel!
    @IBOutlet weak var expStepper: UIStepper!
    
    // MARK:- Variables
    var storageRef: StorageReference!
    var databaseRef: DatabaseReference!
    var pickedImageProduct = UIImage()
    var segment1:String!
    var authCredential: AuthCredential?
    
    
    // MARK:- Variables for PickerViews
    var eduicationalType:[String] = []
    var VenueType:[String] = []
    var pickerView = UIPickerView()
    var currentTextField = UITextField()
    var picker_0 = UIPickerView()
    var picker_1 = UIPickerView()
    var picker_2 = UIPickerView()
    private var CountryPicker = ["Saudi Arabia","United Arab Emeriates","Bahrain","Kuwait"]
     private var subCityArray = [
         
         //Saudi Arabia
         ["Al-Hassa","Dammam","Khobar","Riyadh","Hafer Al Baten","Jeddah","Makkah","Medina","Qassim","Jubail"],
         //UAE
         ["Dubai","Abu Dhabi"],
         //Bahrain
         ["Manamah"],
         //Kuwait
         ["Kuwait"]
     ]
    
    private var _currentSelection: Int = 0
      var currentSelection: Int {
          get {
              return _currentSelection
          }
          set {
              _currentSelection = newValue
              picker_0.reloadAllComponents()
              picker_1.reloadAllComponents()
              }
          }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerProperties()
        retrieveUserName()
        
        databaseRef = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        self.hideKeyboardWhenTappedAround()
    }
 
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = bioText.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else {return false}
        
        let updateText = currentText.replacingCharacters(in: stringRange, with: string)
        bioCount.text = "\(100 - updateText.count)"
        
        return updateText.count < 100
    }
    
    
    func pickerProperties() {
        currentSelection = 0;
        picker_0.delegate = self
        picker_0.dataSource = self
        picker_0.tag = 0
        picker_1.delegate = self
        picker_1.dataSource = self
        picker_1.tag = 1
        countrylabel.inputView = picker_0
        cityLabel.inputView = picker_1
        
        pickerView.delegate = self
        pickerView.dataSource = self
        bioText.delegate = self
        countrylabel.delegate = self
        cityLabel.delegate = self
        edulevel.delegate = self

        
        let startToolBar = UIToolbar()
        startToolBar.barStyle = UIBarStyle.default
        startToolBar.isTranslucent = true
        startToolBar.tintColor = UIColor.black
        startToolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.dismissKeyboards))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        startToolBar.setItems([spaceButton, doneButton], animated: false)
        startToolBar.isUserInteractionEnabled = true
        
        
        let startToolBar2 = UIToolbar()
        startToolBar2.barStyle = UIBarStyle.default
        startToolBar2.isTranslucent = true
        startToolBar2.tintColor = UIColor.black
        startToolBar2.sizeToFit()
        
        let doneButton2 = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.dismissKeyboards1))
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        startToolBar2.setItems([spaceButton2, doneButton2], animated: false)
        startToolBar2.isUserInteractionEnabled = true
        
        let startToolBar3 = UIToolbar()
        startToolBar3.barStyle = UIBarStyle.default
        startToolBar3.isTranslucent = true
        startToolBar3.tintColor = UIColor.black
        startToolBar3.sizeToFit()
        
        let doneButton3 = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.dismissKeyboards2))
        let spaceButton3 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        startToolBar3.setItems([spaceButton3, doneButton3], animated: false)
        startToolBar3.isUserInteractionEnabled = true
        
        
        countrylabel.inputAccessoryView = startToolBar
        cityLabel.inputAccessoryView = startToolBar2
        edulevel.inputAccessoryView = startToolBar3
        
        eduicationalType = ["Prefer not to say","High school", "Bachelor's Degree","Master's Degree","Doctoral Degree"]
        picker_2.delegate = self
        picker_2.dataSource = self
        picker_2.tag = 2
        edulevel.inputView = picker_2
    }
    
    @objc func dismissKeyboards() {
        let selectedIndex = picker_0.selectedRow(inComponent: 0)
        countrylabel.text = CountryPicker[selectedIndex]
        countrylabel.resignFirstResponder()
        view.endEditing(true)
    }
    
    @objc func dismissKeyboards1() {
        let selectedIndex = picker_1.selectedRow(inComponent: 0)
        cityLabel.text = subCityArray[currentSelection][selectedIndex]
        cityLabel.resignFirstResponder()
        view.endEditing(true)
    }
    
    @objc func dismissKeyboards2() {
        let selectedIndex = picker_2.selectedRow(inComponent: 0)
        edulevel.text = eduicationalType[selectedIndex]
        edulevel.resignFirstResponder()
        view.endEditing(true)
    }
    
    // MARK: - Table view data source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           if pickerView.tag == 0 {
               return CountryPicker[row]
           } else if pickerView.tag == 1 {
               return subCityArray[currentSelection][row]
           } else {
            return eduicationalType[row]
        }
       }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           if pickerView.tag == 0 {
               return CountryPicker.count
           } else if pickerView.tag == 1 {
               return subCityArray[currentSelection].count
           } else {
            return eduicationalType.count
        }
       }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            currentSelection = row
            countrylabel.text = CountryPicker[row]
//            self.view.endEditing(true)
        } else if pickerView.tag == 1 {
            cityLabel.text = subCityArray[currentSelection][row]
//            self.view.endEditing(true)
        } else if pickerView.tag == 2 {
            edulevel.text = eduicationalType[row]
        }
        
    }
    
    
    
    // MARK:- Properties
    
    func retrieveUserName() {
           if let userID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child("profile").child(userID).observe(.value) { (snapshot) in
                   let dict = snapshot.value as? NSDictionary
                   let username = dict?["fullName"] as? String
                   let email = dict?["email"] as? String
                   let phoneNumber = dict?["phoneNumber"] as? String
                   let gender = dict?["Gender"] as? String
                let county = dict?["country"] as? String
                let city = dict?["city"] as? String
                let educationalLevel = dict?["educationalLevel"] as? String
                let Experience = dict?["Experience"] as? String
                let skills = dict?["skills"] as? String
                let specility = dict?["specility"] as? String
                let linkedin = dict?["idLinkedIN"] as? String
                let twitter = dict?["twitter"] as? String
                let bio = dict?["bio"] as? String

                
                if gender == "Male" {
                    self.genderSegmments.selectedSegmentIndex = 0
                } else if gender == "Female" {
                    self.genderSegmments.selectedSegmentIndex = 1
                }
                
                    self.countrylabel.text = county
                    self.cityLabel.text = city
                    self.edulevel.text = educationalLevel
                    self.expLabel.text = Experience
                    self.skillsLabel.text = skills
                    self.specilityLabel.text = specility
                    self.linkedinLabel.text = linkedin
                    self.twitterLabel.text = twitter
//                    self.phoneNumberTxt.text = phoneNumber
//                    self.fullNameTxt.text = username
//                    self.emailTxt.text = email
                    self.bioText.text = bio
//
//                   if let profileImageURL = dict?["profileImageURL"] as? String {
//                       self.profileImage.sd_setImage(with: URL(string: profileImageURL))
//                   }
               }
           }
           print("couldn't find the user name")
       }
      


    
      
    
    func upateUserProfile() {
        
           let hud = JGProgressHUD(style: .dark)
               hud.indicatorView = JGProgressHUDRingIndicatorView()
               hud.textLabel.text = "Updating"
               hud.show(in: view)
        
            guard let userID = Auth.auth().currentUser?.uid else {return}
            guard let country = self.countrylabel.text else {return}
            guard let city = self.cityLabel.text else {return}
            guard let edu = self.edulevel.text else {return}
            guard let exp = self.expLabel.text else {return}
            guard let skills = self.skillsLabel.text else {return}
            guard let specility = self.specilityLabel.text else {return}
            guard let link = self.linkedinLabel.text else {return}
            guard let twit = self.twitterLabel.text else {return}
            guard let bio = self.bioText.text else {return}

                var ur1:String
                 if(self.segment1 == nil) {
                     ur1 = "Male"
                 } else {
                     ur1 = self.segment1
                 }
    
    
                
                let newValuesForProfile = [
                    
                        "Gender": ur1,
                        "country": country,
                        "city": city,
                        "educationalLevel":edu,
                        "Experience":exp,
                        "skills":skills,
                        "specility":specility,
                        "idLinkedIN":link,
                        "twitter":twit,
                        "bio":bio
                        ] as [String:Any]
                self.databaseRef.child("users/profile/\(userID)").updateChildValues(newValuesForProfile, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        print(error!)
                        return
                                // failed
                        hud.textLabel.text = error?.localizedDescription
                        hud.dismiss(afterDelay: 5.0, animated: true)
                    }
                    print("profile Successfully Updated")
                    self.databaseRef.child("All").child(userID).updateChildValues(newValuesForProfile, withCompletionBlock: { (error, ref) in
                        if error != nil {
                            print(error!)
                                    // failed
                            hud.textLabel.text = error?.localizedDescription
                            hud.dismiss(afterDelay: 5.0, animated: true)
                            return
                        }
                        print("profile Successfully Updated")
                        hud.textLabel.text = "Success !"
                        hud.dismiss(afterDelay: 5.0, animated: true)
                        self.dismiss(animated: true, completion: nil)

                    })
                })
        
    }
    
    
    
    // MARK:- Actions
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        expLabel.text = String(sender.value)
    }
    
    
    @IBAction func selectionSegmentsPressed(_ sender: Any) {
        self.segment1 = genderSegmments.titleForSegment(at: genderSegmments.selectedSegmentIndex)
        print(segment1)
    }
    
    @IBAction func updateBtnPressed(_ sender: Any) {
        upateUserProfile()
    }
    
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

