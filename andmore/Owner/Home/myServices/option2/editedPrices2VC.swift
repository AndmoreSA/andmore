//
//  editedPrices2VC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 04/06/2021.
//

import UIKit
import Firebase
import JGProgressHUD

class editedPrices2VC: UITableViewController {

    // MARK:- Variables
     var segment1:String!
     var segment2:String!
     var venueName:String!
     var venueType:String!
     var venueID:String!
     var venueCountry:String = ""
     var venueCity:String = ""
     var VenueLat: Double = 0
     var VenueLong: Double = 0
    var selectedShop: ShopSearch?

    // MARK:- Outlets
  @IBOutlet weak var priceSelectionLabel: UISegmentedControl!
  @IBOutlet weak var disconetSegmentLabel: UISegmentedControl!
  @IBOutlet weak var chosenCurrency: UILabel!
  @IBOutlet weak var finalPrice: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
     self.priceSelectionLabel.isEnabled = false
     
        let serrs = UserDefaults()
        if let data6 = serrs.object(forKey: "venueTypesK") {
            if let message22 = data6 as? String {
                venueType = message22
            }
            
        }

             let userrw = UserDefaults()
             if let data7 = userrw.object(forKey: "venueNameess") {
             if let message3 = data7 as? String {
             venueName = message3
                 }
           
             }
        
        let serrse = UserDefaults()
        if let data6 = serrse.object(forKey: "venueID") {
            if let message22 = data6 as? String {
                venueID = message22
            }
            
        }
     
     
        hoursetUp()
//        defaultsSetUP()
        currecnysetup()
     getVenueLocations()
        self.hideKeyboardWhenTappedAround()

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
    }
        
    }
    
    // MARK:- properties
    
    func currecnysetup() {
        
            guard let uid = Auth.auth().currentUser?.uid else {return}
            var sum: Double = 0
            print(uid)
      let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot)
            
            let dictionary = snapshot.value as? NSDictionary
            
            let hour = dictionary?["CurrencyDay"] as? String
     
            self.chosenCurrency.text = hour
                
            })
        
    }
    
    
    // MARK:- Hour

    
    func hoursetUp() {
        
            guard let uid = Auth.auth().currentUser?.uid else {return}
      let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot)
            
            let dictionary = snapshot.value as? NSDictionary
            
            let hour = dictionary?["perHourPrice"] as? Double ?? 0
         let segment = dictionary?["PriceTypeSelection"] as? String ?? ""
         
         if segment == "Hour" {
             self.priceSelectionLabel.selectedSegmentIndex = 0
             self.priceSelectionLabel.isEnabled = false
         } else if segment == "Day" {
             self.priceSelectionLabel.selectedSegmentIndex = 1
             self.priceSelectionLabel.isEnabled = false
         }
         
         self.segment1 = segment
     
            self.finalPrice.text = "\(String(format: "%.02f", hour))"
                
            })
        
    }
    
    func hoursetup0() {
            guard let uid = Auth.auth().currentUser?.uid else {return}
            var sum: Double = 0
            print(uid)
      let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot)
            
            let dictionary = snapshot.value as? NSDictionary
            
            let hour = dictionary?["perHourPrice"] as? Double ?? 0
     
            self.finalPrice.text = "\(String(format: "%.02f", hour))"
                
            })
        
    }
    
    func hoursetup25() {
            guard let uid = Auth.auth().currentUser?.uid else {return}
            var sum: Double = 0
            print(uid)
      let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot)
            
            let dictionary = snapshot.value as? NSDictionary
            
            let hour = dictionary?["perHourPrice"] as? Double ?? 0
     
            self.finalPrice.text = "\(String(format: "%.02f", hour * 0.75))"
                
            })
        
    }
    
    func hoursetup50() {
            guard let uid = Auth.auth().currentUser?.uid else {return}
            var sum: Double = 0
            print(uid)
      let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot)
            
            let dictionary = snapshot.value as? NSDictionary
            
            let hour = dictionary?["perHourPrice"] as? Double ?? 0
     
            self.finalPrice.text = "\(String(format: "%.02f", hour * 0.50))"
                
            })
        
    }
    
    func hoursetup75() {
            guard let uid = Auth.auth().currentUser?.uid else {return}
            var sum: Double = 0
            print(uid)
      let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot)
            
            let dictionary = snapshot.value as? NSDictionary
            
            let hour = dictionary?["perHourPrice"] as? Double ?? 0
     
            self.finalPrice.text = "\(String(format: "%.02f", hour * 0.25))"
                
            })
        
    }
    
    func hoursetup100() {
             guard let uid = Auth.auth().currentUser?.uid else {return}
             var sum: Double = 0
             print(uid)
      let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueID)
         
         ref.observeSingleEvent(of: .value, with: { (snapshot) in
         print(snapshot)
             
             let dictionary = snapshot.value as? NSDictionary
             
             let hour = dictionary?["perHourPrice"] as? Double ?? 0
      
             self.finalPrice.text = "\(String(format: "%.02f", hour * 0.0))"
                 
             })
         
     }
    
    
    // MARK:- Day
    
    func daySetup() {
        
            guard let uid = Auth.auth().currentUser?.uid else {return}
            var sum: Double = 0
            print(uid)
      let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot)
            
            let dictionary = snapshot.value as? NSDictionary
            
            let hour = dictionary?["perDayPrice"] as? Double ?? 0
     
            self.finalPrice.text = "\(String(format: "%.02f", hour))"
                
            })
        
    }
    
    func daySetup0() {
        
            guard let uid = Auth.auth().currentUser?.uid else {return}
            var sum: Double = 0
            print(uid)
      let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot)
            
            let dictionary = snapshot.value as? NSDictionary
            
            let hour = dictionary?["perDayPrice"] as? Double ?? 0
     
            self.finalPrice.text = "\(String(format: "%.02f", hour))"
                
            })
        
    }
    
    func daySetup25() {
        
            guard let uid = Auth.auth().currentUser?.uid else {return}
            var sum: Double = 0
            print(uid)
      let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot)
            
            let dictionary = snapshot.value as? NSDictionary
            
            let hour = dictionary?["perDayPrice"] as? Double ?? 0
     
            self.finalPrice.text = "\(String(format: "%.02f", hour  * 0.75))"
                
            })
        
    }
    
    func daySetup50() {
        
            guard let uid = Auth.auth().currentUser?.uid else {return}
            var sum: Double = 0
            print(uid)
      let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot)
            
            let dictionary = snapshot.value as? NSDictionary
            
            let hour = dictionary?["perDayPrice"] as? Double ?? 0
     
            self.finalPrice.text = "\(String(format: "%.02f", hour  * 0.50))"
                
            })
        
    }
    
    func daySetup75() {
        
            guard let uid = Auth.auth().currentUser?.uid else {return}
            var sum: Double = 0
            print(uid)
      let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot)
            
            let dictionary = snapshot.value as? NSDictionary
            
            let hour = dictionary?["perDayPrice"] as? Double ?? 0
     
            self.finalPrice.text = "\(String(format: "%.02f", hour  * 0.25))"
                
            })
        
    }
    
    func daySetup100() {
        
            guard let uid = Auth.auth().currentUser?.uid else {return}
            var sum: Double = 0
      let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot)
            
            let dictionary = snapshot.value as? NSDictionary
            
            let hour = dictionary?["perDayPrice"] as? Double ?? 0
     
            self.finalPrice.text = "\(String(format: "%.02f", hour  * 0.0))"
                
            })
        
    }
    
    
    // MARK:- Month

    
    func monthSetup() {
        
            guard let uid = Auth.auth().currentUser?.uid else {return}
            var sum: Double = 0
            print(uid)
      let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot)
            
            let dictionary = snapshot.value as? NSDictionary
            
            let hour = dictionary?["perMonthPrice"] as? Double ?? 0
     
            self.finalPrice.text = "\(String(format: "%.02f", hour))"
                
            })
        
    }
    
    func monthSetup0() {
        
            guard let uid = Auth.auth().currentUser?.uid else {return}
            var sum: Double = 0
            print(uid)
      let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot)
            
            let dictionary = snapshot.value as? NSDictionary
            
            let hour = dictionary?["perMonthPrice"] as? Double ?? 0
     
            self.finalPrice.text = "\(String(format: "%.02f", hour))"
                
            })
        
    }
    
    func monthSetup25() {
        
            guard let uid = Auth.auth().currentUser?.uid else {return}
            var sum: Double = 0
            print(uid)
      let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot)
            
            let dictionary = snapshot.value as? NSDictionary
            
            let hour = dictionary?["perMonthPrice"] as? Double ?? 0
     
            self.finalPrice.text = "\(String(format: "%.02f", hour * 0.75))"
                
            })
        
    }
    
    func monthSetup50() {
        
            guard let uid = Auth.auth().currentUser?.uid else {return}
            var sum: Double = 0
            print(uid)
      let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot)
            
            let dictionary = snapshot.value as? NSDictionary
            
            let hour = dictionary?["perMonthPrice"] as? Double ?? 0
     
            self.finalPrice.text = "\(String(format: "%.02f", hour * 0.50))"
                
            })
        
    }
    
    func monthSetup75() {
        
            guard let uid = Auth.auth().currentUser?.uid else {return}
            var sum: Double = 0
            print(uid)
      let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot)
            
            let dictionary = snapshot.value as? NSDictionary
            
            let hour = dictionary?["perMonthPrice"] as? Double ?? 0
     
            self.finalPrice.text = "\(String(format: "%.02f", hour * 0.25))"
                
            })
        
    }
    
    func monthSetup100() {
        
            guard let uid = Auth.auth().currentUser?.uid else {return}
            var sum: Double = 0
            print(uid)
      let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueID)
      
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot)
            
            let dictionary = snapshot.value as? NSDictionary
            
            let hour = dictionary?["perMonthPrice"] as? Double ?? 0
     
            self.finalPrice.text = "\(String(format: "%.02f", hour * 0.0))"
                
            })
        
    }
    
    
    
    
    // MARK:- Actions
       
       @IBAction func priceSelectionPressed(_ sender: Any) {
           
           self.segment1 = priceSelectionLabel.titleForSegment(at: priceSelectionLabel.selectedSegmentIndex)
        
        if segment1 == "Hour" && segment2 == nil {
            hoursetup0()
        } else if segment1 == "Day" && segment2 == nil {
            daySetup0()
        } else if segment1 == "Month" && segment2 == nil {
            monthSetup0()
        } else
    if segment1 == "Hour" && segment2 == "0%" {
              hoursetup0()
           } else if segment1 == "Hour" && segment2 == "25%" {
               hoursetup25()
           } else if segment1 == "Hour" && segment2 == "50%" {
               hoursetup50()
           } else if segment1 == "Hour" && segment2 == "75%" {
               hoursetup75()
           } else if segment1 == "Hour" && segment2 == "100%" {
               hoursetup100()
           }  else if segment1 == "Day" && segment2 == "0%" {
               daySetup0()
           }  else if segment1 == "Day" && segment2 == "25%" {
               daySetup25()
           } else if segment1 == "Day" && segment2 == "50%" {
               daySetup50()
           }  else if segment1 == "Day" && segment2 == "75%" {
               daySetup75()
           }  else if segment1 == "Day" && segment2 == "100%" {
               daySetup100()
           }  else if segment1 == "Month" && segment2 == "0%" {
               monthSetup0()
           } else if segment1 == "Month" && segment2 == "25%" {
               monthSetup25()
           } else if segment1 == "Month" && segment2 == "50%" {
               monthSetup50()
           } else if segment1 == "Month" && segment2 == "75%" {
               monthSetup75()
           } else if segment1 == "Month" && segment2 == "100%" {
               monthSetup100()
           }
    
       }
       
       @IBAction func disconetPressed(_ sender: Any) {
          
           self.segment2 = disconetSegmentLabel.titleForSegment(at: disconetSegmentLabel.selectedSegmentIndex)
        
        if segment1 == "Hour" && segment2 == "0%" {
           hoursetup0()
        } else if segment1 == "Hour" && segment2 == "25%" {
            hoursetup25()
        } else if segment1 == "Hour" && segment2 == "50%" {
            hoursetup50()
        } else if segment1 == "Hour" && segment2 == "75%" {
            hoursetup75()
        } else if segment1 == "Hour" && segment2 == "100%" {
            hoursetup100()
        }  else if segment1 == "Day" && segment2 == "0%" {
            daySetup0()
        }  else if segment1 == "Day" && segment2 == "25%" {
            daySetup25()
        } else if segment1 == "Day" && segment2 == "50%" {
            daySetup50()
        }  else if segment1 == "Day" && segment2 == "75%" {
            daySetup75()
        }  else if segment1 == "Day" && segment2 == "100%" {
            daySetup100()
        }  else if segment1 == "Month" && segment2 == "0%" {
            monthSetup0()
        } else if segment1 == "Month" && segment2 == "25%" {
            monthSetup25()
        } else if segment1 == "Month" && segment2 == "50%" {
            monthSetup50()
        } else if segment1 == "Month" && segment2 == "75%" {
            monthSetup75()
        } else if segment1 == "Month" && segment2 == "100%" {
            monthSetup100()
        }
        
        else if segment2 == "0%" && segment1 == "Hour" {
            hoursetup0()
        } else if segment2 == "25&" && segment1 == "Hour" {
            hoursetup25()
        } else if segment2 == "50&" && segment1 == "Hour" {
            hoursetup50()
        } else if segment2 == "75&" && segment1 == "Hour" {
            hoursetup75()
        } else if segment2 == "100&" && segment1 == "Hour" {
            hoursetup100()
        }
        
        else if segment2 == "0%" && segment1 == "Day" {
                  daySetup0()
              } else if segment2 == "25&" && segment1 == "Day" {
                  daySetup25()
              } else if segment2 == "50&" && segment1 == "Day" {
                daySetup50()
              } else if segment2 == "75&" && segment1 == "Day" {
                  daySetup75()
              } else if segment2 == "100&" && segment1 == "Day" {
                  daySetup100()
              }
        
        else if segment2 == "0%" && segment1 == "Month" {
                      monthSetup0()
                  } else if segment2 == "25&" && segment1 == "Month" {
                      monthSetup25()
                  } else if segment2 == "50&" && segment1 == "Month" {
                      monthSetup50()
                  } else if segment2 == "75&" && segment1 == "Month" {
                      monthSetup75()
                  } else if segment2 == "100&" && segment1 == "Month" {
                      monthSetup100()
                  }
        
        
       }
       

    
    // MARK:- Actions
    
    @IBAction func submitPressed(_ sender: Any) {
        
        let hud = JGProgressHUD(style: .dark)
        hud.indicatorView = JGProgressHUDRingIndicatorView()
        hud.textLabel.text = "Uploading"
        hud.show(in: view)
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let choosenPrice = finalPrice.text else {return}
        guard let choosenCurrency = chosenCurrency.text else {return}
        

        var urTypepriceSelcetion:String
        if (self.segment1==nil) {
            urTypepriceSelcetion = "Hour"
        } else {
            urTypepriceSelcetion = self.segment1
        }
        
        var urTypeDiscount:String
        if (self.segment2==nil) {
            urTypeDiscount = "0%"
        } else {
            urTypeDiscount = self.segment2
        }
        
        
      let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueID)
     
     
             let ref3 = Database.database().reference().child("Services").child(self.venueCountry).child(self.venueCity).child(venueType).child(venueID)
        
        let venueDetails = [
        
            "PriceTypeSelection": urTypepriceSelcetion,
            "PriceTypeDiscount": urTypeDiscount,
            "FinalPrice": Double(choosenPrice),
            "FinalCurrency": choosenCurrency
            
        ] as [String:Any]
            
        
        ref.updateChildValues(venueDetails)
     ref3.updateChildValues(venueDetails)
        
        hud.textLabel.text = "Success !"
        hud.dismiss(afterDelay: 5.0, animated: true)
               
        WindowManager.show(storyboard: .seller, animated: true)
        
    }
    

}
