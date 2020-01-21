//
//  CreateEventViewController.swift
//  BorderlessFinderIOS
//
//  Created by Jack Gee on 27/12/2019.
//  Copyright © 2019 computerscience. All rights reserved.
//

import UIKit
import CoreData

class CreateEventViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var socField: UITextField!
    @IBOutlet weak var locField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var fromTimePicker: UIDatePicker!
    @IBOutlet weak var toTimePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        // get date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = datePicker.date
        let dateString = dateFormatter.string(from: date)
        
        // get time
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let fromTime = fromTimePicker.date
        let toTime = toTimePicker.date
        let timeString = "\(timeFormatter.string(from: fromTime))-\(timeFormatter.string(from: toTime))"
        
        // save to core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var context: NSManagedObjectContext?
        context = appDelegate.persistentContainer.viewContext
        let newEvent = NSEntityDescription.insertNewObject(forEntityName: "Events", into: context!) as! Events
        newEvent.setValue(nameField.text!, forKey: "name")
        newEvent.setValue(socField.text!, forKey: "society")
        newEvent.setValue(locField.text!, forKey: "location")
        newEvent.setValue(typeField.text!, forKey: "type")
        newEvent.setValue(descField.text!, forKey: "desc")
        newEvent.setValue(dateString, forKey: "date")
        newEvent.setValue(timeString, forKey: "time")
        do {
            try context?.save()
            print("Saved")
        } catch {
            print("There was an error")
        }

        // prepare json data
        let json: [String: Any] = [ "name": nameField.text!,
                                    "society": socField.text!,
                                    "location": locField.text!,
                                    "type": typeField.text!,
                                    "description": descField.text!,
                                    "date": dateString,
                                    "time": timeString]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        print(jsonData!)
//        // create post request
//        let url = URL(string: "http://localhost:5000/api/v1.0/events")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        // insert json data to the request
//        request.httpBody = jsonData
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                return
//            }
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            if let responseJSON = responseJSON as? [String: Any] {
//                print(responseJSON)
//            }
//        }
//        task.resume()
//        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done1(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func done2(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func done3(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func done4(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func done5(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}

extension Date {
    func add(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: Date())!
    }
}
