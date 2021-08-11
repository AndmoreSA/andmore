//
//  userAppointmetns1VC.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 08/06/2021.
//

import UIKit
import JTAppleCalendar
import UIKit
import FirebaseAuth
import FirebaseDatabase

class checkDayCalendarCell2: JTACDayCell {
    @IBOutlet var dotView: UIView!
    @IBOutlet var selectedView: UIView!
    @IBOutlet var dateLabel: UILabel!
}

class dateHearder2: JTACMonthReusableView {
    
    @IBOutlet var monthTitle: UILabel!
      
}

class userAppointmetns1VC: UIViewController, UITableViewDataSource , UITableViewDelegate  {

    
    
    
    // MARK:- Outlets
    @IBOutlet weak var appointmentTableView: UITableView!
    
    @IBOutlet weak var AppointmentcalendarView: JTACMonthView!
    
    
    
    // MARK:- Variables
       var name: String = ""
       var selectedShop:venueSearch?
    var selectedUser = [userAppointmentModel]()
       var dates = [Date]()
       var appointmentScrolled = false
       var keyDate:String = "NULL"
       var typeString: String = "NULL"
       var cityString: String = "NULL"
       var keyString:String = ""
    var keyString2:String = ""
       var dateString: String = ""
       let dateFormatter = DateFormatter()
       var selectedDates: [Date] = []
       let monthColor = UIColor.black
       let selectedViewColor = UIColor.blue
       let selectedTextColor = UIColor.white
       let currentDateSelectedViewColor = UIColor.darkGray
       let outsideMonthColor = UIColor.white
       let selectedMonthColor = UIColor.white
       var TimeSlotList = Array<TimeSlot>()
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

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarProperties()
        ref = Database.database().reference()
        getAllTimeSlots()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        let dateFormat = DateFormatter()
        if selectedDate != ""{
            dateFormat.dateFormat = "yyyy-M-d"
            dateFormatter.locale = Locale(identifier: "en")
            dateFormat.date(from: selectedDate)
            print(selectedDate,"this date returned")
            AppointmentcalendarView.scrollToDate(dateFormat.date(from: selectedDate)!, animateScroll: false)
            AppointmentcalendarView.selectDates( [dateFormat.date(from: selectedDate)!] )
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAllTimeSlots()
    }
    
    
    

    // MARK: - Properties
    
    func calendarProperties() {
        AppointmentcalendarView.scrollDirection = .horizontal
        AppointmentcalendarView.scrollingMode = .stopAtEachCalendarFrame
        AppointmentcalendarView.showsHorizontalScrollIndicator = false
        monthFormatter.dateFormat = "MMMM"
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
            getAllTimeSlots2()
         }


    
     func configureCell(view: JTACDayCell?, cellState: CellState) {
            guard let cell = view as? checkDayCalendarCell2  else { return }
            cell.dateLabel.text = cellState.text
            handleCellTextColor(cell: cell, cellState: cellState)
            handleCellEvents(cell: cell, cellState: cellState)
            handleCellSelected(cell: cell, cellState: cellState)
        }
    
        func handleCellSelected(cell: checkDayCalendarCell2, cellState: CellState) {
              if cell.isSelected {
                  cell.selectedView.isHidden = false
                cell.dateLabel.textColor = UIColor.white
              } else {
                  cell.selectedView.isHidden = true
              }
          }
    
        
        func handleCellEvents(cell: checkDayCalendarCell2, cellState: CellState) {
               let dateString = formatter.string(from: cellState.date)

               if calendarDataSource[dateString] == nil {
                   cell.dotView.isHidden = true
               } else {
                   cell.dotView.isHidden = false
               }
           }

           func handleCellTextColor(cell: checkDayCalendarCell2, cellState: CellState) {
               if cellState.dateBelongsTo == .thisMonth {
                   cell.dateLabel.textColor = UIColor.darkGray
               } else {
                   cell.dateLabel.textColor = UIColor.white
               }
           }
        
        func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
            return MonthSize(defaultSize: 50)
        }
    
    
    // MARK:- Other Properties



    func getAllTimeSlots(){
        self.TimeSlotList.removeAll()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        print("started with keystring")
        print(selectedDate)
        print(keyString)
        ref.child("users").child("profile").child(uid).child("myAppointments").observeSingleEvent(of: .value, with: { (snapShot) in
         print(snapShot)
            let x = snapShot.value
            if x is NSNull
            {
                self.appointmentTableView.reloadData()
                //                self.TimeSlotList.removeAll()
                let alertController = UIAlertController(title: "No Booking in this", message: "No Appointments schedule in this Day!", preferredStyle: UIAlertController.Style.actionSheet)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))

                self.present(alertController, animated: true, completion: nil)
            }

            if let snapDict = snapShot.value as? [String:AnyObject]{
                for each in snapDict{

                 let datez = each.key as? String
                 self.calendarDataSource[datez!] = ""
                 print(self.calendarDataSource)

                }
                 self.AppointmentcalendarView.reloadData()
            }
        })


    }

    public func getAllTimeSlots2(){
        self.selectedUser.removeAll()
        guard let uid = Auth.auth().currentUser?.uid else {return}
          print("started with keystring")
          print(selectedDate)
          print(keyString)
          print(keyString2)
        ref.child("users").child("profile").child(uid).child("myAppointments").child(selectedDate).observe(.value, with: { (snapShot) in
                
            print(snapShot)
                
            let x = snapShot.value
            if x is NSNull
            {
                self.appointmentTableView.reloadData()
                //                self.TimeSlotList.removeAll()
                let alertController = UIAlertController(title: "No Booking in this", message: "No Appointments schedule in this Day!", preferredStyle: UIAlertController.Style.actionSheet)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))

                self.present(alertController, animated: true, completion: nil)
                
                }
                
               if let snaps = snapShot.value as? [String:Any] {
                for each in snaps {
                let uid = each.key
                print(uid)
                self.venueShow2(string: uid)
                }
               }
          })
      }
    
    func venueShow2(string:String) {
         self.selectedUser.removeAll()
           guard let uid = Auth.auth().currentUser?.uid else {return}
           print("started with keystring")
           print(selectedDate)
           print(keyString)
         print(keyString2)
        
        ref.child("users").child("profile").child(uid).child("myAppointments").child(selectedDate).child(string).observe(.value, with: { (snapShot) in
              
              print(snapShot)
              
            guard let dict = snapShot.value as? [String:AnyObject] else {return}
            
            dict.forEach { (key,value) in
                let uidz = key
                
                Database.fetchUserithAppointmetn(uidUser: uid, selectedDate: self.selectedDate, uidShop: string, id: uidz) { (shop) in
                      self.selectedUser.append(shop)
                    
                    self.selectedUser.sort(by: { (post1, post2) -> Bool in
                        return post1.creationDate > post2.creationDate
                    })
                    
                    self.appointmentTableView.reloadData()
                }
            }
        })
            
    }

    
    
    
    // MARK: - Tableview data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = appointmentTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! myAppoitnments1Cell
        
        cell.UserSearches = selectedUser[indexPath.item]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedShop = selectedUser[indexPath.item]
        performSegue(withIdentifier: "toDetailed", sender: selectedShop)
        
    }
    
    
    // MARK: - CollectionView data Source

    
    
    
    
    
    
    // MARK: - Actions



}


extension userAppointmetns1VC: JTACMonthViewDataSource {
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d"
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

extension userAppointmetns1VC: JTACMonthViewDelegate {
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell",for: indexPath) as! checkDayCalendarCell2
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
         let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! dateHearder2
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

