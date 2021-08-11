//
//  userSettingsVC.swift
//  andmore
//
//

import UIKit
import Firebase
import MessageUI
import SDWebImage
import StoreKit

class userSettingsVC: UITableViewController , MFMailComposeViewControllerDelegate{


    // MARK:- Outlets
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var emailLabels: UILabel!
    @IBOutlet weak var versionNo: UILabel!
    
    
    
    
    // MARK:- Variables
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveUserName()
        userProfileImage.layer.cornerRadius = userProfileImage.frame.size.width / 2
        userProfileImage.clipsToBounds = true
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        version()
    }
    
    func version() {
         if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionNo.text = version
        }
    }
    
    
    
    // MARK:- Properties
    
       func retrieveUserName() {
            if let userID = Auth.auth().currentUser?.uid {
                Database.database().reference().child("users").child("profile").child(userID).observe(.value) { (snapshot) in
                    let dict = snapshot.value as? NSDictionary
                    let username = dict?["fullName"] as? String ?? "fullName"
                    let email = dict?["email"] as? String ?? "email"
    //
    //                if (email != nil) {
    //                    self.userIEmail.text = email
    //                } else {
    //                    self.userIEmail.text = ""
    //                }
                    self.userName.text = username
                    self.emailLabels.text = email

                    if let profileImageURL = dict?["profileImageURL"] as? String {
                        self.userProfileImage.sd_setImage(with: URL(string: profileImageURL))
                    }
                }
            }
            print("couldn't find the user name")
        }
    
    // MARK:- contact Us / Feedback Properties
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
           let mailComposerVC = MFMailComposeViewController()
           mailComposerVC.mailComposeDelegate = self
           mailComposerVC.setToRecipients(["support@findsquare.co"])
           mailComposerVC.setSubject("App FeedBack")
           mailComposerVC.setMessageBody("Hi team!\n\nI would like to share the following feedback...\n", isHTML: false)
           return mailComposerVC
       }
       
       func showSendMailErrorAlert() {
           let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your Device Could not Send E-mail. Please Check E-mail Configuration And Try Again", delegate: self, cancelButtonTitle: "OK")
           sendMailErrorAlert.show()
       }
       func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
           controller.dismiss(animated: true)
       }
    
    
    
    
    // MARK:- TableView data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 1 {
            let urlWhats = "https://wa.me/966543831902"
            if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
                if let whatsappURL = URL(string: urlString) {
                    if UIApplication.shared.canOpenURL(whatsappURL){
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    }
                    else {
                        //                    AlertPopUP(title: "Error!", message: "You have to install whatsapp")
                    }
                }
            }
        }
    }
    
    
    
    
    // MARK:- Actions
    @IBAction func logoutPressed(_ sender: Any) {
        try! Auth.auth().signOut()
        WindowManager.show(storyboard: .login, animated: true)
    }
}


