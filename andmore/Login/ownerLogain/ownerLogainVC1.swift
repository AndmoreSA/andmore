//
//  ownerLogainVC1.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 02/06/2021.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import JGProgressHUD
import Reachability
import GoogleSignIn
import AuthenticationServices
import CryptoKit
import Loaf

class ownerLogainVC1: UIViewController {
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var signinbtn: UIButton!
    @IBOutlet weak var signupbtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        emailTextField.keyboardType = .asciiCapable
        passwordTextField.keyboardType = .asciiCapable
        
        self.hideKeyboardWhenTappedAround()
        
        signinbtn.layer.cornerRadius = 8
        signinbtn.layer.borderWidth = 2

        signupbtn.layer.cornerRadius = 8
        signupbtn.layer.borderWidth = 2
        
    }
    

    @IBAction func signInBtnPressed(_ sender: Any) {
        
        let hud = JGProgressHUD(style: .dark)
                      hud.indicatorView = JGProgressHUDRingIndicatorView()
                      hud.textLabel.text = "Signing in ..."
                      hud.show(in: view)
        
        guard let email = emailTextField.text else { return }
             guard let pass = passwordTextField.text else { return }
             
             let rootRef = Database.database().reference()

                          
             Auth.auth().signIn(withEmail: email, password: pass) { user, error in
                 if error == nil && user != nil {
                     hud.textLabel.text = "Success !"
                     hud.dismiss(afterDelay: 5.0, animated: true)
                     
                     Auth.auth().addStateDidChangeListener({ (auth, user) in
                         
                         if(user != nil){
                             
                             rootRef.child("All").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in
                                 
                                 if(snapshot.exists()) {
                                     
                                     print("owner is signed in.")
                                     hud.indicatorView = JGProgressHUDRingIndicatorView()
                                     hud.textLabel.text = "Done"
                                    hud.dismiss(afterDelay: 5.0, animated: true)

                                    WindowManager.show(storyboard: .seller, animated: true)

                                     
                                     
                                 } else {
                                     
//                                     rootRef.child("users").child("profile").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in
//
//                                         if(snapshot.exists()) {
//
//                                             print("user is signed in.")
                                              hud.indicatorView = JGProgressHUDRingIndicatorView()
                                              hud.textLabel.text = "This is only for service providers"
                                             hud.dismiss(afterDelay: 2.0, animated: true)
//                                             self.performSegue(withIdentifier: "toHomeScreen", sender: self)
//
//                                         } else {
//                                            hud.indicatorView = JGProgressHUDRingIndicatorView()
//                                              hud.textLabel.text = "Done"
//                                             hud.dismiss(afterDelay: 2.0, animated: true)
//                                             self.performSegue(withIdentifier: "toAdmin", sender: self)
//                                        }
//                                     })
                                 }
                             })
                             
                         }
                     })
                     
                     
                 } else {
                             hud.textLabel.text = "Error:\(error!.localizedDescription)"
                     print("Error:\(error!.localizedDescription)")
                                 hud.dismiss(afterDelay: 2.0, animated: true)
                    print("Error logging in: \(error!.localizedDescription)")
                 }
             }
        
    }
    

}
