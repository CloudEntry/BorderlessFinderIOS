//
//  ProfileViewController.swift
//  BorderlessFinderIOS
//
//  Created by Jack Gee on 04/01/2020.
//  Copyright © 2020 computerscience. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var welcomeMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeMessage.text = "Welcome, \(nameOfUser)!"
    }
}
