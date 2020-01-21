//
//  SavedEventsViewController.swift
//  BorderlessFinderIOS
//
//  Created by Jack Gee on 27/12/2019.
//  Copyright © 2019 computerscience. All rights reserved.
//

import UIKit
import CoreData

class SavedEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext?
    
    var events = [[String : String]()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        events.remove(at: 0)
        // retrieve
        context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Events")
        request.sortDescriptors?.append(NSSortDescriptor(key: "name", ascending: true))
        request.returnsObjectsAsFaults = false
        do {
            let results = try context?.fetch(request)
            if (results?.count)! > 0 { // if there's at least one
                for result in results! { // iterate over rows and add to places array
                    let event = result as! Events
                    events.append(["name": event.name!, "location": event.location!, "date": event.date!, "time": event.time!])
                }
            } else {
                print("No results")
            }
        } catch {
            print("Couldn't fetch results")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "myCell")
        cell.textLabel?.text = events[indexPath.row]["name"]
        cell.detailTextLabel?.text = "\(events[indexPath.row]["location"] ?? "") | \(events[indexPath.row]["date"] ?? "") | \(events[indexPath.row]["time"] ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            events.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // delete
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Events")
            request.returnsObjectsAsFaults = false
            do {
                let results = try context?.fetch(request)
                let object = results![indexPath.row]
                context?.delete(object as! NSManagedObject)
                do {
                    try context?.save()
                    print("Saved")
                } catch {
                    print("there was an error deleting stuff")
                }
            } catch {
                print("couldn't fetch results")
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
