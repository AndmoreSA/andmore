//
//  homeUserVC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 05/06/2021.
//

import UIKit
import Firebase

class homeUserVC: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource{

    
    
    //MARK:-OUTLETS
    @IBOutlet weak var greetingstext: UILabel!
    @IBOutlet weak var userNametxt: UILabel!
    @IBOutlet weak var servicesCollectionView: UICollectionView!
    
    
    //MARK:-VARIABLES
    var servicesNames = ["Men Salons","Women Salons","Home Salons","Wedding Halls","Photography shop","Event Orgnizor","Chalets"]
    
    var serviceImages = ["1","2","3","4","5","6","7"]
    
    
    var greeting:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        greetingLogic()
        welcoming()
    }
    
    
    //MARK:- Properties
    func greetingLogic() {
        
        let date = NSDate()
        let calendar = NSCalendar.current
        let currentHour = calendar.component(.hour, from: date as Date)
        let hourInt = Int(currentHour.description)!

        if hourInt >= 12 && hourInt <= 16 {
            
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                greeting = "مساء الخير"
            } else {
                greeting = "Good Afternoon"
            }
        }
        else if hourInt >= 7 && hourInt <= 12 {
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                greeting = "صباح الخير"
            } else {
                greeting = "Good Morning"
            }
        }
        else if hourInt >= 16 && hourInt <= 20 {
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                greeting = "مساء الخير"
            } else {
                greeting = "Good Evening"
            }
        }
        else if hourInt >= 20 && hourInt <= 24 {
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                greeting = "مساء الخير"
            } else {
                greeting = "Good Evening"
            }
        }
        else if hourInt >= 0 && hourInt <= 7 {
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                greeting = "صباح الخير"
            } else {
                greeting = "Good Morning"
            }
        }
        greetingstext.text = greeting
    }
    
    func welcoming() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        print(uid)
        Database.database().reference().child("users").child("profile").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let dict = snapshot.value as? NSDictionary
            self.userNametxt.text = dict?["fullName"] as? String ?? ""
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return servicesNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = servicesCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! homeUserCell
        
        cell.serviceNameTxt.text = servicesNames[indexPath.row]
        cell.img.image = UIImage(named: serviceImages[indexPath.item])
        
        return cell
    }
    
    
    //MARK:-Actions
    

}
