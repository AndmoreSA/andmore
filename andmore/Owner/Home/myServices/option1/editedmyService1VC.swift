//
//  editedmyService1VC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 02/06/2021.
//

import UIKit
import SkyFloatingLabelTextField
import FirebaseAuth
import FirebaseDatabase
import Firebase
import BSImagePicker
import Photos
import JGProgressHUD

class editedmyService1VC: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate , UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

    
    // MARK:- OUTLETS
    
    @IBOutlet weak var TextCount: UILabel!
    @IBOutlet weak var venueDisciprionText: UITextView!
    @IBOutlet weak var venueImagesCollectionView: UICollectionView!
    @IBOutlet weak var changeImageBtn: UIButton!
    @IBOutlet weak var clearAllBtn: UIButton!
    @IBOutlet weak var venueName: SkyFloatingLabelTextField!
    @IBOutlet weak var currencyHour: SkyFloatingLabelTextField!
    @IBOutlet weak var currencyDay: SkyFloatingLabelTextField!
    @IBOutlet weak var priceHour: SkyFloatingLabelTextField!
    @IBOutlet weak var priceDay: SkyFloatingLabelTextField!
    @IBOutlet weak var noOfPeopleText: SkyFloatingLabelTextField!

    // MARK:- VARIABLES
    
    var shops = [ShopSearch]()
    var selectedShop: ShopSearch?
    var ref: DatabaseReference!
    var photoArray = [UIImage]()
    var imagesArray = [String]()
    var originalImage: UIImage!
    var ImageString1: String = "NULL"
    var ImageString2: String = "NULL"
    var ImageString3: String = "NULL"
    var venuesName:String = ""
    var venueType:String = ""
    var venueId:String = ""
    var venueCountry:String = ""
    var companyName:String = ""
    var venueCity:String = ""
    var VenueLat: Double = 0
    var VenueLong: Double = 0
    var SelectedAssets = [PHAsset]()
    var type:String!



    
    private var pickerGeneral1 = ["SAR","AED","BHD","KWD","USD","GBP"]
    private var pickerGeneral2 = ["SAR","AED","BHD","KWD","USD","GBP"]

    
    private var CurrencyPicker1: UIPickerView?
    private var CurrencyPicker2: UIPickerView?

    var currentTextField = UITextField()
    var pickerView = UIPickerView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currencyDay.isEnabled = false
        self.currencyHour.isEnabled = false

        self.venueName.isEnabled = false
        
        self.hideKeyboardWhenTappedAround()
        venueDisciprionText.delegate = self
        
        CurrencyPicker1 = UIPickerView()
        CurrencyPicker1?.delegate = self
        currencyHour.inputView = CurrencyPicker1

        CurrencyPicker2 = UIPickerView()
        CurrencyPicker2?.delegate = self
        currencyDay.inputView = CurrencyPicker2

        
        pickerView.delegate = self
        pickerView.dataSource = self
        currencyHour.delegate = self
        currencyDay.delegate = self
        
        
        let userrs = UserDefaults()
        if let data6 = userrs.object(forKey: "venueNameess") {
            if let message2 = data6 as? String {
                venuesName = message2
            }
            
        }
        
        let serrs = UserDefaults()
        if let data6 = serrs.object(forKey: "venueTypesK") {
            if let message22 = data6 as? String {
                venueType = message22
            }
            
        }
        
        let serrse = UserDefaults()
        if let data6 = serrse.object(forKey: "venueID") {
            if let message22 = data6 as? String {
                venueId = message22
            }
            
        }
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        ref = Database.database().reference()
        
        getVenueLocations()
        fetchWorkspaces()
        originalImage = #imageLiteral(resourceName: "c-1")
        photoArray.append(originalImage)
        
        loadProfileData()


    }
    
    func getVenueLocations() {
           
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let ref = Database.database().reference().child("All").child(uid)
           
               
               ref.observeSingleEvent(of: .value) { (snapshot) in
                print(snapshot)

                let dictionaries = snapshot.value as? NSDictionary

                self.VenueLat = dictionaries?["lat"] as! Double ?? 0
                self.VenueLong = dictionaries?["long"] as! Double ?? 0
                self.venueCountry = dictionaries?["country"] as! String
                self.venueCity = dictionaries?["city"] as! String
                self.companyName = dictionaries?["fullName"] as! String
                self.type = dictionaries?["businessType"] as! String
       }
           
       }
    
    
    
    // MARK: - Collection view data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = venueImagesCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! editServicesImagesCell
        
        let images = imagesArray[indexPath.item]
        cell.image = images
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapRecognizer:)))
        cell.venueImage.addGestureRecognizer(tap)
        cell.venueImage.isUserInteractionEnabled = true
        
        return cell
    }
    
    
    // MARK:- Properties
    
    
    func fetchWorkspaces() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueId)

        ref.observe(.value) { (snapshot) in
            
            self.imagesArray.removeAll()
                    
            print(snapshot)

            guard let dictionaries = snapshot.value as? [String: Any] else {return}

           let key = uid

            let shop = ShopSearch(id: key, dictionary: dictionaries)
            
                if shop.venueImage1 != nil {
                  self.imagesArray.append(shop.venueImage1!)
                }
                
                if shop.venueImage2 != nil {
                                self.imagesArray.append(shop.venueImage2!)
                              }
                
                if shop.venueImage3 != nil {
                                self.imagesArray.append(shop.venueImage3!)
                } else {
                    self.originalImage = #imageLiteral(resourceName: "c-1")
                    self.photoArray.append(self.originalImage)
                    self.venueImagesCollectionView.reloadData()

            }
                
//            self.shops.append(shop)
            print(shop)

//        })
            self.venueImagesCollectionView.reloadData()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
               return 1
           }
          
          func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
              
              
              if currentTextField == currencyHour {
              return pickerGeneral1[row]
              } else if currentTextField == currencyDay {
               return pickerGeneral2[row]
              } else {
                  return ""
              }
           }
          
          func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
              
              if currentTextField == currencyHour {
                  return pickerGeneral1.count
              } else if currentTextField == currencyDay {
               return pickerGeneral2.count
              } else {
                  return 0
              }
          }
          
          func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
              
              if currentTextField == currencyHour {
                  currencyHour.text = pickerGeneral1[row]
                  self.view.endEditing(true)
              } else if currentTextField == currencyDay {
              currencyDay.text = pickerGeneral2[row]
              self.view.endEditing(true)
              } else {
                  print("No Data..")
              }
          }
          

          func textFieldDidBeginEditing(_ textField: UITextField) {
              self.pickerView.delegate = self
              self.pickerView.dataSource = self
              currentTextField = textField

              if currentTextField == currencyHour {
                  currencyHour.inputView = pickerView
              }
          }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = venueDisciprionText.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else {return false}
        
        let updateText = currentText.replacingCharacters(in: stringRange, with: text)
        
        TextCount.text = "\(300 - updateText.count)"
        
        return updateText.count < 300
    }
    
    
    func getstoreImage() {
               guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueId)
              
                  
                  ref.observeSingleEvent(of: .value) { (snapshot) in
                   print(snapshot)

                   let dictionaries = snapshot.value as? NSDictionary

                    self.ImageString1 = dictionaries?["imageUrl1"] as! String
                    self.ImageString2 = dictionaries?["imageUrl2"] as! String
                    self.ImageString3 = dictionaries?["imageUrl3"] as! String
               }
           }
    
    @objc func imageTapped(tapRecognizer: UITapGestureRecognizer){
              let imageView = tapRecognizer.view as! UIImageView
              if imageView.image != originalImage{
                  fullScreen(imageView: imageView)
                  return
              }
        
            let vc2 = ImagePickerController()
        
        vc2.settings.selection.max = 3
        vc2.settings.fetch.assets.supportedMediaTypes = [.image]
        self.presentImagePicker(vc2,
              select: { (asset: PHAsset) -> Void in
                  print("Selected: \(asset)")
              }, deselect: { (asset: PHAsset) -> Void in
                  print("Deselected: \(asset)")
              }, cancel: { (assets: [PHAsset]) -> Void in
                  print("Cancel: \(assets)")
              }, finish: { (assets: [PHAsset]) -> Void in
                  print("Finish: \(assets)")
                  //print(assets.count)
                  for i in 0..<assets.count {
                      self.SelectedAssets.append(assets[i])
                  }
                  self.convertToUIImage(asset: self.SelectedAssets)
              }, completion: nil)
          }
       
       func convertToUIImage (asset: [PHAsset]){
                  let manager = PHImageManager.default()
                  let option = PHImageRequestOptions()
                  photoArray.removeAll()
                  for i in 0..<asset.count {
                      option.isSynchronous = true
                      manager.requestImage(for: asset[i], targetSize: CGSize(width: 600 , height: 600), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                          self.photoArray.append(result!)

                      })
                  }
        
        if photoArray.count < 3{
                        photoArray.append(originalImage)
                    }
        upload()
                }
    
        
    
    func fullScreen(imageView: UIImageView){
               
               let newImageView = UIImageView(image: imageView.image)
               newImageView.frame = UIScreen.main.bounds
               newImageView.backgroundColor = .black
               newImageView.contentMode = .scaleAspectFit
               newImageView.isUserInteractionEnabled = true
               let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
               newImageView.addGestureRecognizer(tap)
               self.view.addSubview(newImageView)
               self.navigationController?.isNavigationBarHidden = true
               self.tabBarController?.tabBar.isHidden = true
           }
           @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
               self.navigationController?.isNavigationBarHidden = false
               self.tabBarController?.tabBar.isHidden = false
               sender.view?.removeFromSuperview()
           }
    

    func loadProfileData() {
        
        guard let userId = Auth.auth().currentUser?.uid else {return}
        let ref =
            Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(userId).child("Services").child(venueId).observe(.value, with: { (snapshot) in
                let values = snapshot.value as? NSDictionary
            
            // MARK:- 1
                
                self.venueName.text = values?["VenueName"] as? String ?? ""
                
                self.noOfPeopleText.text = values?["NumberofPeople"] as? String ?? ""
            
            self.venueDisciprionText.text = values?["VenueDiscription"]as? String ?? ""

            // MARK:- 6
                           
                self.currencyHour.text = values?["CurrencyHour"] as? String ?? ""

                self.currencyDay.text = values?["CurrencyDay"] as? String ?? ""
                 let hour = values?["perHourPrice"] as? Double ?? 0
                 let day = values?["perDayPrice"] as? Double ?? 0

                self.priceHour.text = "\(String(format: "%.02f", hour))"
                self.priceDay.text = "\(String(format: "%.02f", day))"
        })
    }

    
    // MARK:- Actions
    @IBAction func clearAllImagesPressed(_ sender: Any) {
        guard let uid = Auth.auth().currentUser?.uid else {return}

        let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueId)
        
        let photos = [
            "imageUrl1":nil,
            "imageUrl2":nil,
            "imageUrl3":nil

            ] as! [String:Any]
        
        ref.updateChildValues(photos)
        
        imagesArray.removeAll()
        SelectedAssets.removeAll();

    }
    
    @IBAction func changeImagesPressed(_ sender: Any) {
            
                let vc2 = ImagePickerController()
            
            vc2.settings.selection.max = 3
            vc2.settings.fetch.assets.supportedMediaTypes = [.image]
            self.presentImagePicker(vc2,
                  select: { (asset: PHAsset) -> Void in
                      print("Selected: \(asset)")
                  }, deselect: { (asset: PHAsset) -> Void in
                      print("Deselected: \(asset)")
                  }, cancel: { (assets: [PHAsset]) -> Void in
                      print("Cancel: \(assets)")
                  }, finish: { (assets: [PHAsset]) -> Void in
                      print("Finish: \(assets)")
                      //print(assets.count)
                      for i in 0..<assets.count {
                          self.SelectedAssets.append(assets[i])
                      }
                      self.convertToUIImage(asset: self.SelectedAssets)
                  }, completion: nil)
              }
    
    @IBAction func upload(_ sender: Any) {
//        upload()
        uploadingToserver()
    }
    
    func uploadingToserver() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let name = venueName.text else {return}
        guard let people = noOfPeopleText.text else {return}
        guard let hour = priceHour.text else {return}
        guard let currencyHour = currencyHour.text else {return}
        guard let venueDisc = venueDisciprionText.text else {return}

        guard let Day = priceDay.text else {return}
        guard let CurrencyDay = currencyDay.text else {return}

        
        let hud = JGProgressHUD(style: .dark)
                    hud.indicatorView = JGProgressHUDRingIndicatorView()
                    hud.textLabel.text = "Uploading"
                    hud.show(in: view)
                  
        let ref = Database.database().reference().child("stores").child("Allbuisness").child(venueType).child(uid).child("Services").child(venueId)
        
        let ref2 = Database.database().reference().child("Services").child(self.venueCountry).child(self.venueCity).child(venueType).child(venueId)
        
        let venueDetails = [
        
            "VenueName": name,
            "VenueDiscription":venueDisc,
            "NumberofPeople":people,
            "perHourPrice":Double(hour),
            "perDayPrice":Double(Day),
            "CurrencyHour":currencyHour,
            "CurrencyDay":CurrencyDay,
            "fullName":companyName,
        ] as [String:Any]
        
        
             
              
              
        ref.updateChildValues(venueDetails) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            ref2.updateChildValues(venueDetails)
            print("profile Successfully Updated")
            hud.textLabel.text = "Success !"
            hud.dismiss(afterDelay: 5.0, animated: true)
            self.performSegue(withIdentifier: "finalStep", sender: nil)
            
        }

        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func upload() {
               
        guard let uid = Auth.auth().currentUser?.uid else {return}

              let hud = JGProgressHUD(style: .dark)
              hud.indicatorView = JGProgressHUDRingIndicatorView()
              hud.textLabel.text = "Uploading"
              hud.show(in: view)
            
            let ref = Database.database().reference().child("stores").child("Allbuisness").child(uid).child("Venues").child(venueType).child(venueId)

               let postUID = UUID().uuidString
               for i in 0..<photoArray.count {
                   let imageName = UUID().uuidString
                let storageRef = Storage.storage().reference().child("stores").child(uid).child("Venues").child(venueId).child(postUID).child("\(imageName).jpg")
                   let image1 = photoArray[i]
                   if let uploadData = image1.jpegData(compressionQuality: 0.7) {
                       storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                           
                           if error != nil {
                               print(error)
                               return
                           }
                           storageRef.downloadURL(completion: { (url, error) in
                               guard let imageURL = url?.absoluteString else {return}
                               
                               let values = [
                                   "uid": uid,
                                   "imageUrl\(i + 1)": imageURL,
                                   "creationDate": Date().timeIntervalSince1970
                                   ] as [String: Any]
                               ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
                                   if err != nil {
                                       print(err)
                                       return
                                   }
                                   
    //                               postGo.updateChildValues(values, withCompletionBlock: { (err, ref) in
    //                                   if err != nil {
    //                                       return
    //                                   }
                                       
                                       
                                   })
                               })

                           }
                       }
                   }
            
            hud.textLabel.text = "Success !"
            hud.dismiss(afterDelay: 5.0, animated: true)

               }
 
    
    
    @IBAction func backbuttonPressed(_ sender: Any) {
        
        WindowManager.show(storyboard: .seller, animated: true)
    }
}
