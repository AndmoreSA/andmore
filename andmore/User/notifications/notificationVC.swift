//
//  notificationVC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 08/06/2021.
//

import UIKit
import DZNEmptyDataSet


class notificationVC: UIViewController ,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    // MARK:- Outlets
    
    @IBOutlet weak var notificationTableVCer: UITableView!
    
    
    // MARK:- Variables
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        notificationTableVCer.emptyDataSetSource = self
        notificationTableVCer.emptyDataSetDelegate = self
        notificationTableVCer.tableFooterView = UIView()

    }

    // MARK: - Table view data source
    
        
        func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
            let str = "All clear"
            let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
            return NSAttributedString(string: str, attributes: attrs)
        }
    
        func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
            let str = "No Notifications at the moment"
            let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
            return NSAttributedString(string: str, attributes: attrs)
        }
    
        func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
            return UIImage(named: "bell")
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }



}

