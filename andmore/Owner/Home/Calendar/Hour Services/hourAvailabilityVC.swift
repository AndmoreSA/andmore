//
//  hourAvailabilityVC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 04/06/2021.
//

import UIKit
import JTAppleCalendar
import FirebaseAuth
import FirebaseDatabase
import SkyFloatingLabelTextField

class hourAvailabilityVC: UIViewController,UITableViewDelegate,  UITableViewDataSource,JTACMonthViewDataSource,JTACMonthViewDelegate , UITextFieldDelegate {
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var startTime: SkyFloatingLabelTextField!
    @IBOutlet weak var endTime: SkyFloatingLabelTextField!
    @IBOutlet weak var SchedultableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    

// MARK:- Variables
    var name: String = ""
    var venueID :String = ""
    var refServices: DatabaseReference!
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
    var dates = [Date]()
    let startPicker = UIDatePicker()
    let endPicker = UIDatePicker()
    var appointmentScrolled = false
    var keyDate:String = "NULL"
    var typeString: String = "NULL"
    var cityString: String = "NULL"
    var CountryString: String = "NULL"
    var keyString:String = ""
    var dateString: String = ""
    var ref: DatabaseReference!
    let dateFormatter = DateFormatter()
    var selectedDates: [Date] = []
    let monthColor = UIColor.black
    let selectedViewColor = UIColor.blue
    let selectedTextColor = UIColor.white
    let currentDateSelectedViewColor = UIColor.darkGray
    let outsideMonthColor = UIColor.white
    //    let monthColor = UIColor.darkGray
    let selectedMonthColor = UIColor.white
    //    let currentDateSelectedViewColor = UIColor.black
    var TimeSlotList = Array<TimeSlot>()
    let formatter = DateFormatter()
    var calendarViewHidden = true
    var selectedTime = ""
    var type:String = ""
    var selectedDate = ""
    var endTimes = ""
    var selectedTimeSlot: Int = 0
    var timeSlots = [Date]()
    let currentDate = Date()



override func viewDidLoad() {
    super.viewDidLoad()
    
    startTime.keyboardType = .asciiCapableNumberPad
    endTime.keyboardType = .asciiCapableNumberPad
    
    UIView.appearance().semanticContentAttribute = .forceLeftToRight


            getStoreType()
            setupCalendarView()
           startPicker.datePickerMode = UIDatePicker.Mode.time
           endPicker.datePickerMode = UIDatePicker.Mode.time
           startTime.text = "8:0"
           endTime.text = "16:0"
           calendarView.scrollToDate(Date(), animateScroll: false)
           calendarView.selectDates([Date()])
           startPicker.minuteInterval = 30
    startPicker.locale = Locale(identifier: "en")
           endPicker.minuteInterval = 30
    endPicker.locale = Locale(identifier: "en")

           var dateComponents = DateComponents()
           dateComponents.hour = 8
           dateComponents.minute = 0
           var userCalendar = Calendar.current
           var someDateTime = userCalendar.date(from: dateComponents)
           startPicker.date = someDateTime!
           
           dateComponents.hour = 16
           dateComponents.minute = 0
           userCalendar = Calendar.current
           someDateTime = userCalendar.date(from: dateComponents)
           endPicker.date = someDateTime!
           
           startTime.delegate = self
           let startToolBar = UIToolbar()
           startToolBar.barStyle = UIBarStyle.default
           startToolBar.isTranslucent = true
           startToolBar.tintColor = UIColor.black
           startToolBar.sizeToFit()
           let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(hourAvailabilityVC.donePicker))
           let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
           startToolBar.setItems([ spaceButton, doneButton], animated: false)
           startToolBar.isUserInteractionEnabled = true
           
           let endToolBar = UIToolbar()
           endToolBar.barStyle = UIBarStyle.default
           endToolBar.isTranslucent = true
           endToolBar.tintColor = UIColor.black
           endToolBar.sizeToFit()
           let endDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(hourAvailabilityVC.endDonePicker))
           let endSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
           endToolBar.setItems([ endSpaceButton, endDoneButton], animated: false)
           endToolBar.isUserInteractionEnabled = true
           
           startTime.inputView = startPicker
           startTime.inputAccessoryView = startToolBar
           endTime.inputView = endPicker
           endTime.inputAccessoryView = endToolBar

}
    
    // MARK:- Properties



        override func viewDidAppear(_ animated: Bool) {
        checkExisting()
        }
         
         func updateDateDetailLabel(date: Date){
             formatter.dateFormat = "MMMM dd, yyyy"
            formatter.locale = Locale(identifier: "en")
             dateLabel.text = formatter.string(from: date)
         }
         

        // MARK: - Table view data source
          
        func numberOfSections(in tableView: UITableView) -> Int {
         return 1
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.TimeSlotList.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = SchedultableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! showAvailabilityCell
         
         cell.dateLabel.text = TimeSlotList[indexPath.row].time
         cell.slotsLabel.text = "\(TimeSlotList[indexPath.row].slot)"
         return cell
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let service1 = TimeSlotList[indexPath.row]

        let alertController = UIAlertController(title: service1.time, message: "Are you sure you want to delete this time", preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (_) in
            self.deleteClass(id: service1.time)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }

        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)


        present(alertController, animated: true, completion: nil)

    }

func deleteClass(id:String){
    guard let uid = Auth.auth().currentUser?.uid else {return}
    Database.database().reference().child("stores").child("Allbuisness").child(typeString).child(uid).child("mySchedule").child("Hour").child(self.keyString).child("dates").child(selectedDate).child(id).setValue(nil)

    Database.database().reference().child("Services").child(self.CountryString).child(self.cityString).child(typeString).child(self.venueID).child("mySchedule").child("Hour").child(self.keyString).child("dates").child(selectedDate).child(id).setValue(nil)
    getAllTimeSlots()
}

  



// MARK:- Calendar view Data Source
func handleCellSelected(view: JTACDayCell?, cellState: CellState) {
      guard let validCell = view as? HourCelendarCell else { return }
      if validCell.isSelected {
          validCell.selectedView.isHidden = false
      } else {
          validCell.selectedView.isHidden = true
      }
  }
  
  func handleCellTextColor(view: JTACDayCell?, cellState: CellState) {
      guard let validCell = view as? HourCelendarCell else {
          return
      }
      
      if validCell.isSelected {
          validCell.dateLabel.textColor = selectedMonthColor
      } else {
          if cellState.dateBelongsTo == .thisMonth {
              validCell.dateLabel.textColor = monthColor
          } else {
              validCell.dateLabel.textColor = outsideMonthColor
          }
      }
  }
  
  func setupViewsFromCalendar(from visibleDates: DateSegmentInfo ) {
      guard let date = visibleDates.monthDates.first?.date else { return }
      
      formatter.dateFormat = "MMMM dd, yyyy"
    formatter.locale = Locale(identifier: "en")
      dateLabel.text = formatter.string(from: date)
      calendarView.selectDates( [date] )
      updateDateDetailLabel(date: date)
  }
  
  func setupCalendarView() {
      // Setup Calendar Spacing
      calendarView.minimumLineSpacing = 0
      calendarView.minimumInteritemSpacing = 0
      
      // Setup Labels
      calendarView.visibleDates{ (visibleDates) in
          self.setupViewsFromCalendar(from: visibleDates)
      }
  }
  

  func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
      
      dateFormatter.dateFormat = "yyyy-M-d"
    dateFormatter.locale = Locale(identifier: "en")
      
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
  
  
  func fullDayPredicate(for date: Date) -> NSPredicate {
      var calendar = Calendar.current
      calendar.timeZone = NSTimeZone.local
      
      let dateFrom = calendar.startOfDay(for: date)
      var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dateFrom)
      components.day! += 1
      let dateTo = calendar.date(from: components)
      let datePredicate = NSPredicate(format: "(%@ <= date) AND (date < %@)", argumentArray: [dateFrom, dateTo as Any])
      
      return datePredicate
  }
  
  func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    handleCellSelected(view: cell, cellState: cellState)
    handleCellTextColor(view: cell, cellState: cellState)
  }
  
  
  func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
      let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "Cell",for: indexPath) as! HourCelendarCell
      
      cell.dateLabel.text = cellState.text
      
      handleCellSelected(view: cell, cellState: cellState)
      handleCellTextColor(view: cell, cellState: cellState)
              
      return cell
  }
  
  func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
      
      handleCellSelected(view: cell, cellState: cellState)
      handleCellTextColor(view: cell, cellState: cellState)
      updateDateDetailLabel(date: date)
      loadAppointmentsForDate(date: date)
      let dateFormat = DateFormatter()
      dateFormat.dateFormat = "yyyy-M-d"
    dateFormat.locale = Locale(identifier: "en")
      self.selectedDate = dateFormat.string(from: date)
      self.getAppointmentForDay(dateEntered: date)
  }
  
  func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
      
      handleCellSelected(view: cell, cellState: cellState)
      handleCellTextColor(view: cell, cellState: cellState)
      
  }
  
  func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
      if appointmentScrolled {
          setupViewsFromCalendar(from: visibleDates)
      }
  }



// MARK:- Properties
//properties
  @objc func donePicker() {
      
      let date = startPicker.date
      let dateFormat = DateFormatter()
      dateFormat.dateFormat = "M-dd-yyyy"
    dateFormat.locale = Locale(identifier: "en")
      let calendar = Calendar.current
      let comp = calendar.dateComponents([.hour, .minute], from: date)
      let hour = comp.hour
      let minute = comp.minute
      let times = String(hour!) + ":" + String(minute!)
      startTime.text = times
      view.endEditing(true)
  }
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.view.endEditing(true)
  }
  
  @objc func endDonePicker() {
      let date = endPicker.date
      let dateFormat = DateFormatter()
      dateFormat.dateFormat = "M-dd-yyyy"
    dateFormat.locale = Locale(identifier: "en")

      let calendar = Calendar.current
      let comp = calendar.dateComponents([.hour, .minute], from: date)
      let hour = comp.hour
      let minute = comp.minute
      let times = String(hour!) + ":" + String(minute!)
      endTime.text = times
      view.endEditing(true)
  }
  
  func dateToString(date : Date) -> String{
      let date = date
      let dateFormat = DateFormatter()
      dateFormat.dateFormat = "M-dd-yyyy"
    dateFormat.locale = Locale(identifier: "en")

      let calendar = Calendar.current
      let comp = calendar.dateComponents([.hour, .minute], from: date)
      let hour = comp.hour
      let minute = comp.minute
      let times = String(hour!) + ":" + String(minute!)
      return times
  }
  
  
  func showAlert(_ title1: String,_ message : String,_ title2: String ){
      let alertController = UIAlertController(title: title1, message: message, preferredStyle: UIAlertController.Style.actionSheet)
      alertController.addAction(UIAlertAction(title: title2, style: UIAlertAction.Style.default, handler: nil))
      self.present(alertController, animated: true, completion: nil)
  }
  
   func getAppointmentForDay(dateEntered: Date){
        
//            getAllTimeSlots()
    checkExisting()
    }
    
    
    //calendar
    func loadAppointmentsForDate(date: Date){
//        getAllTimeSlots(keyDate)
    }
    
    
    public func getKeyString(time: String){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("stores").child("Allbuisness").child(typeString).child(uid).child("mySchedule").child("Hour").observeSingleEvent(of: .value, with: { (snapShot) in
           if let snapDict = snapShot.value as? [String:AnyObject]{
            for each in snapDict{
                let userEmail = each.value["venueName"] as! String
                if(userEmail == self.name)
                {
                        self.keyString = each.key
                        self.setTimeSlots(time: time)
                    }
                }
            }
        })
    }

public func getKeyString2(time: String){
     guard let uid = Auth.auth().currentUser?.uid else {return}
    Database.database().reference().child("stores").child("Allbuisness").child(typeString).child(uid).child("mySchedule").child("Hour").observeSingleEvent(of: .value, with: { (snapShot) in
        if let snapDict = snapShot.value as? [String:AnyObject]{
         for each in snapDict{
             let userEmail = each.value["venueName"] as! String
             if(userEmail == self.name)
             {
                     self.keyString = each.key
                     self.setTimeSlots2(time: time)
                 }
             }
         }
     })
 }
    
    func offsetFrom(startDate: Date, endDate : Date) -> String {
    
    let previousDate = startDate
    let now = endDate
    let formatter = DateComponentsFormatter()
    var calendar = Calendar.current
    calendar.locale = Locale(identifier: "en")
    formatter.calendar = calendar
    formatter.unitsStyle = .full
    formatter.allowedUnits = [.minute, .second]
    formatter.maximumUnitCount = 2
    
    let string = formatter.string(from: previousDate, to: now)
    return string!
   
}
    
    func getDateString(date: Date) -> String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-M-dd"
        dateFormat.locale = Locale(identifier: "en")
        return dateFormat.string(from: date)
        
}
    
    
    
    /////1
    
    func getStoreType() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("All").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            
            let dictionaries = snapshot.value as? NSDictionary
            
            self.cityString = dictionaries?["city"] as! String
            self.CountryString = dictionaries?["country"] as! String
            self.type = dictionaries?["businessType"] as? String ?? ""

            print(self.cityString)
            
        }
    }
    
    
    /////2
    
    func checkExisting() {
        self.TimeSlotList.removeAll()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("stores").child("Allbuisness").child(typeString).child(uid).child("mySchedule").child("Hour").observeSingleEvent(of: .value, with: { (snapShot) in
            print(snapShot)
            if let snapDict = snapShot.value as? [String:AnyObject]{
                for each in snapDict{
                    let userEmail = each.value["venueName"] as! String
                    if(userEmail == self.name)
                    {
                        self.keyString = each.key
                        self.getAllTimeSlots()
                    }
                }
                //self.setTimeSlot()
            }
        })
        return;
    }
    
    
    
    /////3
    
    
    func setTimeSlots(time :String){
        guard let uid = Auth.auth().currentUser?.uid else {return}

        var timeString = time.components(separatedBy: " ")
        let minutes = Int(timeString[0])
        let noOfSlots = minutes!/60
        var val = 2
//            if Numslots.text != ""{
//                val = Int(Numslots.text!)!
//            }
        let date = self.startPicker.date
        //        let dateFormat = DateFormatter()
        //        dateFormat.dateFormat = "yyyy mm dd"
        //        self.dateString = dateFormat.string(from: date)
        //        dateLabel.text = self.dateString
        
        
        if(noOfSlots>0){
            for i in 0...noOfSlots-1{
                let newTime = date.addingTimeInterval(60 * 60 * Double(i))
                Database.database().reference().child("stores").child("Allbuisness").child(typeString).child(uid).child("mySchedule").child("Hour").child(self.keyString).child("dates").child(selectedDate).child(dateToString(date: newTime)).setValue("Available")
                
               
//                    Database.database().reference().child("VenuesCalendar").child("Hour").child(self.keyString).child("dates").child(selectedDate).child(dateToString(date: newTime)).setValue("Available")
                
                Database.database().reference().child("Services").child(self.CountryString).child(self.cityString).child(typeString).child(self.venueID).child("mySchedule").child("Hour").child(self.keyString).child("dates").child(selectedDate).child(dateToString(date: newTime)).setValue("Available")
                    
                    self.showAlert("Success","Time Slots Added for day " + "\(selectedDate)" , "Dismiss")

            }
            self.SchedultableView.reloadData()
        }
        self.checkExisting()
        self.showAlert("Success","Time Slots Added for day " + "\(selectedDate)" , "Dismiss")
    }

func setTimeSlots2(time :String){
    guard let uid = Auth.auth().currentUser?.uid else {return}

    var timeString = time.components(separatedBy: " ")
    let minutes = Int(timeString[0])
    let noOfSlots = minutes!/30
    var val = 2

    let date = self.startPicker.date
    
    if(noOfSlots>0){
        for i in 0...noOfSlots-1{
            let newTime = date.addingTimeInterval(60 * 60 * Double(i))
            Database.database().reference().child("stores").child("Allbuisness").child(typeString).child(uid).child("mySchedule").child("Hour").child(self.keyString).child("dates").child(selectedDate).child(dateToString(date: newTime)).setValue(nil)
            
            
            Database.database().reference().child("Services").child(self.CountryString).child(self.cityString).child(typeString).child(self.venueID).child("mySchedule").child("Hour").child(self.keyString).child("dates").child(selectedDate).child(dateToString(date: newTime)).setValue(nil)
                
                self.showAlert("Success","Time Slots deleted for day " + "\(selectedDate)" , "Dismiss")
        }
        self.SchedultableView.reloadData()
    }
    self.checkExisting()
    self.showAlert("Success","Time Slots deleted for day " + "\(selectedDate)" , "Dismiss")

    
    
}
    
    
    /////4
    
    public func getAllTimeSlots(){
//            getKeyString(time: String)
        self.TimeSlotList.removeAll()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        print("started with keystring")
        print(selectedDate)
        print(keyString)
        Database.database().reference().child("stores").child("Allbuisness").child(typeString).child(uid).child("mySchedule").child("Hour").child(self.keyString).child("dates").child(selectedDate).observeSingleEvent(of: .value, with: { (snapShot) in
            let x = snapShot.value
            if x is NSNull
            {
                self.SchedultableView.reloadData()
                //                self.TimeSlotList.removeAll()
                let alertController = UIAlertController(title: "CAUTIONS", message: "PLEASE ADD AVAILABLE SLOT FOR THE DAY!", preferredStyle: UIAlertController.Style.actionSheet)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            if let snapDict = snapShot.value as? [String:AnyObject]{
                for each in snapDict{
                    let timeSlot = TimeSlot()
                    timeSlot.time = each.key
                    timeSlot.slot = each.value as! String
                    self.TimeSlotList.append(timeSlot)
                    self.TimeSlotList.sort { $0.time.compare($1.time, options: .numeric) == .orderedAscending }
                }
                self.SchedultableView.reloadData()
            }
        })
        
    }




// MARK:-Actions

@IBAction func confirmButtonPressed(_ sender: Any) {
    let time = offsetFrom(startDate: startPicker.date, endDate: endPicker.date)
    getKeyString(time: time)
//        getAllTimeSlots()
    self.TimeSlotList.removeAll()
    self.SchedultableView.reloadData()
}

@IBAction func deleteBtn(_ sender: Any) {
            let time = offsetFrom(startDate: startPicker.date, endDate: endPicker.date)
            getKeyString2(time: time)
    //        getAllTimeSlots()
            self.TimeSlotList.removeAll()
            self.SchedultableView.reloadData()
}



@IBAction func deleteSelectTimePressed(_ sender: Any) {
}


@IBAction func backArrow(_ sender: Any) {
    
    self.dismiss(animated: true, completion: nil)
}


}
