//
//  ownerHomeVC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 02/06/2021.
//

import UIKit
import Firebase
import MessageUI

class ownerHomeVC: UIViewController,MFMailComposeViewControllerDelegate , UITableViewDelegate, UITableViewDataSource  {
    
    
    
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var textTxt: UILabel!
    @IBOutlet weak var greetingText: UILabel!
    @IBOutlet weak var dashboardTableView: UITableView!
    
    var greeting = ""
    var name = ""
    var type = ""
    
    var categorizedImages = ["addFINDSC2","team","calendar-1","clock-1","help"]
    
    var servicesNames = ["List Your services","My Services","My Calendar", "Booking History", "Help"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcoming()
        greetingLogic()
    }
    
    func welcoming() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        print(uid)
        Database.database().reference().child("All").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let dict = snapshot.value as? NSDictionary
            self.textTxt.text = dict?["fullName"] as? String ?? ""
            self.name = dict?["fullName"] as? String ?? ""
            self.type = dict?["businessType"] as? String ?? ""
            if let profileImage = dict?["profileImageURL"] as? String {
                let url = URL(string: profileImage)
                
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    DispatchQueue.main.async {
                        self.ownerImage.image = UIImage(data: data!)
                    }
                }).resume()
            }
        }
    }
    
    func greetingLogic() {
        
        let date = NSDate()
        let calendar = NSCalendar.current
        let currentHour = calendar.component(.hour, from: date as Date)
        let hourInt = Int(currentHour.description)!

        if hourInt >= 12 && hourInt <= 16 {
            
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                greeting = "مساء الخير"
            } else {
                greeting = "Good Afternoon"
            }
        }
        else if hourInt >= 7 && hourInt <= 12 {
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                greeting = "صباح الخير"
            } else {
                greeting = "Good Morning"
            }
        }
        else if hourInt >= 16 && hourInt <= 20 {
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                greeting = "مساء الخير"
            } else {
                greeting = "Good Evening"
            }
        }
        else if hourInt >= 20 && hourInt <= 24 {
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                greeting = "مساء الخير"
            } else {
                greeting = "Good Evening"
            }
        }
        else if hourInt >= 0 && hourInt <= 7 {
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                greeting = "صباح الخير"
            } else {
                greeting = "Good Morning"
            }
        }
        greetingText.text = greeting
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
           let mailComposerVC = MFMailComposeViewController()
           mailComposerVC.mailComposeDelegate = self
           mailComposerVC.setToRecipients(["support@andmoreksa.com"])
           mailComposerVC.setSubject("App FeedBack")
           mailComposerVC.setMessageBody("Hi team!\n\nI we are \(name) would like to share the following feedback...\n", isHTML: false)
           return mailComposerVC
       }
       
       func showSendMailErrorAlert() {
           let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your Device Could not Send E-mail. Please Check E-mail Configuration And Try Again", delegate: self, cancelButtonTitle: "OK")
           sendMailErrorAlert.show()
       }
       func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
           controller.dismiss(animated: true)
       }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servicesNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dashboardTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ownerHomeCell

        cell.serviceImage.image = UIImage(named: categorizedImages[indexPath.item])
        cell.serviceName.text = servicesNames[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if type == "Women Salons" {
                self.performSegue(withIdentifier: "toadd2", sender: nil)
            } else if type == "Men Salons" {
                self.performSegue(withIdentifier: "toadd2", sender: nil)
            } else if type == "Home Salons" {
                self.performSegue(withIdentifier: "toadd2", sender: nil)
            } else if type == "Wedding Halls" {
                self.performSegue(withIdentifier: "toadd1", sender: nil)
            } else if type == "Chalets" {
                self.performSegue(withIdentifier: "toadd1", sender: nil)
            } else if type == "Photography shop" {
                self.performSegue(withIdentifier: "toadd2", sender: nil)
            } else {
                self.performSegue(withIdentifier: "toadd1", sender: nil)
            }
        } else if indexPath.row == 1 {
            if type == "Women Salons" {
                self.performSegue(withIdentifier: "toadd4", sender: nil)
            } else if type == "Men Salons" {
                self.performSegue(withIdentifier: "toadd4", sender: nil)
            } else if type == "Home Salons" {
                self.performSegue(withIdentifier: "toadd4", sender: nil)
            } else if type == "Wedding Halls" {
                self.performSegue(withIdentifier: "toadd3", sender: nil)
            } else if type == "Chalets" {
                self.performSegue(withIdentifier: "toadd3", sender: nil)
            } else if type == "Photography shop" {
                self.performSegue(withIdentifier: "toadd4", sender: nil)
            } else {
                self.performSegue(withIdentifier: "toadd4", sender: nil)
            }
            
        } else if indexPath.row == 2 {
            self.performSegue(withIdentifier: "toadd5", sender: nil)
        } else if indexPath.row == 3 {
            self.performSegue(withIdentifier: "toadd6", sender: nil)
        } else if indexPath.row == 4 {
            let mailComposeViewController = self.configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
                
            } else {
                self.showSendMailErrorAlert()
            }
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
}
