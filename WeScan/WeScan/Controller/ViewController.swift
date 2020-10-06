//
//  ViewController.swift
//  WeScan
//
//  Created by Sahil Mirchandani on 7/17/20.
//  Copyright © 2020 Sahil Mirchandani. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

class ViewController: UIViewController{
 
    let googleSignInButton = GIDSignInButton(frame: CGRect(x: 0.0, y: 0.0, width: 250.0, height: 50.0))
    var driveFunctions = DriveFunctions()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        googleSignInButton.center = view.center
        googleSignInButton.addTarget(self, action: #selector(onGoogleSignInButtonTap), for: .touchUpInside)
        view.addSubview(googleSignInButton)

          GIDSignIn.sharedInstance()?.delegate = self
          GIDSignIn.sharedInstance()?.uiDelegate = self
          GIDSignIn.sharedInstance()?.scopes = [kGTLRAuthScopeDrive]
          GIDSignIn.sharedInstance()?.signInSilently()
    }
    @objc private func onGoogleSignInButtonTap() {
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
               GIDSignIn.sharedInstance()?.signIn()
           }
    }
    deinit {
               self.googleSignInButton.removeFromSuperview()
           }
}

// MARK: - GIDSignInDelegate
extension ViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // A nil error indicates a successful login
        if error == nil{
            print(user.profile.name ?? "error")
            DriveFunctions.userName = user.profile.name
            DriveFunctions.userEmail = user.profile.email
            DriveFunctions.googleDriveService.authorizer = user.authentication.fetcherAuthorizer()
            DriveFunctions.googleUser = user
            driveFunctions.getFolders()
            driveFunctions.populateRootFolder(user: DriveFunctions.googleUser!, service: DriveFunctions.googleDriveService)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "LoggedIn", sender: self)
            }
        }
    }
}
