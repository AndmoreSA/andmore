//
//  secondOpetion2VC1.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 02/06/2021.
//

import UIKit
import Firebase
import BSImagePicker
import Photos
import JGProgressHUD

class secondOpetion2VC1: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    // MARK: - Variables
    var SelectedAssets = [PHAsset]()
    var photoArray = [UIImage]()
    var originalImage: UIImage!
    var cardID: String!
    var venueName:String!
    var venueID:String!
    var CountryString: String = "NULL"
    var CityString: String = "NULL"
    
    
    
    // MARK: - Outlets
    @IBOutlet weak var imageArray: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getVenueCountry()
        originalImage = #imageLiteral(resourceName: "c")
        imageArray.dataSource = self
        imageArray.delegate = self
        photoArray.append(originalImage)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))

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
        imageArray.reloadData()
           }
    
    
    
    
          override func viewDidAppear(_ animated: Bool) {
//            super.viewDidAppear(animated)
              imageArray.reloadData()
          }
    
    override func viewWillAppear(_ animated: Bool) {
        imageArray.reloadData()
        
          let userrs = UserDefaults()
          if let data6 = userrs.object(forKey: "typeess") {
          if let message2 = data6 as? String {
          cardID = message2
              }

          }

          let userrw = UserDefaults()
          if let data7 = userrw.object(forKey: "names") {
          if let message3 = data7 as? String {
          venueName = message3
              }
        
          }
        
          
          let iddi = UserDefaults()
            if let data7 = iddi.object(forKey: "postID") {
            if let message3 = data7 as? String {
            venueID = message3
            }
        }
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
    



           


    // MARK: - Table view data source

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return photoArray.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageArray.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapRecognizer:)))
        cell.imageView.image = photoArray[indexPath.item]
        cell.imageView.addGestureRecognizer(tap)
        cell.imageView.isUserInteractionEnabled = true

        return cell
        }
    
        // MARK: - Actions
    @IBAction func clearAll(_ sender: Any) {
        SelectedAssets.removeAll();
        convertToUIImage(asset: SelectedAssets)
        imageArray.reloadData()
    }
    @IBAction func uploading(_ sender: Any) {
        
        upload()
    }
    
    
        // MARK: - Properties
    
    func getVenueCountry() {
        
         guard let uid = Auth.auth().currentUser?.uid else {return}
         let ref = Database.database().reference().child("All").child(uid)
        
            
            ref.observeSingleEvent(of: .value) { (snapshot) in
             print(snapshot)

             let dictionaries = snapshot.value as? NSDictionary

             self.CountryString = dictionaries?["country"] as! String
             self.CityString = dictionaries?["city"] as! String
             
             
             print(self.CityString)
             
             print(self.CountryString)
        
    }
        
    }
    
    func upload() {
        
        if Reachability.isConnectedToNetwork(){

              guard let uid = Auth.auth().currentUser?.uid else {return}

              let hud = JGProgressHUD(style: .dark)
              hud.indicatorView = JGProgressHUDRingIndicatorView()
              hud.textLabel.text = "Uploading"
              hud.show(in: view)
            
            let ref = Database.database().reference().child("stores").child("Allbuisness").child(cardID).child(uid).child("Services").child(venueID)
            
            let ref2 =
                Database.database().reference().child("Services").child(CountryString).child(CityString).child(cardID).child(venueID)
               
               let postUID = UUID().uuidString
               for i in 0..<photoArray.count {
                   let imageName = UUID().uuidString
                let storageRef = Storage.storage().reference().child("stores").child(uid).child("Services").child(venueID).child(postUID).child("\(imageName).jpg")
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
                                   })
                            
                            ref2.updateChildValues(values, withCompletionBlock: { (err, ref) in
                                if err != nil {
                                    print(err)
                                    return
                                }
                                })
                               })

                           }
                       }
                   }
            
            hud.textLabel.text = "Success !"
            hud.dismiss(afterDelay: 5.0, animated: true)
           self.performSegue(withIdentifier: "toSecond", sender: nil)
    
        } else {
            self.createAlert2(title: "check your network", message: "")
        }
    }
    
    func cancelBooking() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}

        Database.database().reference().child("stores").child("Allbuisness").child(cardID).child(uid).child("Services").child(venueID).setValue(nil)
        
        Database.database().reference().child("Services").child(CountryString).child(CityString).child(cardID).child(venueID).setValue(nil)
        
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Are you sure you want to cancel it?", message: "The venue detailed will be cancelled, you need to start again", preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "Sure", style: .default, handler: { (action:UIAlertAction) in
               self.cancelBooking()
             WindowManager.show(storyboard: .seller, animated: true)
           }))
           
           alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action:UIAlertAction) in
               print("CancelTapped")
           }))
           present(alertController, animated: true, completion: nil)
         
    }
    
}

