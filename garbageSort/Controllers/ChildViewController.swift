//
//  ChildViewController.swift
//  garbageSort
//
//  Created by Haoyue Wang on 2020-10-12.
//  Copyright © 2020 ZeroWaste. All rights reserved.
//
//  Description: This is AnalysisViewController's child controller where it contains all the                 logic for 20 questions
//
//  Author: Haoyue Wang

import UIKit
import Firebase

class ChildViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var yes : UIButton!
    @IBOutlet weak var no : UIButton!
    
    var key = "path"
    var type = ""
    var question = ""
    var gName : String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //when user press yes, append 1
    @IBAction func yesButtonPressed(_ sender: UIButton){
        key = "\(key)1"
        readData()
    }
    
    //when user press no, append 2
    @IBAction func noPressed(_ sender: UIButton){
        key = "\(key)2"
        readData()
    }
    
    //Run through the questions and get the result then redirect back to scan controller
    func readData(){
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //connect to firebase
        let db = Firestore.firestore()
        
        let docRef = db.collection("Paths").document(key)
        
        docRef.getDocument { [self] (document, error) in
            
            //match from firebase document's name if it's question then display to user
            if let document = document, document.exists {
                if(document.data()?.keys.description as! String == "[\"question\"]"){
                    let dataDescription = document.get("question")
                    self.question = dataDescription as! String
                    print(key)
                    label.text = question
                    print("Document data: \(dataDescription)")
                }
                //if it's type then save the corresponding value to main delegate and redirect to scan page
                else{
                    let type = document.get("type")
                    
                    self.gName = type as! String
                    print("name: \(self.gName)")
                    mainDelegate.gn = type as! String
                    performSegue(withIdentifier: "test", sender: self)
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}
