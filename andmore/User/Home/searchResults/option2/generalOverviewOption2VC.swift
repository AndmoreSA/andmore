//
//  generalOverviewOption2VC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 08/06/2021.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseDatabase

class generalOverviewOption2VC: UITableViewController,UICollectionViewDelegate, UICollectionViewDataSource,  MKMapViewDelegate , CLLocationManagerDelegate{


    // MARK:- outlets
     @IBOutlet weak var availablilityCollectionView: UICollectionView!
     @IBOutlet weak var noOFpeopless: UILabel!
     @IBOutlet weak var venueName: UILabel!
     @IBOutlet weak var venueDisct: UITextView!
     @IBOutlet weak var venueMap: MKMapView!

     
      //MARK:- vairables
    var imagesArray = [String]()
    var TimeSlotList = Array<TimeSlot>()
    var TimeSlotList3 = Array<String>()
    var timeString = [String]()
    var arrSelectedIndex = [IndexPath]() // This is selected cell Index array
    var arrSelectedData = [String]()
    var currentIndex = 0
    var images = [ShopSearch]()
    var timer: Timer?
    var Timestring:String = ""
    var Timestring2:String = ""
    var Timestring3:String = ""
    var name:String = ""
    var country:String = "Saudi Arabia"
    var city:String = ""
    var price:String = ""
    var currency:String = ""
    var checkIn:String = ""
    var venueUID:String = ""
    var deletetime:String = ""
    var uniqueID:String = ""
    var time11:String = ""
    var time22:String = ""
    var time33:String = ""
    var skills:String = ""
    var userGender:String = ""
    var venueGender1:String = ""
    var time44:String = ""
    var time55:String = ""
    var time66:String = ""

    var time77:String = ""
    var time88:String = ""
    var time99:String = ""
    var choosenLatitude: Double = 0
    var choosenLongtitude: Double = 0
    var userlat = 0.0
    var userlong = 0.0
    var venueID:String = ""
    var locationManager = CLLocationManager()

    var type:String = ""
  var venues = [venueSearch]()
         var selectedShop: venueSearch! {
             didSet {
                 
                 if selectedShop.venueName != nil {
                     name = selectedShop.venueName
                 }
                 
                  if selectedShop.venueType != nil {
                     type = selectedShop.venueType
                 }
                
                if selectedShop.uid != nil {
                       venueUID = selectedShop.uid
                   }
                 
                 if selectedShop?.venueImage1 != nil {
                     self.imagesArray.append(selectedShop.venueImage1!)
                 }
                 if selectedShop?.venueImage2 != nil {
                     self.imagesArray.append(selectedShop.venueImage2!)
               }
                 if selectedShop?.venueImage3 != nil {
                     self.imagesArray.append(selectedShop.venueImage3!)
                 }
                 
             }
         }


         override func viewDidLoad() {
             super.viewDidLoad()
            
             self.hideKeyboardWhenTappedAround()
                       
               venueDisct.isEditable = false
               venueMap.showsCompass = true
               venueMap.isRotateEnabled = false
               venueMap.delegate = self
               locationManager.delegate = self
               locationManager.desiredAccuracy = kCLLocationAccuracyBest
               locationManager.requestWhenInUseAuthorization()
             retreivingInfo()
      
          tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
            
                    let namse = UserDefaults()
                    if let data33 = namse.object(forKey: "city1") {
                        if let message2 = data33 as? String {
                            city = message2
                            print(message2)

                        }
                    }
            
            if let data33 = namse.object(forKey: "service2") {
                  if let message2 = data33 as? String {
                      price = message2
                      print(message2)

                  }
              }
            
            if let data33 = namse.object(forKey: "date1") {
                  if let message2 = data33 as? String {
                      checkIn = message2
                      print(message2)

                  }
              }
            venueShow()
            RetrieveLocation()
            
             let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardd))
             tap.cancelsTouchesInView = false
             view.addGestureRecognizer(tap)
            
          }


         
         @objc func keyboardd() {
             
         }
   
         // MARK:- CollectionViews
         
         func numberOfSections(in collectionView: UICollectionView) -> Int {
                return 1
            }
            
            func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

                    if price == "Hour" {
                        return TimeSlotList.count
                    } else {
                        return timeString.count
                    }
            }
            
            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

                    let cell2 = availablilityCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! availabilityOverview2Cell
                    
                    let strDate = TimeSlotList[indexPath.row].time

                    
                    if arrSelectedIndex.contains(indexPath) { // You need to check wether selected index array contain current index if yes then change the color
                        
                        cell2.contentView.backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
                        cell2.selectButton.backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
                        cell2.timeLabel.textColor = .white
                        cell2.selectButton.setTitleColor(.white, for: .normal)
                        cell2.selectButton.setTitle("selected", for: .normal)
                    }
                    else {
                        cell2.selectButton.backgroundColor = UIColor.white
                        cell2.timeLabel.textColor = .black
                        cell2.contentView.backgroundColor = UIColor.white
                        cell2.selectButton.setTitleColor(.black, for: .normal)
                        cell2.selectButton.setTitle("select", for: .normal)
                    }
                    

                
                    
                    if price == "Hour" {
                    cell2.timeLabel.text = TimeSlotList[indexPath.row].time
                    } else {
                    cell2.timeLabel.text = timeString[indexPath.row]
                    }

                        return cell2
            }
         

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    if collectionView == availablilityCollectionView {
        print("You selected cell #\(indexPath.item)!")
        
        if price == "Hour" {
            
            let strData = TimeSlotList[indexPath.row].time
//                let strData = TimeSlotList3[indexPath.row]

            if arrSelectedIndex.contains(indexPath) {
                arrSelectedIndex = arrSelectedIndex.filter { $0 != indexPath}
                arrSelectedData = arrSelectedData.filter { $0 != strData}
            }
            else {
                arrSelectedIndex.append(indexPath)
                arrSelectedData.append(strData)
                print(strData)
                
            }
        } else {
            let strData = timeString[indexPath.row]
            
            if arrSelectedIndex.contains(indexPath) {
                arrSelectedIndex = arrSelectedIndex.filter { $0 != indexPath}
                arrSelectedData = arrSelectedData.filter { $0 != strData}
            } else {
                arrSelectedIndex.append(indexPath)
                    arrSelectedData.append(strData)
                    print(strData)
            }

        }

    } else {
        
    }
    
    availablilityCollectionView.reloadData()
}
         
         
         
         // MARK:- Properties

         
         
         func retreivingInfo() {
            
            
                if let VenueNdi = selectedShop?.discription {
                venueDisct.text = VenueNdi
                
            } else {
                venueDisct.isHidden = true
            }
             
                                
             if let VenueNames = selectedShop?.venueName {
             venueName.text = VenueNames
             
         } else {
             venueName.isHidden = true
         }
            
            if let venueIDz = selectedShop?.venueID {
                venueID = venueIDz
            }
            
            if let currency1 = selectedShop?.currencyHour {
                
                if currency1 == "" {
                    currency = "SAR"
                } else {
                    currency = currency1
                }
            }
  
             if let pepole = selectedShop?.noOFPEOPLE {
                        noOFpeopless.text = pepole
                    } else {
                        noOFpeopless.isHidden = true
            }
         }


     
         // MARK:- Table view source data

        func venueShow() {
            
            if price == "Hour" {
                
                
                self.TimeSlotList.removeAll()
                let ref = Database.database().reference().child("Services").child(country).child(city).child(type).child(venueID).child("mySchedule").child(price)

                   ref.observe(.value) { (snapshot) in
                   print(snapshot)
                    
                    if let snaps = snapshot.value as? [String:Any] {
                        for each in snaps {
                            let uid = each.key
                            self.deletetime = each.key
                            print(uid)
                            self.getAllTimeSlots(stringz:uid)
                        }
                    }
                }
                
            } else {
                
                // DAY
                let ref = Database.database().reference().child("Services").child(country).child(city).child(type).child(venueID).child("mySchedule").child(price)

                   ref.observe(.value) { (snapshot) in
                   print(snapshot)
                    
                    if let snaps = snapshot.value as? [String:Any] {
                        for each in snaps {
                            let uid6 = each.key
                            self.deletetime = each.key
                            print(uid6)
                            self.getAllTimeSlots2(stringz:uid6)
                        }
                    }
                }
            }

        }



func getAllTimeSlots(stringz:String){
    self.TimeSlotList.removeAll()
    Database.database().reference().child("Services").child(country).child(city).child(type).child(venueID).child("mySchedule").child(price).child(stringz).child("dates").child(checkIn).observeSingleEvent(of: .value, with: { (snapShot) in

    if let snapDict = snapShot.value as? [String:AnyObject]{
                for each in snapDict{
                    let timeSlot = TimeSlot()
                    timeSlot.time = each.key
                        self.TimeSlotList.append(timeSlot)
                        self.TimeSlotList.sort { $0.time.compare($1.time, options: .numeric) == .orderedAscending
                    }
                }
                self.availablilityCollectionView.reloadData()
            }
        })
    }

func getAllTimeSlots2(stringz:String){
    
    self.TimeSlotList.removeAll()

        
Database.database().reference().child("Services").child(country).child(city).child(type).child(venueID).child("mySchedule").child(price).child(stringz).child("dates").observeSingleEvent(of: .value, with: { (snapShot) in

print(snapShot)
        
        if let snapDict = snapShot.value as? [String:AnyObject]{
            for each in snapDict{
                
                if self.checkIn == each.key {
                    self.timeString.append(self.checkIn)
                    }
                    self.availablilityCollectionView.reloadData()
                }
        }
    })
                                            
}

  func RetrieveLocation() {
    
    print(country)
    print(city)
    print(type)
    print(name)
      
      let ref = Database.database().reference().child("Services").child(country).child(city).child(type).child(venueID).observeSingleEvent(of: .value, with: { (snapshot) in
          print(snapshot)
          if snapshot.exists() {
              let allAnnotations = self.venueMap.annotations
              for ann in allAnnotations {
                  self.venueMap.removeAnnotation(ann)
              }
          }
          guard let dictionary = snapshot.value as? [String:Any] else {return}
          guard let latitude = dictionary["lat"] as? Double else {return}
          guard let longtitude = dictionary["long"] as? Double else {return}
          print("lat:\(latitude), log:\(longtitude)")
          
          
          let annotation = MKPointAnnotation()
          let userLat = CLLocationDegrees(latitude)
          let userLon = CLLocationDegrees(longtitude)
          annotation.coordinate = CLLocationCoordinate2D(latitude: userLat, longitude: userLon)
          let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)

               let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
               self.venueMap.setRegion(region, animated: true)
          self.venueMap.addAnnotation(annotation)
          
      })
      
      print("There was an error getting posts")
  }

func proceed() {
    
    if Reachability.isConnectedToNetwork(){
            
            print(arrSelectedData)
            print(checkIn)
        
        guard let uiuu = selectedShop?.uid else {return}
        print(uiuu)
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            let ref = Database.database().reference().child("users").child("profile").child(uid).child("myAppointments").child(checkIn).child(venueID).childByAutoId()
            

            
            let newID = ref.key
            
            uniqueID = newID!
                        
            let userDefaults = UserDefaults()
                userDefaults.set(uniqueID, forKey: "idz")
        userDefaults.set(currency, forKey: "currency")
        
            
            
            for i in 0..<arrSelectedData.count {

                let time = arrSelectedData[i]

                let values = [
                    "time\(i + 1)": time
                ] as [String:Any]

                let userDefaults = UserDefaults()
                       userDefaults.set(arrSelectedData, forKey: "times")



                Database.database().reference().child("TimeBooked").child(venueUID).child(name).child(checkIn).child(uid).updateChildValues(values)

            }
            
              performSegue(withIdentifier: "toSummary2", sender: selectedShop)
       
    } else {
        self.createAlert2(title: "check your network", message: "")
    }
}
                     
         // MARK:- Actions
        @IBAction func submitButtonPressed(_ sender: Any) {
    
            if arrSelectedData == [] {
                self.createAlert2(title: "Missing Input", message: "Please select")
            } else {
                proceed()
            }
        }
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "toSummary2" {
             if let selectedPhone = sender as? venueSearch,
                 let destinationVC = segue.destination as? bookingSummaryOption2VC {
                 destinationVC.selectedShop = selectedPhone
             }
         }
     }
  
  @IBAction func backArrowPressed(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
  }
  


}


