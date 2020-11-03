//
//  ChildViewController.swift
//  garbageSort
//
//  Created by Haoyue Wang on 2020-10-12.
//  Copyright © 2020 Xuanchen Liu. All rights reserved.
//

import UIKit
import Firebase

class ChildViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var yes : UIButton!
    @IBOutlet weak var no : UIButton!
    
    var key = "path"
    var type = ""
    var question = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func yesButtonPressed(_ sender: UIButton){
        key = "\(key)1"
        readData()
    }
    
    @IBAction func noPressed(_ sender: UIButton){
        key = "\(key)2"
        readData()
    }
    
    func readData(){
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("Paths").document(key)
        
        docRef.getDocument { [self] (document, error) in
            
            if let document = document, document.exists {
                if(document.data()?.keys.description as! String == "[\"question\"]"){
                    let dataDescription = document.get("question")
                    self.question = dataDescription as! String
                    print(key)
                    label.text = question
                    print("Document data: \(dataDescription)")
                }else{
                    let type = document.get("type")
                    label.text = type as! String
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}