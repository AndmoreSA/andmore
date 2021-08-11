//
//  bookingDashboardVC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 04/06/2021.
//

import UIKit
import LZViewPager
import Firebase

class bookingDashboardVC: UIViewController , LZViewPagerDelegate,LZViewPagerDataSource {

    // MARK:- outlets
    @IBOutlet weak var viewPager: LZViewPager!

    //MARK:- vairables
    private var subControllers:[UITableViewController] = []
    var selectedShop: ShopSearch?

    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        viewPagerProperties()
        retrieve()
    }
    
    
    //MARK:- properties
    
    func retrieve() {
        if let venue = selectedShop?.venueName {
            title = venue
        }
    }
    
     func viewPagerProperties() {

     viewPager.dataSource = self
     viewPager.delegate = self
     viewPager.hostController = self

     let vc1 = UIStoryboard(name: "owner", bundle: nil).instantiateViewController(withIdentifier: "activebookingVC") as! activebookingVC

     let vc2 = UIStoryboard(name: "owner", bundle: nil).instantiateViewController(withIdentifier: "historybookingVC") as! historybookingVC
         
     let vc3 = UIStoryboard(name: "owner", bundle: nil).instantiateViewController(withIdentifier: "cancelledbookingVC") as! cancelledbookingVC


     vc1.selectedShop = selectedShop
     vc2.selectedShop = selectedShop
     vc3.selectedShop = selectedShop



     vc1.title = "ACTIVE"
     vc2.title = "HISTORY"
     vc3.title = "REJECTED"


     subControllers = [vc1, vc2, vc3]
     viewPager.reload()
     }

     func numberOfItems() -> Int {
     return self.subControllers.count
     }

     func controller(at index: Int) -> UIViewController {
     return subControllers[index]
     }

     func button(at index: Int) -> UIButton {
     let button = UIButton()
     button.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
     button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .selected)
     button.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
     button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
     return button
     }

     func colorForIndicator(at index: Int) -> UIColor {
     return #colorLiteral(red: 0.3969067037, green: 0.797079742, blue: 0.9972768426, alpha: 1)
     }

     override var preferredStatusBarStyle: UIStatusBarStyle {
     get {
       return .lightContent
     }
     }


}
