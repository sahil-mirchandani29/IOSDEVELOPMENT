//
//  UserDetailsViewController.swift
//  WeScan
//
//  Created by Sahil Mirchandani on 7/17/20.
//  Copyright © 2020 Sahil Mirchandani. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

class UserDetailsViewController: UIViewController {

    @IBOutlet weak var NameTitle: UILabel!
    @IBOutlet weak var emailTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        NameTitle.text = DriveFunctions.userName
        emailTitle.text = DriveFunctions.userEmail
        print("inUserDetails")
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        print("logOutPressed")
        GIDSignIn.sharedInstance()?.signOut()
        performSegue(withIdentifier: "LogOut", sender: self)
        
    }
}
