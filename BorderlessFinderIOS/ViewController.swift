//
//  ViewController.swift
//  BorderlessFinderIOS
//
//  Created by Jack Gee on 13/12/2019.
//  Copyright © 2019 computerscience. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var calendar: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let Months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    let DaysOfMonth = ["Monday","Thuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    var DaysInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonth = String()
    var NumberOfEmptyBox = Int()
    var NextNumberOfEmptyBox = Int()
    var PreviousNumberOfEmptyBox = 0
    var Direction = 0
    var PositionIndex = 0
    var LeapYearCounter = (year % 4)
    var dayCounter = 0
    var highlightDate = -1
    var dateString = ""
    
    var events = [("","","","","","")]
    var eventsOnDay = [("","","","","","")]
    var selectedEvent = ("","","","","","")
    
    var new_events = [("","","","","","")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentMonth = Months[month]
        monthLabel.text = "\(currentMonth) \(year)"
        if weekday == 0 {
            weekday = 7
        }
        eventsOnDay.removeAll()
        GetStartDateDayPosition()
        fetchEvents()
        do {
            usleep(1000000)
        }
        events = new_events
        print(new_events)
        // section below allows automatic reloading of events -- commented out to run on pythonanywhere
//        DispatchQueue.global(qos: .background).async {
//            while(true) {
//                do {
//                    sleep(1)
//                }
//                self.new_events.removeAll()
//                do {
//                    usleep(100000)
//                }
//                self.fetchEvents()
//                DispatchQueue.main.async {
//                    self.events.removeAll()
//                    do {
//                        usleep(100000)
//                    }
//                    self.events = self.new_events
//                }
//            }
//        }
    }
    
    //--------------(Calculates the number of "empty" boxes at the start of every month")------------------------------------------
    
    func GetStartDateDayPosition() {
        switch Direction{
        case 0:
            NumberOfEmptyBox = weekday
            dayCounter = day
            while dayCounter>0 {
                NumberOfEmptyBox = NumberOfEmptyBox - 1
                dayCounter = dayCounter - 1
                if NumberOfEmptyBox == 0 {
                    NumberOfEmptyBox = 7
                }
            }
            if NumberOfEmptyBox == 7 {
                NumberOfEmptyBox = 0
            }
            PositionIndex = NumberOfEmptyBox
        case 1...:
            NextNumberOfEmptyBox = (PositionIndex + DaysInMonths[month])%7
            PositionIndex = NextNumberOfEmptyBox
            
        case -1:
            PreviousNumberOfEmptyBox = (7 - (DaysInMonths[month] - PositionIndex)%7)
            if PreviousNumberOfEmptyBox == 7 {
                PreviousNumberOfEmptyBox = 0
            }
            PositionIndex = PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    //-----------------------------------------------(Next and back buttons)-------------------------------------------------------
    
    @IBAction func Next(_ sender: Any) {
        highlightDate = -1
        switch currentMonth {
        case "December":
            Direction = 1
            
            month = 0
            year += 1
            
            if LeapYearCounter  < 5 {
                LeapYearCounter += 1
            }
            
            if LeapYearCounter == 4 {
                DaysInMonths[1] = 29
            }
            
            if LeapYearCounter == 5{
                LeapYearCounter = 1
                DaysInMonths[1] = 28
            }
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            
            calendar.reloadData()
        default:
            Direction = 1
            
            GetStartDateDayPosition()
            
            month += 1
            
            currentMonth = Months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            
            calendar.reloadData()
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        highlightDate = -1
        switch currentMonth {
        case "January":
            Direction = -1
            
            month = 11
            year -= 1
            
            if LeapYearCounter > 0{
                LeapYearCounter -= 1
            }
            if LeapYearCounter == 0{
                DaysInMonths[1] = 29
                LeapYearCounter = 4
            }else{
                DaysInMonths[1] = 28
            }
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            calendar.reloadData()
            
        default:
            Direction = -1
            
            month -= 1
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            calendar.reloadData()
        }
    }
    
    
    //----------------------------------(CollectionView)------------------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Direction{
        case 0:
            return DaysInMonths[month] + NumberOfEmptyBox
        case 1...:
            return DaysInMonths[month] + NextNumberOfEmptyBox
        case -1:
            return DaysInMonths[month] + PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor = UIColor.clear
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 1.5
        
        cell.dateLabel.textColor = UIColor.black
        
        if cell.isHidden{
            cell.isHidden = false
        }
        
        var cellDate = -1
        switch Direction {      //the first cells that needs to be hidden (if needed) will be negative or zero so we can hide them
        case 0:
            cellDate = indexPath.row + 1 - NumberOfEmptyBox
        case 1:
            cellDate = indexPath.row + 1 - NextNumberOfEmptyBox
        case -1:
            cellDate = indexPath.row + 1 - PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
        
        // get number of events per date to show in cell
        var count = 0
        let m: Int = month + 1
        var monthStr: String = String(m)
        if m < 10 { monthStr = "0" + monthStr }
        var cellDateStr: String = String(cellDate)
        if cellDate < 10 { cellDateStr = "0" + cellDateStr }
        dateString = "\(year)-\(monthStr)-\(cellDateStr)"
        for event in events {
            if event.4 == dateString {
                count += 1
            }
        }
        let ecDots = String(repeating: "°", count: count)
        cell.dateLabel.text = "\(cellDate) \(ecDots)"
        
        if cellDate < 1{ //here we hide the negative numbers or zero
            cell.isHidden = true
        }
        
        switch indexPath.row { //weekend days color
        case 5,6,12,13,19,20,26,27,33,34:
            if cellDate > 0 {
                cell.dateLabel.textColor = UIColor.lightGray
            }
        default:
            break
        }
        if currentMonth == Months[Calendar.current.component(.month, from: date) - 1] && year == Calendar.current.component(.year, from: date) && indexPath.row + 1 - NumberOfEmptyBox == day{
            cell.dateLabel.textColor = UIColor.red
            
        }
        
        if highlightDate == indexPath.row {
            cell.layer.borderColor = UIColor.blue.cgColor
        }
        
        return cell
    }
    
    // interacting with cells in collection view to return date
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        highlightDate = indexPath.row
        let date = highlightDate - PositionIndex + 1
        var m: Int = month + 1
        var monthStr: String = String(m)
        if m < 10 { monthStr = "0" + monthStr }
        var dateStr: String = String(date)
        if date < 10 { dateStr = "0" + dateStr }
        dateString = "\(year)-\(monthStr)-\(dateStr)"
        print(dateString)
        getEventsOnDay(date: dateString)
        collectionView.reloadData()
    }
    
    // ------------------------------------------------------------------------------------------

    func getEventsOnDay(date: String) {
        eventsOnDay.removeAll()
        for event in events {
            if event.4 == date {
                eventsOnDay.append(event)
            }
        }
        tableView.reloadData()
    }
    
    // ------------------------------------------------------------------------------------------
    
    func fetchEvents() {
        
        struct event: Decodable {
            let id: Int
            let name: String
            let society: String
            let type: String
            let location: String
            let date: String
            let time: String
        }

        struct eventsData: Decodable {
            let events: [event]
        }

        if let url = URL(string: "http://borderlessfinder.pythonanywhere.com/api/v1.0/events") {
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, err) in
                guard let jsonData = data else {
                    print("error")
                    return }
                do {
                    let decoder = JSONDecoder()
                    let thisEventsData = try decoder.decode(eventsData.self, from: jsonData)
                    var count = 0
                    for anEvent in thisEventsData.events {
                        count += 1
                        self.new_events.append((String(anEvent.id),anEvent.name,anEvent.society,anEvent.location,anEvent.date,anEvent.time))
                    }
                } catch let jsonErr {
                    print("Error decoding JSON", jsonErr)
                }
                }.resume()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsOnDay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "myCell")
        cell.textLabel!.text = "\(eventsOnDay[indexPath.row].1)"
        cell.detailTextLabel?.text = "\(eventsOnDay[indexPath.row].5) | \(eventsOnDay[indexPath.row].2)"
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEvent = eventsOnDay[indexPath.row]
        performSegue(withIdentifier: "toDetailView", sender: nil)
    }
    
    // send selected coffee shop to detail vc
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.selectedEvent = selectedEvent
        }
    }
}
