//
//  firstOpetion1VC1.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 02/06/2021.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField
import JGProgressHUD

class firstOpetion1VC1: UITableViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var serviceName: SkyFloatingLabelTextField!
    @IBOutlet weak var serviceDescriptionText: UITextView!
    @IBOutlet weak var textCount: UILabel!
    @IBOutlet weak var moofPeople: SkyFloatingLabelTextField!

    var CountryString: String = "NULL"
    var CityString: String = "NULL"
    var companyName:String = "NULL"
    var businesstype:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getVenueCountry()
        serviceDescriptionText.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = serviceDescriptionText.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else {return false}
        
        let updateText = currentText.replacingCharacters(in: stringRange, with: text)
        
        textCount.text = "\(300 - updateText.count)"
        
        return updateText.count < 300
    }
    
    func getVenueCountry() {
        
         guard let uid = Auth.auth().currentUser?.uid else {return}
         let ref = Database.database().reference().child("All").child(uid)
        
            
            ref.observeSingleEvent(of: .value) { (snapshot) in
             print(snapshot)

             let dictionaries = snapshot.value as? NSDictionary

             self.CountryString = dictionaries?["country"] as! String
             self.CityString = dictionaries?["city"] as! String
             self.companyName = dictionaries?["fullName"] as! String
            self.businesstype = dictionaries?["businessType"] as! String

             print(self.CountryString)
        
        }
    }
    
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
    if(!serviceName.text!.trimmingCharacters(in: .whitespaces).isEmpty) {
        
        if Reachability.isConnectedToNetwork(){
        
        let hud = JGProgressHUD(style: .dark)
              hud.indicatorView = JGProgressHUDRingIndicatorView()
              hud.textLabel.text = "Uploading"
              hud.show(in: view)
              
              guard let uid = Auth.auth().currentUser?.uid else {return}
              guard let venueNamme = serviceName.text else {return}
              guard let venuediscrip = serviceDescriptionText.text else {return}
            guard let NoPeople = moofPeople.text else {return}
                          
            let ref = Database.database().reference().child("stores").child("Allbuisness").child(businesstype).child(uid).child("Services").childByAutoId()
            
            guard let postId = ref.key else {return}

          
              let ref2 =
                  Database.database().reference().child("Services").child(CountryString).child(CityString).child(businesstype).child(postId)
              

              
              let userDefaults = UserDefaults()
              userDefaults.set(businesstype, forKey: "typeess")
            userDefaults.set(postId, forKey: "postID")
              userDefaults.set(venueNamme, forKey: "names")
              
              
              let venueDetails = [
              
                  "VenueName": venueNamme,
                  "VenueId":postId,
                  "venueType": businesstype,
                  "fullName":companyName,
                  "city":CityString,
                  "country":CountryString,
                "NumberofPeople":NoPeople,
                  "VenueDiscription":venuediscrip
              ] as [String:Any]
              
              let venueDe = [
                  "VenueName": venueNamme,
                  "VenueId":postId,
                  "venueType": businesstype,
                  "fullName":companyName,
                "NumberofPeople":NoPeople
              ] as [String:Any]
              
              
              if serviceName.text == "" {
                         
                         self.createAlert(title: "Failed", message: "please fill the required infomration")
                         
                         
                     } else {
              
              
              ref.updateChildValues(venueDetails)
              ref2.updateChildValues(venueDetails)
              
              }
              
              hud.textLabel.text = "Success !"
              hud.dismiss(afterDelay: 5.0, animated: true)
              
              self.performSegue(withIdentifier: "toNext", sender: nil)
       
   
            
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

}
