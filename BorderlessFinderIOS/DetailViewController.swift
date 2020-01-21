//
//  DetailViewController.swift
//  BorderlessFinderIOS
//
//  Created by Jack Gee on 15/12/2019.
//  Copyright © 2019 computerscience. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var socLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var myMap: MKMapView!
    
    var selectedEvent = ("","","","","","")

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = selectedEvent.1
        socLabel.text = selectedEvent.2
        locationLabel.text = selectedEvent.3
        dateLabel.text = selectedEvent.4
        timeLabel.text = selectedEvent.5
        fetchEventDetail()
    }
    
    func fetchEventDetail() {
        struct eventDetail: Decodable {
            let description: String
            let lat: String
            let lon: String
            let url: String
        }

        struct eventData: Decodable {
            let event: [eventDetail]
        }

        if let url = URL(string: "http://localhost:5000/api/v1.0/events/info/\(selectedEvent.0)") {
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, err) in
                guard let jsonData = data else {
                    print("error")
                    return }
                do {
                    let decoder = JSONDecoder()
                    let thisEventData = try decoder.decode(eventData.self, from: jsonData)
                    DispatchQueue.main.async {
                        self.descLabel.text = thisEventData.event[0].description
                        self.plotMap(lat: thisEventData.event[0].lat, lon: thisEventData.event[0].lon)
                    }
                } catch let jsonErr {
                    print("Error decoding JSON", jsonErr)
                }
                }.resume()
        }
    }
    
    func plotMap(lat: String, lon: String) {
        let latDelta: CLLocationDegrees = 0.002
        let lonDelta: CLLocationDegrees = 0.002
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lon)!)
        let region = MKCoordinateRegion(center: location, span: span)
        self.myMap.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lon)!)
        myMap.addAnnotation(annotation)
    }
}
