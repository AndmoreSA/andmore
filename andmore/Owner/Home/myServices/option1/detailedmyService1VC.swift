//
//  detailedmyService1VC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 02/06/2021.
//

import UIKit
import MapKit
import Firebase

class detailedmyService1VC: UITableViewController,UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout, MKMapViewDelegate, CLLocationManagerDelegate{

    // MARK:- outlets
    @IBOutlet weak var venueMap: MKMapView!
    @IBOutlet weak var noOFpeopless: UILabel!
    @IBOutlet weak var imageSliderView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var venueDisc: UITextView!
    
    
    
    
    
         //MARK:- vairables
        var imagesArray = [String]()
        var currentIndex = 0
        var images = [ShopSearch]()
        var timer: Timer?
        var name:String = ""
        var type:String = ""
        var city:String = ""
        var country:String = ""
        var venueID:String = ""
        var locationManager = CLLocationManager()
        var choosenLatitude: Double = 0
        var choosenLongtitude: Double = 0
        var userlat = 0.0
        var userlong = 0.0
        var selectedShop: ShopSearch! {
            
            didSet {
                
            if selectedShop.venueName != nil {
                name = selectedShop.venueName
            }
             if selectedShop.venueType != nil {
                type = selectedShop.venueType
            }
            
             if selectedShop.venueID != nil {
                venueID = selectedShop.venueType
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
            
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            } else {
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            }
            
            self.navigationController?.isNavigationBarHidden = false
            self.hideKeyboardWhenTappedAround()
            
            venueDisc.isEditable = false
            venueMap.showsCompass = true
            venueMap.isRotateEnabled = false
            venueMap.delegate = self
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
//            locationManager.startUpdatingLocation()
            title = selectedShop?.venueName
            pageControl.numberOfPages = imagesArray.count
            startTimer()
            retreivingInfo()
            RetrieveLocation()
            
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardd))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
    
    @objc func keyboardd() {
        
    }

    func RetrieveLocation() {
        
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
        

        
        // MARK:- CollectionViews
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
               return 1
           }
           
           func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
               return imagesArray.count
           }
           
           func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
               let cell = imageSliderView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! servicesImageSliderCell
               let images = imagesArray[indexPath.item]
               cell.image = images
               print(images)
               return cell
           }
        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
            currentIndex = Int(scrollView.contentOffset.x / imageSliderView.frame.size.width)
            
            pageControl.currentPage = currentIndex
        }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1.0 : 32
    }
        
        
        // MARK:- Properties
        
        func startTimer() {
            
            timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            
        }
        
        @objc func timerAction() {
            let desitedScrollPosition = (currentIndex < imagesArray.count - 1) ? currentIndex + 1 : 0
            imageSliderView.scrollToItem(at: IndexPath(item: desitedScrollPosition, section: 0), at: .centeredHorizontally, animated: true)
        }
        
        
        func retreivingInfo() {
            
                  
        
        
            if let VenueNames = selectedShop?.venueName {
            venueName.text = VenueNames
                venueName.text = name
        } else {
            venueName.isHidden = true
        }
            
                if let venueIDz = selectedShop?.venueID {
                    venueID = venueIDz
            } else {
//                venueName.isHidden = true
            }
            
                if let VenueNdi = selectedShop?.discription {
                venueDisc.text = VenueNdi
                
            } else {
                venueDisc.isHidden = true
            }
            
                if let countryc = selectedShop?.country {
                city = countryc
            } else {
            }
            
                if let cit = selectedShop?.city {
                country = cit
            } else {
            }
            
                if let ty = selectedShop?.venueType {
                type = ty
            } else {
            }
            
            
            if let pepole = selectedShop?.noOFPEOPLE {
                       noOFpeopless.text = pepole
                   } else {
                       noOFpeopless.isHidden = true
                   }

        }
    
          
        // MARK:- Actions
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonpresed(_ sender:Any) {
        let userDefaults = UserDefaults()
        userDefaults.set(name, forKey: "venueNameess")
        userDefaults.set(venueID, forKey: "venueID")
        userDefaults.set(type, forKey: "venueTypesK")
        print(name)
        print(type)
         performSegue(withIdentifier: "toC", sender: self)
    }
  
}
