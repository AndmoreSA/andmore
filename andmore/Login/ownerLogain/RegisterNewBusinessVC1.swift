//
//  RegisterNewBusinessVC1.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 31/05/2021.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField
import JGProgressHUD
import CoreLocation
import MapKit
import CoreData
import Loaf

class RegisterNewBusinessVC1: UITableViewController,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate,CLLocationManagerDelegate {

    //variables
    var imagePicker: UIImagePickerController!
    
    //MARK:- Variables
    var cardID: String?
    var ownerD: String!
    var companyID: String?
    var emailID: String?
    var phoneID: String?
    var typeID: String?
    var telephonID: String?
    var passwordID: String?
    var countryID: String?
    var cityID: String?
    var districtID: String?
    var streetId: String?
    var zipCodeID: String?
    var locationManager = CLLocationManager()
    var userLocation = CLLocation()
    var choosenLatitude: Double = 0
    var choosenLongtitude: Double = 0
    var userlat = 0.0
    var userlong = 0.0
    var isNew: Bool!
    
    private var CountryPicker = ["Saudi Arabia","United Arab Emeriates","Bahrain"]
    private var subCityArray = [
           
           //Saudi Arabia
           ["Dammam","Khobar","Riyadh","Jeddah"],
           //UAE
           ["Dubai","Abu Dhabi"],
           //Bahrain
           ["Manamah"]
       ]
       
        var picker_0 = UIPickerView()
        var picker_1 = UIPickerView()
        var picker_2 = UIPickerView()
        var BusinessType:[String] = []

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
    
    
    
    //outlets

    @IBOutlet weak var companyImage1: UIImageView!
    @IBOutlet weak var businessType2: SkyFloatingLabelTextField!
    @IBOutlet weak var companyName: SkyFloatingLabelTextField!
    @IBOutlet weak var companyEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var companyTelephone: SkyFloatingLabelTextField!
    @IBOutlet weak var companyphoneNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var country: SkyFloatingLabelTextField!
    @IBOutlet weak var conpanyCity: SkyFloatingLabelTextField!
    @IBOutlet weak var companyDistrict: SkyFloatingLabelTextField!
    @IBOutlet weak var companyStreet: SkyFloatingLabelTextField!
    @IBOutlet weak var companyZipCode: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var signupbtn: UIBarButtonItem!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapKit.delegate = self
       locationManager.delegate = self
       locationManager.desiredAccuracy = kCLLocationAccuracyBest
       locationManager.requestWhenInUseAuthorization()
       locationManager.startUpdatingLocation()
       
       
       //relate to step2
       
       let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(RegisterNewBusinessVC1.chooseLocation(gestureRecongnizer:)))
       recognizer.minimumPressDuration = 0.35
       mapKit.addGestureRecognizer(recognizer)
       
       mapKit.showsUserLocation = true
        
        companyName.keyboardType = .asciiCapable
        companyEmail.keyboardType = .asciiCapable
        companyTelephone.keyboardType = .asciiCapable
        companyphoneNumber.keyboardType = .asciiCapable
        companyName.keyboardType = .asciiCapable

        BusinessType = ["Men Salons","Women Salons","Home Salons","Wedding Halls","Photography shop","Event Orgnizor","Chalets"]
        picker_2 = UIPickerView()
        picker_2.delegate = self
        businessType2.delegate = self
        
        //Pickers
        currentSelection = 0;
        picker_0.delegate = self
        picker_0.dataSource = self
        picker_0.tag = 0
        picker_1.delegate = self
        picker_1.dataSource = self
        picker_1.tag = 1
        picker_2.tag = 2
        country.inputView = picker_0
        conpanyCity.inputView = picker_1
        businessType2.inputView = picker_2
        
        companyName.delegate = self
        companyEmail.delegate = self
        companyTelephone.delegate = self
        companyphoneNumber.delegate = self
        country.delegate = self
        conpanyCity.delegate = self
        companyDistrict.delegate = self
        companyStreet.delegate = self
        companyZipCode.delegate = self
        passwordTextField.delegate = self
                
        //
        
        companyName.text = companyID
        businessType2.text = typeID
        companyEmail.text = emailID
        companyTelephone.text = telephonID
        companyphoneNumber.text = phoneID
        country.text = countryID
        conpanyCity.text = cityID
        companyDistrict.text = districtID
        companyStreet.text = streetId
        companyZipCode.text = zipCodeID
        passwordTextField.text = passwordID
        
        
        
        self.hideKeyboardWhenTappedAround()
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        companyImage1.isUserInteractionEnabled = true
        companyImage1.addGestureRecognizer(imageTap)
//        companyImage1.layer.cornerRadius = companyImage1.frame.size.width / 2
        companyImage1.clipsToBounds = true
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        
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
        
        let doneButton3 = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.dismissKeyboards3))
        let spaceButton3 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        startToolBar3.setItems([spaceButton3, doneButton3], animated: false)
        startToolBar3.isUserInteractionEnabled = true
        
        country.inputAccessoryView = startToolBar
        conpanyCity.inputAccessoryView = startToolBar2
        businessType2.inputAccessoryView = startToolBar3


    }
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }
        
    
    @objc func dismissKeyboards() {
        let selectedIndex = picker_0.selectedRow(inComponent: 0)
        country.text = CountryPicker[selectedIndex]
        country.resignFirstResponder()
        view.endEditing(true)
    }
    
    @objc func dismissKeyboards1() {
        let selectedIndex = picker_1.selectedRow(inComponent: 0)
        conpanyCity.text = subCityArray[currentSelection][selectedIndex]
        conpanyCity.resignFirstResponder()
        view.endEditing(true)
    }
    @objc func dismissKeyboards3() {
        let selectedIndex = picker_2.selectedRow(inComponent: 0)
        businessType2.text = BusinessType[selectedIndex]
        businessType2.resignFirstResponder()
        view.endEditing(true)
    }
     //Step 1
       
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           
           userLocation = locations[0]

           let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
           
           userlat = location.latitude
           userlong = location.longitude
           
           let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
           let region = MKCoordinateRegion(center: location, span: span)
           self.mapKit.setRegion(region, animated: true)
           
           locationManager.stopUpdatingLocation()
       }
       

       
       //Step 2
       
       @objc func chooseLocation(gestureRecongnizer:UILongPressGestureRecognizer) {
        
           
           if gestureRecongnizer.state == UIGestureRecognizer.State.began {
               let touchedPoint = gestureRecongnizer.location(in: self.mapKit)
               let chosenCoordinates = self.mapKit.convert(touchedPoint, toCoordinateFrom: self.mapKit)
               
               self.choosenLatitude = chosenCoordinates.latitude
               self.choosenLongtitude = chosenCoordinates.longitude
               
               let annotation = MKPointAnnotation()
                mapKit.removeAnnotations(mapKit.annotations)
            
               annotation.coordinate = chosenCoordinates
    //               annotation.title = shopName.text
               self.mapKit.addAnnotation(annotation)
           }
           
       }
     
     // MARK:- Other Properties
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           if pickerView.tag == 0 {
               return CountryPicker[row]
           } else if pickerView.tag == 1{
               return subCityArray[currentSelection][row]
           } else if pickerView.tag == 2 {
            return BusinessType[row]
           } else {
            return ""
           }
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           if pickerView.tag == 0 {
               return CountryPicker.count
           } else if pickerView.tag == 1 {
               return subCityArray[currentSelection].count
           } else if pickerView.tag == 2 {
            return BusinessType.count
           } else {
            return 0
           }
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           if pickerView.tag == 0 {
               currentSelection = row
               country.text = CountryPicker[row]
           } else if pickerView.tag == 1 {
               conpanyCity.text = subCityArray[currentSelection][row]
           } else {
//            currentSelection = row
            businessType2.text = BusinessType[row]
           }
           
       }
     
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            self.companyImage1.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            self.companyImage1.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
        }
    }
     
     @objc func openImagePicker(_ sender:Any) {
         // Open Image Picker
         self.present(imagePicker, animated: true, completion: nil)
     }
     
     override var preferredStatusBarStyle: UIStatusBarStyle {
         get {
             return .lightContent
         }
     }
    
    
    
    func saveProfile(
        companyName:String
        ,email:String
        ,TelephoneNumber:String
        ,phoneNumber:String
        ,country:String
        ,city:String
        ,typeID:String
        ,companyDistrict:String
        ,companyStreet:String
        ,companyZipCode:String
        ,profileImageURL:URL
        ,fcmToken:String
        ,password:String,
         completion: @escaping ((_ success:Bool)->())) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        cardID = uid
        
        let data5a = Database.database().reference().child("stores").child("Allbuisness").child(typeID).child(uid)
        
        let data4a = Database.database().reference().child("All").child(uid)
        
        let Alls = [
            "uid":uid,
            "fullName":companyName,
            "email":email,
            "telephoneNumber":TelephoneNumber,
            "phoneNumber":phoneNumber,
            "country":country,
            "city":city,
            "businessType":typeID,
            "district":companyDistrict,
            "street":companyStreet,
            "zipCode":companyZipCode,
            "fcmToken":fcmToken,
            "lat": self.choosenLatitude,
            "long":self.choosenLongtitude,
            "profileImageURL": profileImageURL.absoluteString,
            "creationDate": Date().timeIntervalSince1970
            ] as [String:Any]
    
        
        data5a.setValue(Alls) { error, ref in
                   completion(error == nil)
               }
        
        data4a.setValue(Alls) { error, ref in
                   completion(error == nil)
               }
        
    }
    
    // 2 Upload Image Profile
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        
        let hud = JGProgressHUD(style: .dark)
               hud.indicatorView = JGProgressHUDRingIndicatorView()
               hud.textLabel.text = "Uploading"
               hud.show(in: view)
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("stores/\(uid)")
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        
        
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { (metadata, error) in
            
            if error == nil, metaData != nil {
                storageRef.downloadURL{ (url, err) in
                    completion(url)
                    // success!
        hud.textLabel.text = "Success !"
        hud.dismiss(afterDelay: 5.0, animated: true)
                }
            } else {
                // failed
        hud.textLabel.text = error?.localizedDescription
        hud.dismiss(afterDelay: 5.0, animated: true)
                completion(nil)
            }
        }
    }
    
    // 3 last step
    
    func handleSignUp() {
        
        
        
        if companyName.text == "" && companyEmail.text == "" && companyTelephone.text == "" &&
            companyphoneNumber.text == "" && passwordTextField.text == "" && country.text == "" &&
            conpanyCity.text == "" && companyDistrict.text == "" && companyStreet.text == "" &&
            companyZipCode.text == "" {
            
            self.createAlert(title: "Failed", message: "please fill the required infomration")
            
            
        } else {
            
        guard let Name = companyName.text else { return }
        guard let Email = companyEmail.text else { return }
        guard let Telephone = companyTelephone.text else {return}
        guard let phoneNumber = companyphoneNumber.text else { return }
        guard let Country = country.text else {return}
        guard let City = conpanyCity.text else {return}
            guard let typeID = businessType2.text else {return}
        guard let District = companyDistrict.text else {return}
        guard let Street = companyStreet.text else {return}
        guard let ZipCode = companyZipCode.text else {return}
        guard let image = companyImage1.image else {return}
        guard let password = passwordTextField.text else {return}
        guard let fcmToken = Messaging.messaging().fcmToken else {return}
            
        
        let hud = JGProgressHUD(style: .dark)
                      hud.indicatorView = JGProgressHUDRingIndicatorView()
                      hud.textLabel.text = "Signing up ..."
                      hud.show(in: view)
            
            
        Auth.auth().createUser(withEmail: Email, password: password) { (user, error) in
            if error == nil && user != nil {
            hud.textLabel.text = "Success !"
            hud.dismiss(afterDelay: 5.0, animated: true)
                print("User Created!")
        self.uploadProfileImage(image) { url in
            
            if url != nil {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = Name
                changeRequest?.photoURL = url
                changeRequest?.commitChanges(completion: { (error) in
                    if error == nil {
                        
                        hud.indicatorView = JGProgressHUDRingIndicatorView()
                        hud.textLabel.text = "Done"
                        print("User Display Name Changed!")
                        
                        self.saveProfile(companyName: Name, email: Email, TelephoneNumber: Telephone, phoneNumber: phoneNumber, country: Country, city: City, typeID: typeID, companyDistrict: District, companyStreet: Street, companyZipCode: ZipCode, profileImageURL: url!, fcmToken: fcmToken, password: password) { (success) in
                        if success {
                                                        
                        }
                    }
//                        self.performSegue(withIdentifier: "toOwnerPage", sender: nil)
                        WindowManager.show(storyboard: .seller, animated: true)
                    hud.dismiss(afterDelay: 5.0, animated: true)
                }else {
                    hud.textLabel.text = "Error:\(error!.localizedDescription)"
            print("Error:\(error!.localizedDescription)")
                        hud.dismiss(afterDelay: 5.0, animated: true)
                }
            })
                
            }else {
                
            }
            
            
        }
                

            } else {
                 hud.textLabel.text = "Error:\(error!.localizedDescription)"
                           print("Error:\(error!.localizedDescription)")
                print("Error:\(error!.localizedDescription)")
                hud.dismiss(afterDelay: 5.0, animated: true)
            }
            let name = NSNotification.Name("updateFeed")
            NotificationCenter.default.post(name: name, object: nil)
        }
        
    }
    
    }
    
    
     // MARK:- Actions
    @IBAction func TypeSwitch(_ sender: Any) {

    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func uploadProfileImage(_ sender: Any) {
          self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        signupbtn.isEnabled = false
              
        guard let companyName = companyName.text else {return}
        guard let companyEmail = companyEmail.text else {return}

            if Reachability.isConnectedToNetwork(){
                
                let hud = JGProgressHUD(style: .dark)
                      hud.indicatorView = JGProgressHUDRingIndicatorView()
                      hud.textLabel.text = "Uploading"
                      hud.show(in: view)
                
              
                  if choosenLatitude == 0 && choosenLongtitude == 0 {
                      self.createAlert2(title: "Locate your company", message: "please locate your company by pressing the pin in the map")
                    hud.textLabel.text = "Failed !"
                    hud.dismiss(afterDelay: 3.0, animated: true)
                      signupbtn.isEnabled = true
                    
                      } else {
                        self.handleSignUp()
                      }
                    } else {
                      Loaf("Check Your network", state: .warning, sender: self).show()
                        signupbtn.isEnabled = true
            }

    }
    
    @IBAction func locateUrSelf(_ sender: Any) {
        let mapSpan = mapKit.region.span
            let region:MKCoordinateRegion = MKCoordinateRegion.init(center: userLocation.coordinate,span: mapSpan)
            self.mapKit.setRegion(region, animated: true)
    }
}
