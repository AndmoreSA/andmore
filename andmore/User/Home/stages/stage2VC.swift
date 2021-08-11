//
//  stage2VC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 08/06/2021.
//

import UIKit

class stage2VC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var citiesTableView: UITableView!
    
    var citiesName = ["Men Salons","Women Salons","Home Salons","Wedding Halls","Photography shop","Event Orgnizor","Chalets"]
    var selectedService:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = citiesTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! stage2Cell
        cell.selectionStyle = .none
        cell.serviceName.text = citiesName[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
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
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            selectedService = citiesName[indexPath.item]
        }
    }
    
    @IBAction func continueBtnPressed(_ sender: Any) {
        let userDefaults = UserDefaults()
        userDefaults.set(selectedService, forKey: "service1")
        performSegue(withIdentifier: "goToResult2", sender: nil)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated:true,completion:nil)
    }

}
