//
//  ViewController.swift
//  unknown-software-app
//
//  Created by Matan Amoyal on 5/30/18.
//  Copyright © 2018 Matan Amoyal. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    
    //var facebookUserFields = "x"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FBSDKAccessToken.current() != nil {
            // User is logged in, do work such as go to next view controller.
        }
        // Do any additional setup after loading the view, typically from a nib.
        let loginButton = FBSDKLoginButton()
        // Optional: Place the button in the center of your view.
        loginButton.delegate = self
        loginButton.center = view.center
        loginButton.readPermissions = ["public_profile", "email", "user_age_range", "user_gender","user_birthday"]
        view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        // marked the original if by matan: if let error = error {
        if error != nil {
            print(error.localizedDescription)
            return
        } else if result.isCancelled {
            print ("user press cancel")
        } else {
            // ...
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                if let error = error {
                    // ...
                    print(error.localizedDescription)
                    return
                }
                // User is signed in
                // ...
                
                if FBSDKAccessToken.current() != nil {
                    FBSDKGraphRequest(graphPath: "me", parameters:  ["fields": "id, name, first_name, last_name, email, gender, age_range,birthday"] ).start(completionHandler: { connection, result, error in
                        if error == nil {
                            if result != nil {
                                let fields = result as? [String:Any]
                                print(fields!["first_name"]!)
                                //self.facebookUserFields = fields!["first_name"]! as! String
                            }
                        }
                    })
                }


                let user = Auth.auth().currentUser
                if let user = user {
                    print("User is signed in")
                    // DataBase section
                    var ref: DatabaseReference!
                    ref = Database.database().reference()
                    ref.child("users").child(user.uid).setValue(["email": user.email!, "useruid": user.uid, "displayName": user.displayName!, "photoURL": "\(String(describing: user.photoURL))"])
                }
            }
        }
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        print("User Logged Out")
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton) -> Bool{
        return true
    }

}
