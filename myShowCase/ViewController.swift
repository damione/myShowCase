//
//  ViewController.swift
//  myShowCase
//
//  Created by Damion Hanson on 2016-04-11.
//  Copyright © 2016 Damion Hanson. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func loginBtnPressed(sender: UIButton) {
        
        if let email = emailText.text where email != "", let pwd = passwordText.text where pwd != "" {
            
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { (error, authData) in
                
                if error != nil {
                    print(error)
                    
                    if error.code == STATUS_ACCOUNT_NONEXIST {
                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { error, result in
                            
                            if error != nil {
                                self.showErrorAlert("Could not create account", msg: "Error creating account. Please try again later or try something else!")
                            } else {
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                
                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: {
                                    err, authData in
                                    
                                   // let user = ["provider": authData.provider!, "demotester":"tested!"]
                                    //DataService.ds.creatFirebaseUser(authData.uid, user: user)
                                    
                                })
                                
                                self.performSegueWithIdentifier(LOGGED_IN_SEGUE, sender: nil)
                            }
                        })
                    } else {
                        
                        self.showErrorAlert("Could not login!", msg: "Please verify your email and password and retry!")
                    }
                } else {
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        
                        self.performSegueWithIdentifier(LOGGED_IN_SEGUE, sender: nil)
                }
            })
            
        } else {
            
            showErrorAlert("Blank Fields", msg: "Please enter an email address and password!")
        }
    }
    
    @IBAction func fbBtnPressed(){
        let fbLogin = FBSDKLoginManager()
        
        fbLogin.logInWithReadPermissions(["email"], fromViewController: self) { (fbResult: FBSDKLoginManagerLoginResult!, fbError: NSError!) in
        
        //fbLogin.logInWithReadPermissions(["email"]) { (fbResult: FBSDKLoginManagerLoginResult!, fbError: NSError!) -> Void in
            if fbError != nil {
                print("Facebook login failed. Error: \(fbError)")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Facebook signon successful!")
                
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken!, withCompletionBlock: { (error, authData) in
                    
                    if error != nil {
                        print("Error with login. \(error)")
                    } else {
                        print("Login Successful! \(authData)")
                        
                        //let user = ["provider": authData.provider!, "Ray ray":"testn it out"]
                        //DataService.ds.creatFirebaseUser(authData.uid, user: user)
                        
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        
                        self.performSegueWithIdentifier(LOGGED_IN_SEGUE, sender: nil)
                    }
                })
            }
        }
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(LOGGED_IN_SEGUE, sender: nil)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

