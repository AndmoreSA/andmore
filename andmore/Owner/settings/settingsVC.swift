//
//  settingsVC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 02/06/2021.
//

import UIKit
import Firebase
import Firebase
import MessageUI
import StoreKit

class settingsVC: UITableViewController , MFMailComposeViewControllerDelegate{

    // MARK:- Outlets
    @IBOutlet weak var versionNo: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
         if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionNo.text = version
        }
    }

    // MARK:- contact Us / Feedback Properties
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
           let mailComposerVC = MFMailComposeViewController()
           mailComposerVC.mailComposeDelegate = self
           mailComposerVC.setToRecipients(["support@fandmoreKSA.com"])
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
        
        if indexPath.section == 0 && indexPath.row == 0 {
            performSegue(withIdentifier: "ediiit", sender: nil)
        }
         else if indexPath.section == 1 && indexPath.row == 0 {

               let urlWhats = "https://wa.me/966556963942"
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
           } else if indexPath.section == 2 && indexPath.row == 0 {
               let alertController = UIAlertController(title: "Rate Us!", message: "Are you enjoying our App? please rate us in the app store!, if you know of ways we can make our app better, please send us feedback so we can improve the experience for you!", preferredStyle: .alert)
                         alertController.addAction(UIAlertAction(title: "Rate on iTunes", style: .default, handler: { (action:UIAlertAction!) in
                             print("Rate us")
                            if #available( iOS 10.3,*){
                            SKStoreReviewController.requestReview()
                            }
                         }))
                         alertController.addAction(UIAlertAction(title: "Send Us Feedback", style: .default, handler: { (action:UIAlertAction!) in
                             let mailComposeViewController = self.configuredMailComposeViewController()
                             if MFMailComposeViewController.canSendMail() {
                                 self.present(mailComposeViewController, animated: true, completion: nil)
                                 
                             } else {
                                 self.showSendMailErrorAlert()
                             }
                         }))
                         alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action:UIAlertAction!) in
                             print("CancelTapped")
                         }))
                         present(alertController, animated: true, completion: nil)
        }
       }
    
    @IBAction func logout(_ sender: Any) {
        
        try! Auth.auth().signOut()
        WindowManager.show(storyboard: .login, animated: true)
    }

}
