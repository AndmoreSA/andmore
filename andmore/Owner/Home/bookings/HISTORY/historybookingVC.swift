//
//  historybookingVC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 04/06/2021.
//

import UIKit
import Firebase

class historybookingVC: UITableViewController {

    
    // MARK:- Outlets
    @IBOutlet var pastTableView: UITableView!
    
    
    
    
    // MARK: - Variables
    var shops = [ShopSearch]()
    var system = [boodkingDashboardSystem]()
    var selectedShop: ShopSearch?
    var ref: DatabaseReference!
    var typeString:String = ""
    var name:String = ""
    var venueID:String = ""
    var clickedPath: IndexPath? = nil

    
    override func viewDidLoad() {
         super.viewDidLoad()
         retrieve()
         ref = Database.database().reference()
         fetchDesks()
            
         }
    
       
         // MARK: - Properties
    
    func retrieve() {
        if let venues = selectedShop?.venueName {
            self.name = venues
        }
        
        if let venueIDz = selectedShop?.venueID {
            self.venueID = venueIDz
        }
    }

      func fetchDesks() {
                       
         let ref = Database.database().reference().child("VenueAppointments").child("past").child(venueID)

          ref.observe(.value) { (snapshot) in
             print(snapshot)
             self.system.removeAll()

              guard let dictionaries = snapshot.value as? [String: Any] else {return}

              dictionaries.forEach({ (key, value) in

             
             self.typeString = key
                 
              guard let userDictionary = value as? [String: Any] else {return}

              let shop = boodkingDashboardSystem(id: key, dictionary: userDictionary)
              self.system.append(shop)
                 self.system.sort(by: { (post1, post2) -> Bool in
                     return post1.bookingDate > post2.bookingDate
                 })
              print(shop)

          })
              self.pastTableView.reloadData()
          }
      }

         
         
              // MARK: - Table view data source
              
              override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                      return system.count
                  }
                  
              override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                      
                      let cell = pastTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! historybookingCell
                
            
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
          performSegue(withIdentifier: "toPast", sender: selectedShop)

                  }


    
                       
                   // MARK: - Actions
              override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                          if segue.identifier == "toPast" {
                            
                            
                      if let selectedPhone = sender as? boodkingDashboardSystem,
                          let destinationVC = segue.destination as? UINavigationController {
                            if let childVc = destinationVC.topViewController as? detailedHistoryVC {
                                childVc.selectedShop = selectedPhone
                            }
                      }
                          }
              }


}
