//
//  dayAvailability2VC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 04/06/2021.
//

import UIKit
import JTAppleCalendar
import FirebaseAuth
import FirebaseDatabase
import SkyFloatingLabelTextField

class dayAvailability2VC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    // MARK:- Outlets
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var slotsNum: SkyFloatingLabelTextField!
    
    
    
    
    
    
    // MARK:- Variables
    var name: String = ""
    var idds:String = ""
    var venueID:String = ""
    var selectedShop:scheduleModel! {
        didSet {
            if selectedShop.venueName != nil {
                name = selectedShop.venueName
            }
            
            if selectedShop.venueType != nil {
               typeString = selectedShop.venueType
            }
            
            if selectedShop.venueID != nil {
                venueID = selectedShop.venueID
            }
            
        }
    }
    
    var keyString:String = ""
    var typeString: String = "NULL"
    var cityString: String = "NULL"
    var CountryString: String = "NULL"
    var tapped: Bool = false
    var ref: DatabaseReference!
    var TimeSlotList = Array<TimeSlot>()
    var dates = [Date]()
    var firstDate: Date?
    var lastDate: Date?
    let dateFormatter = DateFormatter()
    var selectedDates: [Date] = []
    let monthColor = UIColor.black
    let selectedViewColor = UIColor.gray
    let selectedTextColor = UIColor.white
    let currentDateSelectedViewColor = UIColor.darkGray
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.hideKeyboardWhenTappedAround()
        self.slotsNum.text = "1"
        self.slotsNum.isEnabled = false
        self.slotsNum.isHidden = true
        getStoreType()
        getKeyString()
        self.TimeSlotList.removeAll()
        self.scheduleTableView.reloadData()
        setupCalendarView()

        ref = Database.database().reference()
//        checkExisting()
        
    }
    
    
    // MARK:- Properties
    override func viewDidAppear(_ animated: Bool) {
          //        super.viewDidAppear(animated)
        getKeyString()

//          slotsNum.text = "0"
          ref = Database.database().reference()
          checkExisting()
          self.scheduleTableView.reloadData()
      }
      
      
    
    
            func getStoreType() {
                guard let uid = Auth.auth().currentUser?.uid else {return}
                Database.database().reference().child("All").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                    print(snapshot)
                    
                    let dictionaries = snapshot.value as? NSDictionary
                    
                    self.cityString = dictionaries?["city"] as! String
                    self.CountryString = dictionaries?["country"] as! String
                    
                    print(self.cityString)
                    
                }
            }
    
    
    // MARK:- Actions
    
    
    @IBAction func confirmBtn(_ sender: Any) {
        setDateSlots()
        
        self.TimeSlotList.removeAll()
        self.scheduleTableView.reloadData()
    }
    
    @IBAction func backArrow(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func deleteBtn(_ sender: Any) {
        setDateSlots2()
        
        self.TimeSlotList.removeAll()
        self.scheduleTableView.reloadData()
    }
    
    
    
    func getKeyString(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("stores").child("Allbuisness").child(typeString).child(uid).child("mySchedule").child("Day").observeSingleEvent(of: .value, with: { (snapShot) in
           if let snapDict = snapShot.value as? [String:AnyObject]{
            for each in snapDict{
                let userEmail = each.value["venueName"] as! String
                if(userEmail == self.name)
                {
                        self.keyString = each.key
                    }
                }
            }
        })
    }
    
      func setDateSlots2(){
        
        
            
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let totalDays = selectedDates.count
        
        if totalDays == 0 {
                self.createAlert(title: "Delete Failed", message: "please choose at least 2 dates to delete")
            self.checkExisting()
            self.scheduleTableView.reloadData()

        } else {
        
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            // Get current create time
            let currentDate = Date()
            let currenDateInt = Double(currentDate.timeIntervalSince1970)
            
            guard let start = firstDate, let theEnd = lastDate else {return}

                    
                    let startDate = Double(start.timeIntervalSince1970)
                    let endDate = Double(theEnd.timeIntervalSince1970)
                    
                    
                    var val = 2
                    if slotsNum.text != "" {
                        val = Int(slotsNum.text!)!
                    }
                    
                    
                    for index in 0 ... totalDays - 1 {
                        var datesss = Date(timeIntervalSince1970: startDate)
                        datesss = Calendar.current.date(byAdding: .day, value: index, to: datesss)!
                        
                        Database.database().reference().child("stores").child("Allbuisness").child(typeString).child(uid).child("mySchedule").child("Day").child(self.keyString).child("dates").child(dateToString(date: datesss)).setValue(nil)
                        
                            Database.database().reference().child("Services").child(self.CountryString).child(self.cityString).child(typeString).child(self.venueID).child("mySchedule").child("Day").child(self.keyString).child("dates").child(dateToString(date: datesss)).setValue(nil)
                        
                        
                        dates.append(datesss)
                        print(datesss)
                    }
            //        self.tableView.reloadData()
                      self.showAlert("Success","Time Slots deleted for selected days ", "Dismiss")
            self.checkExisting()
            self.scheduleTableView.reloadData()
            
        }
        
    }
    
      func setDateSlots(){
        
        
        
            
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let totalDays = selectedDates.count
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            // Get current create time
            let currentDate = Date()
            let currenDateInt = Double(currentDate.timeIntervalSince1970)
            
            guard let start = firstDate, let theEnd = lastDate else {return}
            
            
            let startDate = Double(start.timeIntervalSince1970)
            let endDate = Double(theEnd.timeIntervalSince1970)
            
            
            var val = 2
            if slotsNum.text != "" {
                val = Int(slotsNum.text!)!
            }
            
            
            for index in 0 ... totalDays - 1 {
                var datesss = Date(timeIntervalSince1970: startDate)
                datesss = Calendar.current.date(byAdding: .day, value: index, to: datesss)!
                
                Database.database().reference().child("stores").child("Allbuisness").child(typeString).child(uid).child("mySchedule").child("Day").child(self.keyString).child("dates").child(dateToString(date: datesss)).setValue("Available")
                
                    Database.database().reference().child("Services").child(self.CountryString).child(self.cityString).child(typeString).child(self.venueID).child("mySchedule").child("Day").child(self.keyString).child("dates").child(dateToString(date: datesss)).setValue("Available")
                
                
                dates.append(datesss)
                print(datesss)
            }
    //        self.tableView.reloadData()
              self.showAlert("Success","Time Slots Added for days ", "Dismiss")
            self.checkExisting()
            self.scheduleTableView.reloadData()
        }
        
        func checkExisting() {
            self.TimeSlotList.removeAll()
            guard let uid = Auth.auth().currentUser?.uid else {return}
            Database.database().reference().child("stores").child("Allbuisness").child(typeString).child(uid).child("mySchedule").child("Day").child(self.keyString).child("dates").observeSingleEvent(of: .value, with: { (snapShot) in
                print(snapShot)
                if let snapDict = snapShot.value as? [String:AnyObject]{
                    
                    for each in snapDict {
                        
                        let timeSlot = TimeSlot()
                        timeSlot.time = each.key
                        timeSlot.slot = each.value as! String
                        self.TimeSlotList.append(timeSlot)
                        self.TimeSlotList.sort { $0.time.compare($1.time, options: .numeric) == .orderedAscending }
                    }
                    self.scheduleTableView.reloadData()
                }
                
            })
        }
        
        func showAlert(_ title1: String,_ message : String,_ title2: String ){
            let alertController = UIAlertController(title: title1, message: message, preferredStyle: UIAlertController.Style.actionSheet)
            alertController.addAction(UIAlertAction(title: title2, style: UIAlertAction.Style.default, handler: nil))
            alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            self.present(alertController, animated: true, completion: nil)
        }
        
        func dateToString(date : Date) -> String{
            let date = date
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MM-dd-yyyy"
            let calendar = Calendar.current
            let comp = calendar.dateComponents([.year, .month, .day], from: date)
            let hour = comp.year
            let minute = comp.month
            let day = comp.day
            let times = String(hour!) + "-" + String(minute!) + "-" + String(day!)
            return times
        }
        
        
        func setupCalendarView() {
            
            // Setup calendar spacing
            
            calendarView.minimumLineSpacing = 0
            
            calendarView.minimumInteritemSpacing = 0
            
            calendarView.cellSize = 44
            
            calendarView.allowsMultipleSelection = true
            
            calendarView.allowsRangedSelection = true
            
            self.calendarView.scrollingMode = .none

        }
        
        
        func handleCellTextColor(cell: JTACDayCell?, cellState: CellState) {
            
            guard let validCell = view as? DayCalendarCell else { return }
            
            let todaysDate = Date()
            
            let todayDateString = dateFormatter.string(from: todaysDate)
            
            let monthsDateString = dateFormatter.string(from: cellState.date)
            
            if todayDateString == monthsDateString && cellState.dateBelongsTo == .thisMonth {
                
                validCell.dateLabel.textColor = UIColor.red
                
            } else if cellState.date < todaysDate && cellState.dateBelongsTo == .thisMonth {
                
                validCell.dateLabel.textColor = UIColor.lightGray
                
            } else {
                
                if cellState.isSelected {
                    
                    if cellState.dateBelongsTo == .thisMonth {
                        
                        validCell.dateLabel.textColor = UIColor.white
                    }
                } else {
                    
                    if cellState.dateBelongsTo == .thisMonth {
                        
                        validCell.dateLabel.textColor = UIColor.black // Self.monthColor
                    } else {
                        
                        validCell.dateLabel.textColor = UIColor.lightGray // Self.outsideMonthColor
                    }
                }
            }
        }
        
        func handleCellSelected(cell: JTACDayCell?, cellState: CellState) {
            
            guard let validCell = cell as? DayCalendarCell else {
                
                return
            }
            
            if cellState.isSelected && cellState.dateBelongsTo == .thisMonth {
                
                validCell.selectedView.isHidden = false
                
            } else {
                
                validCell.selectedView.isHidden = true
                
                validCell.leftView.isHidden = true
                
                validCell.rightView.isHidden = true
                
                validCell.dateLabel.isHidden = false
                
                validCell.dateLabel.textColor = monthColor
            }
        }
        
    //    handleDate
        
        func handleDateRangeSelection(cell: JTACDayCell?, cellState: CellState) {
            
            guard let cell = cell as? DayCalendarCell else {
                
                return
            }
            
            if calendarView.allowsMultipleSelection {
                
                if cellState.isSelected {
                    
                    switch cellState.selectedPosition() {
                        
                    case .full:
                        
                        cell.selectedView.backgroundColor = selectedViewColor
                        
                        cell.leftView.isHidden = true
                        
                        cell.rightView.isHidden = true
                        
                        cell.dateLabel.textColor = selectedTextColor
                        
                    case .right:
                        
                        cell.leftView.isHidden = false
                        
                        cell.selectedView.backgroundColor = selectedViewColor
                        
                        cell.dateLabel.textColor = selectedTextColor
                        
                    case .left:
                        
                        cell.rightView.isHidden = false
                        
                        cell.selectedView.backgroundColor = selectedViewColor
                        
                        cell.dateLabel.textColor = selectedTextColor
                        
                    case .middle:
                        
                        cell.leftView.isHidden = false
                        
                        cell.rightView.isHidden = false
                        
                        cell.selectedView.backgroundColor = selectedViewColor
                        
                        cell.dateLabel.textColor = selectedTextColor
                        
                    default:
                        
                        cell.leftView.isHidden = true
                        
                        cell.rightView.isHidden = true
                        
                        cell.selectedView.isHidden = true
                        
                        cell.dateLabel.textColor = monthColor
                    }
                }
                
            }
        }

        // TABLE VIEW RETRIEVATION
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.TimeSlotList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = scheduleTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! showAvailabilityDayCell
            
            cell.dateLabel.text = TimeSlotList[indexPath.row].time
            cell.slotsLabel.text = "\(TimeSlotList[indexPath.row].slot)"
            return cell
        }
    
           func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               let service1 = TimeSlotList[indexPath.row]
               
               let alertController = UIAlertController(title: service1.time, message: "Are you sure you want to delete this Day", preferredStyle: .alert)
               
               let deleteAction = UIAlertAction(title: "Delete", style: .default) { (_) in
                   self.deleteClass(id: service1.time)
               }
               
               let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
               
               alertController.addAction(deleteAction)
               alertController.addAction(cancelAction)
               
            alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
               
               present(alertController, animated: true, completion: nil)

           }
       
       func deleteClass(id:String){
           guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("stores").child("Allbuisness").child(typeString).child(uid).child("mySchedule").child("Day").child(self.keyString).child("dates").child(id).setValue(nil)
        
        Database.database().reference().child("Services").child(self.CountryString).child(self.cityString).child(typeString).child(self.venueID).child("mySchedule").child("Day").child(self.keyString).child("dates").child(id).setValue(nil)
        
           checkExisting()
       }
    
        
        


      
        
    }

    extension dayAvailability2VC: JTACMonthViewDataSource {
        
        func configureCalendar(
            _ calendar: JTACMonthView
            ) -> ConfigurationParameters {
            
            dateFormatter.dateFormat = "yyyy MM dd"
            
            dateFormatter.timeZone = Calendar.current.timeZone
            
            dateFormatter.locale = Calendar.current.locale
            
            let startDate = Date()
            
            let endDate = dateFormatter.date(from: "2100 12 31")!
            
            let parameters = ConfigurationParameters(
                startDate: startDate,
                endDate: endDate,
                calendar: Calendar.current,
                generateInDates: .forAllMonths,
                generateOutDates: .tillEndOfRow,
                hasStrictBoundaries: true
            )
            
            return parameters
        }
    }

    extension dayAvailability2VC: JTACMonthViewDelegate {
        
        // TODO: Debug function
        
        
        func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
            
            handleCellTextColor(cell: cell, cellState: cellState)
            
            handleCellSelected(cell: cell, cellState: cellState)
            
            handleDateRangeSelection(cell: cell, cellState: cellState)
            
            cell.layoutIfNeeded()
        }
        

        func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
            
            
            guard let cell = calendar.dequeueReusableJTAppleCell(
                withReuseIdentifier: String(describing: DayCalendarCell.self),
                for: indexPath) as? DayCalendarCell else {
                    
                    return JTACDayCell()
            }
            
            cell.dateLabel.text = cellState.text
            
            handleCellTextColor(cell: cell, cellState: cellState)
            
            handleCellSelected(cell: cell, cellState: cellState)
            
            handleDateRangeSelection(cell: cell, cellState: cellState)
            
            if cellState.dateBelongsTo != . thisMonth {
                
                cell.isHidden = true
            } else {
                
                cell.isHidden = false
            }
            
            cell.layoutIfNeeded()
            
            return cell
        }
        
        func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
         
            handleCellTextColor(cell: cell, cellState: cellState)
            
            handleCellSelected(cell: cell, cellState: cellState)
            
            handleDateRangeSelection(cell: cell, cellState: cellState)
            
            if firstDate != nil {
                
                if date < self.firstDate! {
                    
                    self.firstDate = date
                } else {
                    
                    self.lastDate = date
                }
                
                calendarView.selectDates(
                    from: firstDate!,
                    to: self.lastDate!,
                    triggerSelectionDelegate: false,
                    keepSelectionIfMultiSelectionAllowed: true
                )
                
            } else {
                
                firstDate = date
                
                self.lastDate = date
            }
            
            selectedDates = calendar.selectedDates
            
            cell?.layoutIfNeeded()
        }
        
        func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
            
            handleCellTextColor(cell: cell, cellState: cellState)
            
            handleCellSelected(cell: cell, cellState: cellState)
            
            handleDateRangeSelection(cell: cell, cellState: cellState)
            
            self.calendarView.deselectDates(
                from: self.firstDate!,
                to: self.lastDate!,
                triggerSelectionDelegate: false
            )
            
            if date != self.firstDate && date != self.lastDate {
                
                if date < self.firstDate! {
                    
                    self.firstDate = date
                } else {
                    
                    self.lastDate = date
                }
                
                calendarView.selectDates(
                    from: firstDate!,
                    to: self.lastDate!,
                    triggerSelectionDelegate: false,
                    keepSelectionIfMultiSelectionAllowed: true
                )
                
            } else {
                
                self.firstDate = nil
                
                self.lastDate = nil
            }
        }
        
        func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
            
            
            guard let header = calendarView.dequeueReusableJTAppleSupplementaryView(
                withReuseIdentifier: String(describing: CalendarHeaders.self),
                for: indexPath
                ) as? CalendarHeaders else {
                    
                    return JTACMonthReusableView()
            }
            
            dateFormatter.dateFormat = "MMMM yyyy"
            
            header.daylabels.text = dateFormatter.string(from: range.start)
            
            //        header.showDate(from: formatter.string(from: range.start))
            
            return header
        }
        
        func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
            
            return MonthSize(defaultSize: 30)
        }
    }

    extension dayAvailability2VC: UITextFieldDelegate {
        
        func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
            ) -> Bool {
            
            let maxLength = 40
            
            guard let currentString: NSString = textField.text as NSString? else {
                
                return true
            }
            
            let newString: NSString = currentString.replacingCharacters(
                in: range,
                with: string
                ) as NSString
            
            return newString.length <= maxLength
        }
    }

