//
//  ViewController.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 10/05/2021.
//

import UIKit
import Firebase
import AuthenticationServices

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(appleIDStateDidRevoked(_:)), name: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil)
    }
    
    @objc func appleIDStateDidRevoked(_ notification: Notification) {
        
        guard let uid = Auth.auth().currentUser else {return}
        // Make sure user signed in with Apple
        if let providerId = uid.providerData.first?.providerID,
            providerId == "apple.com" {
            signOut()
        }
    }
    
    func signOut() {
        guard let uid = Auth.auth().currentUser else {return}
        
        
        if let providerId = uid.providerData.first?.providerID,
            providerId == "apple.com" {
            // Clear saved user ID
            UserDefaults.standard.set(nil, forKey: "appleAuthorizedUserIdKey")
        }
        
        try! Auth.auth().signOut()
//        WindowManager.show(storyboard: .login, animated: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil)
    }
    
       override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            let rootRef = Database.database().reference()

            Auth.auth().addStateDidChangeListener({ (auth, user) in

                if(user != nil){
                    
                    print(user?.uid)

                    rootRef.child("All").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in

                        if(snapshot.exists()) {

                            print("Seller is signed in.")

                    self.performSegue(withIdentifier: "toOwnerPage", sender: self)


                        } else {

                            rootRef.child("users").child("profile").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in

                                if(snapshot.exists()) {

                                    print("Doctor is signed in.")

                        self.performSegue(withIdentifier: "toUserPage", sender: self)

                                } else {

                        self.performSegue(withIdentifier: "toLogin", sender: self)
//                        self.performSegue(withIdentifier: "toAdmin", sender: self)

                                }
                            })
                        }
                    })

                } else {
                     self.performSegue(withIdentifier: "toLogin", sender: self)
                }

            })

        }
    

}

