//
//  dayAvailabilityVC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 04/06/2021.
//

import JTAppleCalendar
import UIKit
import FirebaseAuth
import FirebaseDatabase


class VersionCalendarShowingCell2: JTACDayCell {
    @IBOutlet var dotView: UIView!
    @IBOutlet var selectedView: UIView!
    @IBOutlet var dateLabel: UILabel!
}

class monthDateHeader2: JTACMonthReusableView {
    @IBOutlet var monthTitle: UILabel!
}

class dayAvailabilityVC: UIViewController, UITableViewDataSource , UITableViewDelegate{

    
       //MARK:- Outlets
          
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var SchedultableView: UITableView!
       
       
      
             // MARK:- Variables
          var name: String = ""
       var typeString: String = "NULL"
       var cityString: String = "NULL"
       var CountryString: String = "NULL"
       var selectedShop:scheduleModel! {
           didSet {
               if selectedShop.venueName != nil {
                   name = selectedShop.venueName
               }
               
                if selectedShop.venueType != nil {
                   typeString = selectedShop.venueType
                }
           }
       }
      
          var dates = [Date]()
          var appointmentScrolled = false
          var keyDate:String = "NULL"
          var keyString:String = ""
          var dateString: String = ""
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
   //       let formatter = DateFormatter()
          var calendarViewHidden = true
          var selectedTime = ""
          var selectedDate = ""
          var endTimes = ""
          var selectedTimeSlot: Int = 0
          var timeSlots = [Date]()
          let currentDate = Date()
          var cardID: String!
          var priceID: String!
       
       var ref: DatabaseReference!
       var calendarDataSource: [String : String] = [:]
       var formatter: DateFormatter {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-M-d"
           formatter.locale = Locale(identifier: "en")
           return formatter
       }
       let monthFormatter = DateFormatter()
   //    var selectedDate : Date?

          override func viewDidLoad() {
              super.viewDidLoad()
           
           UIView.appearance().semanticContentAttribute = .forceLeftToRight

           
              calendarView.scrollDirection = .horizontal
              calendarView.scrollingMode = .stopAtEachCalendarFrame
              calendarView.showsHorizontalScrollIndicator = false
           
   //        populateDataSource()

           
           ref = Database.database().reference()
           
            checkExisting()
   //         selectedDate = formatter.date(from: "0000-00-01")
            monthFormatter.dateFormat = "MMMM"
           
       }
       
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
          
           let dateFormat = DateFormatter()
           if selectedDate != ""{
               dateFormat.dateFormat = "yyyy-M-d"
               dateFormat.locale = Locale(identifier: "en")
               dateFormat.date(from: selectedDate)
               print(selectedDate,"this date returned")
               calendarView.scrollToDate(dateFormat.date(from: selectedDate)!, animateScroll: false)
               calendarView.selectDates( [dateFormat.date(from: selectedDate)!] )
           }
       }
       
       
               func getStoreType() {
                   guard let uid = Auth.auth().currentUser?.uid else {return}
                   Database.database().reference().child("All").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                       print(snapshot)
                       
                       let dictionaries = snapshot.value as? NSDictionary
                       
       //                self.typeString = dictionaries?["ShopType"] as! String
                       self.cityString = dictionaries?["city"] as! String
                       self.CountryString = dictionaries?["country"] as! String
                       
       //                print(self.typeString)
                       print(self.cityString)
                       
                   }
               }
       
       
       
       func checkExisting() {
           self.TimeSlotList.removeAll()
          guard let uid = Auth.auth().currentUser?.uid else {return}
        ref.child("stores").child("Allbuisness").child(typeString).child(uid).child("mySchedule").child("Day").observeSingleEvent(of: .value, with: { (snapShot) in
               print(snapShot)
               if let snapDict = snapShot.value as? [String:AnyObject]{
                   for each in snapDict{
                       let userEmail = each.value["venueName"] as! String
                       if(userEmail == self.name)
                       {
                           self.keyString = each.key
                           self.getAllTimeSlots()
                           print(self.keyString, "-- init")
                           return;
                       }
                   }
                   //self.setTimeSlot()
               }
               else{
                   // self.setTimeSlot()
               }
           })
           return;
       }
       
       func checkExisting2() {
           self.TimeSlotList.removeAll()
          guard let uid = Auth.auth().currentUser?.uid else {return}
        ref.child("stores").child("Allbuisness").child(typeString).child(uid).child("mySchedule").child("Day").observeSingleEvent(of: .value, with: { (snapShot) in
               print(snapShot)
               if let snapDict = snapShot.value as? [String:AnyObject]{
                   for each in snapDict{
                       let userEmail = each.value["venueName"] as! String
                       if(userEmail == self.name)
                       {
                           self.keyString = each.key
                           self.getAllTimeSlots2()
                           print(self.keyString, "-- init")
                           return;
                       }
                   }
                   //self.setTimeSlot()
               }
               else{
                   // self.setTimeSlot()
               }
           })
           return;
       }


       /////3
              func getAllTimeSlots(){
                  self.TimeSlotList.removeAll()
                  guard let uid = Auth.auth().currentUser?.uid else {return}
       //            guard let uid = Auth.auth().currentUser?.uid else {return}
                  print("started with keystring")
                  print(selectedDate)
                  print(keyString)
                ref.child("stores").child("Allbuisness").child(typeString).child(uid).child("mySchedule").child("Day").child(self.keyString).child("dates").observeSingleEvent(of: .value, with: { (snapShot) in
                   print(snapShot)
                      let x = snapShot.value
                      if x is NSNull
                      {
                          self.SchedultableView.reloadData()
                          //                self.TimeSlotList.removeAll()
                          let alertController = UIAlertController(title: "CAUTIONS", message: "PLEASE ADD SPOT FOR THESE DAYS!!", preferredStyle: UIAlertController.Style.actionSheet)
                          alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))

                          self.present(alertController, animated: true, completion: nil)
                      }

                      if let snapDict = snapShot.value as? [String:AnyObject]{
                          for each in snapDict{

                           let datez = each.key as? String
                           self.calendarDataSource[datez!] = ""
                           print(self.calendarDataSource)
                          }
                           self.calendarView.reloadData()
                      }
                  })


              }

                      public func getAllTimeSlots2(){
                     self.TimeSlotList.removeAll()
                     guard let uid = Auth.auth().currentUser?.uid else {return}
          //            guard let uid = Auth.auth().currentUser?.uid else {return}
                     print("started with keystring")
                     print(selectedDate)
                     print(keyString)
                        ref.child("stores").child("Allbuisness").child(typeString).child(uid).child("mySchedule").child("Day").child(self.keyString).child("dates").observeSingleEvent(of: .value, with: { (snapShot) in
                      print(snapShot)

                         if let snapDict = snapShot.value as? [String:AnyObject]{
                             for each in snapDict{
                               
                               let times = each.key

                               if (times != self.selectedDate) {

                                   
                               } else if (times == self.selectedDate) {
                                   
                                   let timeSlot = TimeSlot()
                                     timeSlot.time = self.selectedDate
                                     timeSlot.slot = each.value as! String
                                     self.TimeSlotList.append(timeSlot)
                                     self.TimeSlotList.sort { $0.time.compare($1.time, options: .numeric) == .orderedAscending }
                               }
                               self.SchedultableView.reloadData()
                             }
                           

                       }
                       
                     })


                 }


       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.view.endEditing(true)
       }

            func dateToString(date : Date) -> String{
                let date = date
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "MM-dd-yyyy"
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
              checkExisting2()
              }
       
       @IBAction func backArrowPressed(_ sender: Any) {
           self.dismiss(animated: true, completion: nil)
       }
       @IBAction func addingPressed(_ sender: Any) {
           
           self.performSegue(withIdentifier: "Addingn", sender: selectedShop)
       }
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                   if segue.identifier == "Addingn" {
               if let selectedPhone = sender as? scheduleModel,
                   let destinationVC = segue.destination as? dayAvailability2VC {
                   destinationVC.selectedShop = selectedPhone
               }
           }
       }
       
       

      // MARK: - Table view data source
        
               func numberOfSections(in tableView: UITableView) -> Int {
                   return 1
               }

               func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                   return TimeSlotList.count
               }

               func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                   let cell = SchedultableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! showAvailabilityCell
                   
                   cell.dateLabel.text = TimeSlotList[indexPath.row].time
                   cell.slotsLabel.text = "\(TimeSlotList[indexPath.row].slot)"
                   return cell
               }

        
      
      
      
      // MARK:- Calendar view Data Source
       

       func configureCell(view: JTACDayCell?, cellState: CellState) {
           guard let cell = view as? VersionCalendarShowingCell2  else { return }
           cell.dateLabel.text = cellState.text
           handleCellTextColor(cell: cell, cellState: cellState)
           handleCellEvents(cell: cell, cellState: cellState)
           handleCellSelected(cell: cell, cellState: cellState)
       }
           func handleCellSelected(cell: VersionCalendarShowingCell2, cellState: CellState) {
                 if cell.isSelected {
                     cell.selectedView.isHidden = false
                   cell.dateLabel.textColor = UIColor.white
                 } else {
                     cell.selectedView.isHidden = true
                 }
             }
       
       
       func handleCellEvents(cell: VersionCalendarShowingCell2, cellState: CellState) {
                  let dateString = formatter.string(from: cellState.date)
           
                   
           
                  if calendarDataSource[dateString] == nil {
                      cell.dotView.isHidden = true
                  } else {
                      cell.dotView.isHidden = false
                  }
              }

          func handleCellTextColor(cell: VersionCalendarShowingCell2, cellState: CellState) {
              if cellState.dateBelongsTo == .thisMonth {
                  cell.dateLabel.textColor = UIColor.darkGray
              } else {
                  cell.dateLabel.textColor = UIColor.white
              }
          }
       
       func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
           return MonthSize(defaultSize: 50)
       }
       
   }
       
   extension dayAvailabilityVC: JTACMonthViewDataSource {
       
       func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-M-d"
           dateFormatter.timeZone = Calendar.current.timeZone
           dateFormatter.locale = Locale(identifier: "en")

                         
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

   extension dayAvailabilityVC: JTACMonthViewDelegate {
       
       func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
           let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell",for: indexPath) as! VersionCalendarShowingCell2
           self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
           
           if cellState.dateBelongsTo != . thisMonth {
               
               cell.isHidden = true
           } else {
               
               cell.isHidden = false
           }
                   
           return cell
       }
       
       
       
       func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
           configureCell(view: cell, cellState: cellState)
       }
       
       func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
            let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! monthDateHeader2
             header.monthTitle.text = monthFormatter.string(from: range.start)
            return header
         
         }
       
       func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {

   //        selectedDate = date
           configureCell(view: cell, cellState: cellState)
           let dateFormat = DateFormatter()
           dateFormat.dateFormat = "yyyy-M-d"
           dateFormat.locale = Locale(identifier: "en")
           self.selectedDate = dateFormat.string(from: date)
           self.getAppointmentForDay(dateEntered: date)
           
        }
        func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
            configureCell(view: cell, cellState: cellState)
        }

       

   }
      
        
