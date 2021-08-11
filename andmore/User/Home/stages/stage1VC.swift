//
//  stage1VC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 08/06/2021.
//

import UIKit

class stage1VC: UIViewController , UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var citiesTableView: UITableView!
    
    var citiesName = ["Dammam","Khobar","Riyadh","Jeddah"]
    var selectedService:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = citiesTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! stage1Cell
        cell.selectionStyle = .none
        cell.cityName.text = citiesName[indexPath.row]
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
        userDefaults.set(selectedService, forKey: "city1")
        performSegue(withIdentifier: "goToResult", sender: nil)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated:true,completion:nil)
    }
    
}
