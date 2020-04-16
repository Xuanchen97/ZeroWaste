//
//  LoginViewController.swift
//  garbageSort
//
//  Created by Xcode User on 2020-04-11.
//  Copyright © 2020 Haoyue Wang. All rights reserved.
//
//  Description: This controller is about login. Get user name and password from SQLite
//               if it is zoe jason or saam they are the admin. After they login they will
//               redirect to table page
//  Author: Haoyue Wang

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var username : UITextField!
    @IBOutlet var pwd : UITextField!
    
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func login(sender : UIButton){
        
        for i in mainDelegate.people{
            
            if (username.text == i.name && pwd.text == i.pwd){
                if(username.text == "zoe" || username.text == "jason"  || username.text == "saam"){
                    self.performSegue(withIdentifier: "table", sender: nil)
                }
                else{
                    self.performSegue(withIdentifier: "home", sender: nil)
                }
                
                mainDelegate.loginFlag = true
                break
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainDelegate.readDataFromDB()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
