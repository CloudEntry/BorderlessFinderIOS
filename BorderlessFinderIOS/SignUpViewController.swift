//
//  SignUpViewController.swift
//  BorderlessFinderIOS
//
//  Created by Jack Gee on 04/01/2020.
//  Copyright © 2020 computerscience. All rights reserved.
//

import UIKit

var nameOfUser = ""

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signup(_ sender: Any) {
        nameOfUser = firstNameField.text!
        // prepare json data
        let json: [String: Any] = ["email": emailField.text!,
                                   "password":passwordField.text!,
                                   "first_name":firstNameField.text!,
                                   "surname":surnameField.text!]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        // create post request
        let url = URL(string: "http://localhost:5000/api/v1.0/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
    }
}
