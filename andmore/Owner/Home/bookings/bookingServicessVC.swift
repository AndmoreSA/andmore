//
//  bookingServicessVC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 04/06/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class bookingServicessVC: UITableViewController {
    
     
     // MARK: - Outlets

     @IBOutlet var servicesTableView: UITableView!
     
    
    
    
    // MARK: - Variables
    var shops = [ShopSearch]()
    var selectedShop: ShopSearch?
    var ref: DatabaseReference!
     var typeString: String = "NULL"
     var ImageString: String = "NULL"
    var type:String = ""
    
    override func viewDidLoad() {
          super.viewDidLoad()
          
          ref = Database.database().reference()
          welcoming()
         
      }
      
      
           // MARK: - Table view data source
           
           override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                   return shops.count
               }
               
           override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                   
                   let cell = servicesTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! bookingServicesCell
                               
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
       performSegue(withIdentifier: "onee", sender: selectedShop)
                   
               }
               
           

           
           // MARK: - Properties
      
    func welcoming() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        print(uid)
        Database.database().reference().child("All").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let dict = snapshot.value as? NSDictionary
            self.type = dict?["businessType"] as? String ?? ""
            self.fetchServices(string:self.type)
        }
    }
    
           
    func fetchServices(string:String) {
               
               guard let uid = Auth.auth().currentUser?.uid else {return}
               
        let ref = Database.database().reference().child("stores").child("Allbuisness").child(string).child(uid).child("Services")

               ref.observe(.value) { (snapshot) in
                  print(snapshot)

                   guard let dictionaries = snapshot.value as? [String: Any] else {return}

                   dictionaries.forEach({ (key, value) in

                  let key = uid
                  self.typeString = key

                   guard let userDictionary = value as? [String: Any] else {return}

                   let shop = ShopSearch(id: key, dictionary: userDictionary)
                   self.shops.append(shop)
                   print(shop)

               })
                   self.servicesTableView.reloadData()
               }
           }

    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
                // MARK: - Actions
           override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                       if segue.identifier == "onee" {
                   if let selectedPhone = sender as? ShopSearch,
                       let destinationVC = segue.destination as? bookingDashboardVC {
                       destinationVC.selectedShop = selectedPhone
                   }
               }
           }


}
