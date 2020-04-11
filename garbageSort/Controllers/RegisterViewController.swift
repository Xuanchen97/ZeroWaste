//
//  RegisterViewController.swift
//  garbageSort
//
//  Created by Xcode User on 2020-04-11.
//  Copyright © 2020 Xuanchen Liu. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    

    @IBOutlet var tfName : UITextField!
    @IBOutlet var tfPwd : UITextField!
    @IBOutlet var tfEmail : UITextField!
    
    @IBOutlet var lbBirth : UILabel!
    @IBOutlet var slAge : UISlider!
    @IBOutlet var lbAge : UILabel!
    @IBOutlet var datePicker : UIDatePicker!
    
    @IBOutlet var avatar1 : UIImageView!
    @IBOutlet var avatar2 : UIImageView!
    @IBOutlet var avatar3 : UIImageView!
    
    var cAvatar : String?
    var flyLayer : CALayer?
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func changeAge(){
        let age = slAge.value
        let strAge = String(format: "%.0f", age)
        lbAge.text = strAge
    }
    
    func changeBirth(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, YYYY"
        lbBirth.text = dateFormatter.string(from: datePicker.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch : UITouch = touches.first!
        let touchPoint : CGPoint = touch.location(in: self.view!)
        
        let avatar1Frame : CGRect = avatar1.frame
        let avatar2Frame : CGRect = avatar2.frame
        let avatar3Frame : CGRect = avatar3.frame
        
        if(avatar1Frame.contains(touchPoint))
        {
            cAvatar = "Avatar 1"
            avatar2.layer.removeAnimation(forKey: "2")
            avatar3.layer.removeAnimation(forKey: "3")
            
            let moveAnimation = CABasicAnimation(keyPath: "position")
            moveAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            moveAnimation.toValue = NSValue.init(cgPoint: CGPoint(x: avatar1.frame.origin.x + avatar1.frame.width/2, y: avatar1.frame.origin.y + 20))
            moveAnimation.isRemovedOnCompletion = false
            moveAnimation.duration = 0.3
            moveAnimation.repeatCount = .infinity
            avatar1.layer.add(moveAnimation, forKey: "1")
        }
        
        if(avatar2Frame.contains(touchPoint))
        {
            cAvatar = "Avatar 2"
            avatar1.layer.removeAnimation(forKey: "1")
            avatar3.layer.removeAnimation(forKey: "3")
            
            let moveAnimation = CABasicAnimation(keyPath: "position")
            moveAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            moveAnimation.toValue = NSValue.init(cgPoint: CGPoint(x: avatar2.frame.origin.x + avatar2.frame.width/2, y: avatar2.frame.origin.y + 20))
            moveAnimation.isRemovedOnCompletion = false
            moveAnimation.duration = 0.3
            moveAnimation.repeatCount = .infinity
            avatar2.layer.add(moveAnimation, forKey: "2")
        }
        
        if(avatar3Frame.contains(touchPoint))
        {
            cAvatar = "Avatar 3"
            avatar2.layer.removeAnimation(forKey: "2")
            avatar1.layer.removeAnimation(forKey: "1")
            
            let moveAnimation = CABasicAnimation(keyPath: "position")
            moveAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            moveAnimation.toValue = NSValue.init(cgPoint: CGPoint(x: avatar3.frame.origin.x + avatar3.frame.width/2, y: avatar3.frame.origin.y + 20))
            moveAnimation.isRemovedOnCompletion = false
            moveAnimation.duration = 0.3
            moveAnimation.repeatCount = .infinity
            avatar3.layer.add(moveAnimation, forKey: "3")
        }
    }
    
    func rememberEnteredData()
    {
        let defaults = UserDefaults.standard
        defaults.set(tfName.text, forKey: "lastName")
        defaults.set(cAvatar, forKey: "lastAvatar")
        defaults.set(tfEmail.text, forKey: "lastEmail")
        
        defaults.synchronize()
    }
    
    @IBAction func age (sender : UISlider){
        changeAge()
    }
    
    @IBAction func birth (sender : UIDatePicker) {
        changeBirth()
    }
    
    @IBAction func insert (sender : UIButton) {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        if(cAvatar != nil && tfEmail.text != "" && tfName.text != "" && tfPwd.text != "")
        {
            let data : MyData = MyData.init()
            data.initWithData(theRow: 0, theAvatar: cAvatar!, theName: tfName.text!, thePwd: tfPwd.text!, theEmail: tfEmail.text!)
            let returnCode = mainDelegate.insertIntoDB(person: data)
            var returnMsg : String = "Person Add"
            
            if(returnCode == false)
            {
                returnMsg = "Person Add Faild"
            }
            
            let alertbox = UIAlertController(title: returnMsg, message: "Name: " + data.name + " Email: " + String(data.email), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) {
                (alert) in
                self.dismiss(animated: true, completion: nil)
            }
            
            alertbox.addAction(okAction)
            present(alertbox, animated: true)
        }else{
            let alert = UIAlertController(title: "Empty", message: "Missing required fields!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default){
                (alertAction) in
            }
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainDelegate.readDataFromDB()
        
        let defaults = UserDefaults.standard
        
        if let avatar = defaults.object(forKey:"LastAvatar") as? String{
            cAvatar = avatar
            switch cAvatar{
            case "Avatar 1":
                avatar1.alpha = 1
            case "Avatar 2":
                avatar2.alpha = 1
            case "Avatar 3":
                avatar3.alpha = 1
            default:
                avatar1.alpha = 0.5
                avatar2.alpha = 0.5
                avatar3.alpha = 0.5
            }
        }
        
        if let name = defaults.object(forKey: "lastName") as? String{
            tfName.text = name
        }
        
        if let email = defaults.object(forKey: "lastEmail") as? String{
            tfEmail.text = email
        }
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
