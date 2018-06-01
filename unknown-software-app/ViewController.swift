//
//  ViewController.swift
//  unknown-software-app
//
//  Created by Matan Amoyal on 5/30/18.
//  Copyright © 2018 Matan Amoyal. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if FBSDKAccessToken.current() != nil {
            // User is logged in, do work such as go to next view controller.
        }
        // Do any additional setup after loading the view, typically from a nib.
        let loginButton = FBSDKLoginButton()
        // Optional: Place the button in the center of your view.
        loginButton.center = view.center
        loginButton.readPermissions = ["public_profile", "email"]
        view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
