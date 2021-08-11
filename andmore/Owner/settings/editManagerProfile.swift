//
//  editManagerProfile.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 05/06/2021.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField
import JGProgressHUD

class editManagerProfile: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    
    
    //outlets
    @IBOutlet weak var companyImage1: UIImageView!
    @IBOutlet weak var companyName: SkyFloatingLabelTextField!
    @IBOutlet weak var companyEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var companyTelephone: SkyFloatingLabelTextField!
    @IBOutlet weak var companyphoneNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var country: SkyFloatingLabelTextField!
    @IBOutlet weak var conpanyCity: SkyFloatingLabelTextField!
    @IBOutlet weak var companyDistrict: SkyFloatingLabelTextField!
    @IBOutlet weak var companyStreet: SkyFloatingLabelTextField!
    @IBOutlet weak var companyZipCode: SkyFloatingLabelTextField!
    
    
    // MARK:- Variables
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    var pickedImageProduct = UIImage()
    var type:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveUserName()
        
        databaseRef = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        self.hideKeyboardWhenTappedAround()

        self.companyName.isEnabled = false
        self.country.isEnabled = false
        self.conpanyCity.isEnabled = false
        self.companyEmail.isEnabled = false
        
    }
    
    
     // MARK:- Properties
        
        func retrieveUserName() {
               if let userID = Auth.auth().currentUser?.uid {
                   Database.database().reference().child("All").child(userID).observe(.value) { (snapshot) in
                       let dict = snapshot.value as? NSDictionary
                       let username = dict?["fullName"] as? String
                       let email = dict?["email"] as? String
                       let phoneNumber = dict?["phoneNumber"] as? String
                       let tele = dict?["telephoneNumber"] as? String
                    let country = dict?["country"] as? String
                    let city = dict?["city"] as? String
                    let district = dict?["district"] as? String
                    let street = dict?["street"] as? String
                    let zipcode = dict?["zipCode"] as? String
                    self.type = (dict?["businessType"]  as? String)!

                       self.companyEmail.text = email
                       self.companyName.text = username
                       self.companyTelephone.text = tele
                       self.companyphoneNumber.text = phoneNumber
                       self.country.text = country
                    self.conpanyCity.text = city
                    self.companyDistrict.text = district
                    self.companyStreet.text = street
                    self.companyZipCode.text = zipcode

                    
                    
                       if let profileImageURL = dict?["profileImageURL"] as? String {
                           self.companyImage1.sd_setImage(with: URL(string: profileImageURL))
                       }
                   }
               }
               print("couldn't find the user name")
           }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
      
        
        func upateUserProfile() {
            
            let hud = JGProgressHUD(style: .dark)
                   hud.indicatorView = JGProgressHUDRingIndicatorView()
                   hud.textLabel.text = "Uploading"
                   hud.show(in: view)
            
            
                if let userID = Auth.auth().currentUser?.uid {
                    let storageItem = storageRef.child("stores").child(userID)
                    guard let image = companyImage1.image else {return}
                    if let newImage = image.jpegData(compressionQuality: 0.75){
                        storageItem.putData(newImage, metadata: nil) { (metadata, error) in
                            if error != nil {
                                print(error!)
                                return
                            }
                            storageItem.downloadURL(completion: { (url, error) in
                                if error != nil {
                                    print(error!)
                                    return
                                }
                    if let profilePhotoURL = url?.absoluteString{
                    guard let name = self.companyName.text else {return}
                    guard let email = self.companyEmail.text else {return}
                    guard let tele = self.companyTelephone.text else {return}
                    guard let phone = self.companyphoneNumber.text else {return}
                        guard let country = self.country.text else {return}
                        guard let city = self.conpanyCity.text else {return}
                        guard let district = self.companyDistrict.text else {return}
                        guard let street = self.companyStreet.text else {return}
                        guard let zipcode = self.companyZipCode.text else {return}
                

                                    
                                    
                                    let newValuesForProfile =
                                        [
                                            "fullName":name,
                                            "email":email,
                                            "phoneNumber":phone,
                                            "telephoneNumber":tele,
                                            "country":country,
                                            "city":city,
                                            "district":district,
                                            "street":street,
                                            "zipCode":zipcode
                                            
                                            ] as [String:Any]
                        self.databaseRef.child("stores/Allbuisness/\(self.type)/\(userID)").updateChildValues(newValuesForProfile, withCompletionBlock: { (error, ref) in
                                        if error != nil {
                                            print(error!)
                                            hud.textLabel.text = error?.localizedDescription
                                            hud.dismiss(afterDelay: 5.0, animated: true)
                                            return
                                        }
                                        hud.textLabel.text = "Success !"
                                        hud.dismiss(afterDelay: 5.0, animated: true)
                                        print("profile Successfully Updated")
                                    })
                                    
                                    self.databaseRef.child("All").child(userID).updateChildValues(newValuesForProfile, withCompletionBlock: { (error, ref) in
                                        if error != nil {
                                            print(error!)
                                            return
                                        }
                                        print("profile Successfully Updated")
                                    })
                                }
                            })
                        }
                        
                    }
                    
                    self.dismiss(animated: true, completion: nil)
            }
            
        }
    
    @IBAction func changeImage(_ sender: Any) {
        let picker = UIImagePickerController()
              picker.delegate = self
              picker.allowsEditing = false
              picker.sourceType = .photoLibrary
              picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
              present(picker, animated: true, completion: nil)
    }
    
   
    @IBAction func updateBtnPressed(_ sender: Any) {
        upateUserProfile()
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        WindowManager.show(storyboard: .seller, animated: true)
    }
    
    
}
