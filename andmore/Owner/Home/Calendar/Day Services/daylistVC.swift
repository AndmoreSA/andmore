//
//  daylistVC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 04/06/2021.
//

import UIKit
import Firebase

class daylistVC: UITableViewController {

    
  
    //MARK:-OUTLETS
    @IBOutlet var dayTableView: UITableView!
    
    
    
    
    //MARK:- Variables
    var shops = [scheduleModel]()
    var selectedShop: scheduleModel?
    var type:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        welcoming()
    }
   // MARK:- Properties
   func welcoming() {
       guard let uid = Auth.auth().currentUser?.uid else {return}
       print(uid)
       Database.database().reference().child("All").child(uid).observeSingleEvent(of: .value) { (snapshot) in
           let dict = snapshot.value as? NSDictionary
           self.type = dict?["businessType"] as? String ?? ""
           self.fetchDayScheulde(string:self.type)
       }
   }
           
    func fetchDayScheulde(string:String) {
           guard let uid = Auth.auth().currentUser?.uid else {return}
                  
        let ref = Database.database().reference().child("stores").child("Allbuisness").child(string).child(uid).child("mySchedule").child("Day")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
               
               print(snapshot)

               guard let dictionaries = snapshot.value as? [String: Any] else {return}

               dictionaries.forEach({ (key, value) in

              let key = uid

               guard let userDictionary = value as? [String: Any] else {return}

               let shop = scheduleModel(id: key, dictionary: userDictionary)
               self.shops.append(shop)
               print(shop)

           })
               self.dayTableView.reloadData()
           }
           
           
       }
    
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return shops.count
        }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = dayTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! daylistCell
                        
            cell.venueSearches = shops[indexPath.item]
                        
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
        
        
            let selectedShop = shops[indexPath.item]
            performSegue(withIdentifier: "ToToTo", sender: selectedShop)
            
        }
    
    
    
   
        
        
        // MARK:- Actions
        

    @IBAction func backArrow(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "ToToTo" {
            if let selectedPhone = sender as? scheduleModel,
                let destinationVC = segue.destination as? dayAvailabilityVC {
                destinationVC.selectedShop = selectedPhone
            }
        }
    }
     
}
