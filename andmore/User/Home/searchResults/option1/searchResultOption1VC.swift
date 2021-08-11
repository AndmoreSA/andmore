//
//  searchResultOption1VC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 08/06/2021.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseDatabase
import DZNEmptyDataSet
import Lottie

class searchResultOption1VC: UIViewController, UITableViewDelegate, UITableViewDataSource , CLLocationManagerDelegate , locationDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    

    func locationFound(_ loc: CLLocation) {
        lastLocation = loc
        print("LOL")
        searchResultTableView.reloadData()
    }
    
    
    // MARK:- Outlets
    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var countrychoosenTxt: UILabel!
    @IBOutlet weak var citychoosenTxt: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var tryBtn: UIButton!
    @IBOutlet weak var sorrylabel: UILabel!
    
    
    // MARK:- Vairables
    var venues = [venueSearch]()
    var filteredPost = [venueSearch]()
    
    
    
    var fre:String = "Yes"
    var name: String = ""
    var type: String = ""
    var country:String = "Saudi Arabia"
    var city:String = ""
    var price:String = ""
    var checkIn:String = ""
    var disanceLocationINKM:String?
    let locationManager = CLLocationManager()
    var shopLat = 0.0
    var shopLong = 0.0
    var distanceFormatter = MKDistanceFormatter()
    var userlocation:CLLocation?
    var ref: DatabaseReference!
    var handle: DatabaseHandle!
    private var itemsToDisplay: [Any] = []
    
    
    //////
     var lastLocation: CLLocation? = nil
     var distance : Double?

    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
        
        tryBtn.layer.cornerRadius = tryBtn.bounds.height/2

        self.tryBtn.isHidden = true
        self.sorrylabel.isHidden = true

        //geolocation
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
        CustomLocationManager.shared.delegateLoc = self

        self.getLocation()

        retrieveInfo()
        self.venues.removeAll()
        self.searchResultTableView.reloadData()
        showResults()
        
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(searchResultOption1VC.enableButton), userInfo: nil, repeats: false)

        
    }
    
    @objc func enableButton() {
        self.tryBtn.isHidden = false
        self.sorrylabel.isHidden = false
    }
    
    func startAnimation() {
        animationView.animation = Animation.named("world",subdirectory: "TestAnimations")
        animationView.loopMode = .loop
        animationView.play()
    }
    
        func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
            let str = "Sorry"
            let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
            return NSAttributedString(string: str, attributes: attrs)
        }
    
        func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
            let str = " No store available for the selected category or location 😿"
            let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
            return NSAttributedString(string: str, attributes: attrs)
        }
    
        func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
            return UIImage(named: "anxiety-2")
        }
    
    
    
    
    // MARK:- Properties
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          userlocation = locations[0]
          
      }
      
      func getDistance(latitude: Double, longitude: Double){
          guard let coordinate0 = lastLocation else {return}
          let coordinate1 = CLLocation(latitude: latitude, longitude: longitude)
          let distanceInMeters = coordinate0.distance(from: coordinate1)
          distance = distanceInMeters
      }
      //Location Tracking
      
      func getLocation () {
          lastLocation = CustomLocationManager.shared.locationManager.location
      }
      
      func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
          if status == .authorizedWhenInUse {
              locationManager.startUpdatingLocation()
          }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func retrieveInfo() {
       let namse = UserDefaults()
                       
       if let data33 = namse.object(forKey: "city1") {
           if let message2 = data33 as? String {
               city = message2
               print(message2)
            citychoosenTxt.text = city
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
        
        
        if let data33 = namse.object(forKey: "service1") {
              if let message2 = data33 as? String {
                  type = message2
                  print(message2)

              }
          }
           
    }
    
       func showResults() {
            
            let ref = Database.database().reference().child("Services").child(country).child(city).child(type)
        
            
                ref.observeSingleEvent(of: .value) { (snapshot) in
                print(snapshot)
                    
            if (snapshot.exists()) {
            if let snapDict = snapshot.value as? [String:AnyObject] {
                    for each in snapDict {
                            let pricechosen = each.value["PriceTypeSelection"] as? String
                            if(pricechosen == self.price) {
                                print(each.key)
                                print("found")
                                    Database.fetchShopwithUID(name: each.key, type: self.type, country: self.country, city: self.city) { (shop) in
                                        self.venueShow(String: shop)
                                    }
                                } else {
                                }
                            }
                        }
                    } else {
            }
        }
        
        }
            func venueShow(String:venueSearch) {
                let no = String.venueID
                print(no)
                                
                let ref = Database.database().reference().child("Services").child(country).child(city).child(type).child(no).child("mySchedule").child(price)
                    
                    ref.observeSingleEvent(of: .value) { (snapshot) in
                       print(snapshot)
                        
                        if (snapshot.exists()) {
                            
                            if let snaps = snapshot.value as? [String:Any] {
                                for each in snaps {
                                    let uid = each.key
                                    print(uid)
                                    
                                    self.venueShowid2(Strings: uid)

                                }
                            }
                            
                        } else {
                            print("Not Match sorry try different date ")
//                            self.createAlert(title: "No Store Available", message: "Sorry, Please try different date ")
                        }
                        

                    }
            }
        
        func venueShowid2(Strings:String) {
        
            print(checkIn)
            
            print(Strings)
            
            
                let ref = Database.database().reference().child("Services").child(country).child(city).child(type)
                
                    ref.observeSingleEvent(of: .value) { (snapshot) in
                    print(snapshot)
                        
                        guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
                        
                        dictionary.forEach { (key,value) in
                            let uidz = key
                            Database.database().reference().child("Services").child(self.country).child(self.city).child(self.type).child(uidz).child("mySchedule").child(self.price).child(Strings).child("dates").observeSingleEvent(of: .value) { (snapshot) in
                                
                                if (snapshot.exists()) {
                                    
                                    if let snaps = snapshot.value as? [String:Any] {
                                           for each in snaps {
                                            
                                            let uid = each.key
                                            print(uid)
                                            
                                            if (uid == self.checkIn) {
                                                
                                                self.showResults3(venueName: uidz)
                                                
                                            }
                                        }

                                    }
                                } else {
//                        self.createAlert(title: "No Store Available", message: "Sorry, Please try different date ")

                                }

                            }
                        }
                    }
                }
        
        func showResults3(venueName:String) {
                    
            let ref = Database.database().reference().child("Services").child(country).child(city).child(type).child(venueName)
                    
                        ref.observeSingleEvent(of: .value) { (snapshot) in
                        print(snapshot)
                            
                            
                            guard let shopDictionary = snapshot.value as? [String:Any] else {return}
                                let shop = venueSearch(name: venueName, dictionary: shopDictionary)
                            
                            self.venues.append(shop)
                            self.filteredPost = self.venues
                            self.searchResultTableView.reloadData()
                            self.animationView.isHidden = true
                            self.tryBtn.isHidden = true
                            self.sorrylabel.isHidden = true

                        }
           
                    }

    // MARK:- TableView data source

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! searchResultsoption1Cell
        
        cell.venueSearches = filteredPost[indexPath.item]
            
        let questionLat = Double(filteredPost[indexPath.row].latitude)
        let questionLon = Double(filteredPost[indexPath.row].longitude)
        getDistance(latitude: questionLat, longitude: questionLon)

        if let distance = distance{
            switch distance {
            case 0.0...100.0 :
                cell.venueDistance.text = "100m"
            case 101...200 :
                cell.venueDistance.text = "200m"
            case 201...300 :
                cell.venueDistance.text = "300m"
            case 301...400 :
                cell.venueDistance.text = "400m"
            case 401...500 :
                cell.venueDistance.text = "500m"
            case 501...600 :
                cell.venueDistance.text = "600m"
            case 601...700 :
                cell.venueDistance.text = "700m"
            case 701...800 :
                cell.venueDistance.text = "800m"
            case 801...900 :
                cell.venueDistance.text = "900m"
            default:
                cell.venueDistance.text = String(format: "%.0f", distance / 1000) + " km"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
                         let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.75) {
        cell.layer.transform = CATransform3DIdentity
        cell.alpha = 1.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedShop = filteredPost[indexPath.item]
            performSegue(withIdentifier: "kdslj", sender: selectedShop)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let selectedPhone = sender as? venueSearch,
        let destinationVC = segue.destination as? UINavigationController {
        if let childVc = destinationVC.topViewController as? generalOverviewOption1VC {
        childVc.selectedShop = selectedPhone
            }
        }
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tryPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
