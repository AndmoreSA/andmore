//
//  loginVC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 10/05/2021.
//

import UIKit
import Firebase
import JGProgressHUD
import Reachability
import GoogleSignIn
import AuthenticationServices
import CryptoKit
import Loaf

class loginVC: UIViewController,GIDSignInDelegate {
    
    //MARK:-Outlets
    @IBOutlet weak var gmailbtn: UIButton!
    
    
    //MARK:-Variables
    fileprivate var currentNonce: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        gmailbtn.layer.cornerRadius = 8
        gmailbtn.layer.borderWidth = 2
        gmailbtn.layer.borderColor = #colorLiteral(red: 0.2252464294, green: 0.5098445415, blue: 0.6438393593, alpha: 1)
        signInWithAppleIDButton()
    }
    
    
    //MARK:- Google Sign In
    
    @IBAction func googlesignin(_ sender: Any) {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    // login with google
       
       func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
           
           guard let fcmToken = Messaging.messaging().fcmToken else {return}
           
           let hud = JGProgressHUD(style: .dark)
                           hud.indicatorView = JGProgressHUDRingIndicatorView()
                           hud.textLabel.text = "Signing in ..."
                           hud.show(in: view)
           
           if(error != nil){
               hud.textLabel.text = "Error:\(error!.localizedDescription)"
                                   print("Error:\(error!.localizedDescription)")
                                               hud.dismiss(afterDelay: 2.0, animated: true)
                                  print("Error logging in: \(error!.localizedDescription)")
               
           }else{
               
               guard let authentication = user.authentication else {
                   hud.textLabel.text = "Error:\(error!.localizedDescription)"
                                       print("Error:\(error!.localizedDescription)")
                                                   hud.dismiss(afterDelay: 2.0, animated: true)
                                      print("Error logging in: \(error!.localizedDescription)")
                   return
                   
               }
               
               let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                              accessToken: authentication.accessToken)
               
               
               Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
                   if let error = error {
                       hud.textLabel.text = "Error:\(error.localizedDescription)"
                       print("Error:\(error.localizedDescription)")
                       hud.dismiss(afterDelay: 2.0, animated: true)
                       print("Error logging in: \(error.localizedDescription)")
                       return
                       
                   } else {
                       
                       guard let uid = user?.user.uid else {return}
                       
                       Database.database().reference().child("stores").child("Allbuisness").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                           if(snapshot.exists()) {
                               Loaf("An email were taken by other store", state: .error, sender: self).show()
                               hud.dismiss(afterDelay: 2.0, animated: true)
                           } else {
                               guard let uid = user?.user.uid else {return}
                               guard let name = user?.user.displayName else {return}
                               guard let email = user?.user.email else {return}
                               
                            Database.database().reference().child("All").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                                    if(snapshot.exists()) {
                                       hud.indicatorView = JGProgressHUDRingIndicatorView()
                                       hud.textLabel.text = "Done"
                                       hud.dismiss(afterDelay: 2.0, animated: true)

//                                               WindowManager.show(storyboard: .user, animated: true)
                                    } else {
                                       
                                 DispatchQueue.main.async {
                                  
                                   let valuse = [
                                       "fcmToken":fcmToken,
                                       "email": user?.user.email,
                                       "uid": uid,
                                       "fullName":user?.user.displayName,
                                       "profileImageURL":user?.user.photoURL?.absoluteString,
                                       "creationDate": Date().timeIntervalSince1970,
                                       "phoneNumber":""
                                   ] as [String:Any]
                                   
                                   
                                   Database.database().reference().child("users/profile/\(uid)").setValue(valuse)
                                   
                                    hud.indicatorView = JGProgressHUDRingIndicatorView()
                                    hud.textLabel.text = "Done"
                                   hud.dismiss(afterDelay: 2.0, animated: true)
//                                    self.performSegue(withIdentifier: "toUserPage", sender: nil)
                               WindowManager.show(storyboard: .user, animated: true)
                                   }
                               }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    //MARK:- Apple Sign In
    func signInWithAppleIDButton() {
        
       let siwaButton = ASAuthorizationAppleIDButton()
        
        // set this so the button will use auto layout constraint
        siwaButton.translatesAutoresizingMaskIntoConstraints = false

        // add the button to the view controller root view
        self.view.addSubview(siwaButton)

        // set constraint
        NSLayoutConstraint.activate([
            siwaButton.topAnchor.constraint(equalTo: self.gmailbtn.bottomAnchor, constant: 8),
            siwaButton.heightAnchor.constraint(equalToConstant: 34.0),
            siwaButton.widthAnchor.constraint(equalToConstant: 285),
            siwaButton.centerXAnchor.constraint(equalTo: self.gmailbtn.centerXAnchor)
        ])

        // the function that will be executed when user tap the button
        siwaButton.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
    }
    
    @available(iOS 13, *)
    @objc func appleSignInTapped() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        // Generate nonce for validation after authentication successful
        self.currentNonce = randomNonceString()
        // Set the SHA256 hashed nonce to ASAuthorizationAppleIDRequest
        request.nonce = sha256(currentNonce!)

        // Present Apple authorization form
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    @available(iOS 13, *)
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
}

extension loginVC : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // return the current view window
        return self.view.window!
    }
      
}

extension loginVC: ASAuthorizationControllerDelegate {
        
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            print("authorization error")
            guard let error = error as? ASAuthorizationError else {
                return
            }

            switch error.code {
            case .canceled:
                // user press "cancel" during the login prompt
                print("Canceled")
            case .unknown:
                // user didn't login their Apple ID on the device
                print("Unknown")
            case .invalidResponse:
                // invalid response received from the login
                print("Invalid Respone")
            case .notHandled:
                // authorization request not handled, maybe internet failure during login
                print("Not handled")
            case .failed:
                // authorization failed
                print("Failed")
            @unknown default:
                print("Default")
            }
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

                guard let fcmToken = Messaging.messaging().fcmToken else {return}
                 // do what you want with the data here
                UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
                
                // Retrieve the secure nonce generated during Apple sign in
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }

                // Retrieve Apple identity token
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Failed to fetch identity token")
                    return
                }

                // Convert Apple identity token to string
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Failed to decode identity token")
                    return
                }

                // Initialize a Firebase credential using secure nonce and Apple identity token
                let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                                  idToken: idTokenString,
                                                                  accessToken: nonce)
                                
                
                Auth.auth().signIn(with: firebaseCredential) { [weak self] (authResult, error) in
                    // Do something after Firebase sign in completed
                    if let error = error {
                        print("Error:\(error.localizedDescription)")
                        print("Error logging in: \(error.localizedDescription)")
                        return
                    } else {
                        
                        guard let uid = authResult?.uid else {return}

                            Database.database().reference().child("stores").child("Allbuisness").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                                if(snapshot.exists()) {
                                    Loaf("An email were taken by other store", state: .error, sender: self!).show()
                                } else {
                                
                                if authResult?.displayName != nil {
//                                    WindowManager.show(storyboard: .user, animated: true)
                                } else {
                                    
                                    guard let uid = authResult?.uid else {return}
                                     let name = appleIDCredential.fullName?.givenName
                                     let email = authResult?.email
                                    
                                    Database.database().reference().child("users").child("profile").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                                    if(snapshot.exists()) {
                                        
                                        Loaf("Welcome Back\(name)", state: .success, sender: self!).show(.average) { (dismiss) in
//                                            WindowManager.show(storyboard: .user, animated: true)
                                        }
                                        
                                    } else {

                                            DispatchQueue.main.async {
                                                let changeRequest = authResult?.createProfileChangeRequest()
                                                  changeRequest?.displayName = appleIDCredential.fullName?.givenName
                                                  changeRequest?.commitChanges(completion: { (error) in

                                                      if let error = error {
                                                          print(error.localizedDescription)
                                                      } else {
                                                          
                                                          
                                                          
                                                          print("Updated display name: \(Auth.auth().currentUser!.displayName!)")
                                                      }
                                                  })
                                                  
                                                  let valuse = [
                                                      "fcmToken":fcmToken,
                                                      "email": authResult?.email,
                                                      "uid": uid,
                                                      "fullName":appleIDCredential.fullName?.givenName,
                                                      "profileImageURL":authResult?.photoURL?.absoluteString,
                                                      "creationDate": Date().timeIntervalSince1970,
                                                      "phoneNumber":""
                                                  ] as [String:Any]
                                                  
                                                  
                                                  Database.database().reference().child("users/profile/\(uid)").setValue(valuse)
                                                  
                                                  
                                                  
//                                                WindowManager.show(storyboard: .user, animated: true)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
}
