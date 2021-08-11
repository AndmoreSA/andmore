//
//  activebookingVC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 04/06/2021.
//

import UIKit
import Firebase
import JGProgressHUD

class activebookingVC: UITableViewController, approveDelegate {

    

    func approve(username: String,bookedID:String,venueName:String,bookingDate:String,VenueID:String) {
        print(username)
        print(bookedID)
        print(venueName)
        print(bookingDate)
        
        let hud = JGProgressHUD(style: .dark)
        hud.indicatorView = JGProgressHUDRingIndicatorView()
        hud.textLabel.text = "Uploading"
        hud.show(in: view)
        
        
        let ref3 = Database.database().reference().child("users").child("profile").child(username).child("myAppointments").child(bookingDate).child(VenueID).child(bookedID)
        
    let ref = Database.database().reference().child("VenueAppointments").child("Active").child(VenueID).child(bookedID)
        
        let venueDetails2 = [
            "userBookingStatus":"Please pay to confirm your booking",
            "bookingStatus": "Approved"
        ] as [String:Any]
        
        
        ref.updateChildValues(venueDetails2) { (err, ref) in
            if err != nil {
                print(err)
            } else {
                ref3.updateChildValues(venueDetails2)
                    hud.textLabel.text = "Success !"
                    hud.dismiss(afterDelay: 5.0, animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBOutlet var activeTableview: UITableView!
    
    // MARK: - Variables
    var shops = [ShopSearch]()
    var system = [boodkingDashboardSystem]()
    var venue:boodkingDashboardSystem?
    var selectedShop: ShopSearch?
    var ref: DatabaseReference!
    var typeString:String = ""
    var name:String = ""
    var venueID:String = ""
    var currentKey: String?
    var viewSinglePost = false

    override func viewDidLoad() {
        super.viewDidLoad()
         retrieve()
         ref = Database.database().reference()
    
//        fetchDesks()
        
    }
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
    //        system.removeAll()
    //        self.activeTableview.reloadData()
            fetchDesks()
            
        }
        
//        override func viewWillDisappear(_ animated: Bool) {
//            super.viewWillDisappear(animated)
//            system.removeAll()
//            self.activeTableview.reloadData()
//        }
        
    

         
         // MARK: - Properties
    
    func retrieve() {
        if let venues = selectedShop?.venueName {
            self.name = venues
        }
        
        if let venueIDZ = selectedShop?.venueID {
            venueID = venueIDZ
        }
    }
    
       func fetchDesks() {
                                  
                    let ref = Database.database().reference().child("VenueAppointments").child("Active").child(venueID)

                     ref.observe(.value) { (snapshot) in
                        print(snapshot)
                        self.system.removeAll()

                         guard let dictionaries = snapshot.value as? [String: Any] else {return}

                         dictionaries.forEach({ (key, value) in

                        
                        self.typeString = key
                            
    //                        self.fetchuser(id: key)

                         guard let userDictionary = value as? [String: Any] else {return}

                         let shop = boodkingDashboardSystem(id: key, dictionary: userDictionary)
                         self.system.append(shop)
                            self.system.sort(by: { (post1, post2) -> Bool in
                                return post1.bookingDate > post2.bookingDate
                            })
                         print(shop)

                     })
                         self.activeTableview.reloadData()
                     }
                 }

         
     
          // MARK: - Table view data source
          
          override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return system.count
        }
              
          override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                  
            let cell = activeTableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! activebookingCell
                                          
                cell.delegate1 = self
//                cell.delegate2 = self
                cell.venue = system[indexPath.item]
                  return cell
              }
              
          override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            
                  let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
                  cell.layer.transform = rotationTransform
                  cell.alpha = 0
                  UIView.animate(withDuration: 0.75) {
                      cell.layer.transform = CATransform3DIdentity
                      cell.alpha = 1.0
                  }
              }
              
              
          override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

              let selectedShop = system[indexPath.item]
              performSegue(withIdentifier: "toActive", sender: selectedShop)

        }

              

                       
                   // MARK: - Actions
              override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                          if segue.identifier == "toActive" {
                            
                            
                      if let selectedPhone = sender as? boodkingDashboardSystem,
                          let destinationVC = segue.destination as? UINavigationController {
                            if let childVc = destinationVC.topViewController as? detailedActiveVC {
                                childVc.selectedShop = selectedPhone
                            }
                      }
                  }
              }


}

