//
//  ViewController.swift
//  garbageSort
//
//  Created Xuanchen Liu on 2020-03-09.
//  Copyright © 2020 ZeroWaste. All rights reserved.
//
//  Description: This view controller is for the main page where every function can direct from              this page. It shows all regions as dropdown for users to choose.
//
//  Author: Haoyue Wang

import UIKit
import SceneKit
import ARKit
import DropDown
import Firebase

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var AR : UIButton!
    @IBOutlet var AI : UIButton!
    
    var soundPlayer : AVAudioPlayer?
    var regions = [String]()
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var citiesBarButton: UIButton!
    @IBOutlet var city : UIButton!
    let cityMenu = DropDown()
    
    @IBAction func showBarButtonDropDown(_sender: AnyObject)
    {
        cityMenu.selectionAction = {
            (index: Int, item: String) in print("Selected city: \(item)")
            self.citiesBarButton.setTitle("\(item)", for: .normal)
            self.mainDelegate.region = "\(item)"
        }
        cityMenu.width = 140
        cityMenu.bottomOffset = CGPoint(x: 0, y: (cityMenu.anchorView?.plainView.bounds.height)!)
        cityMenu.show()
    }
    
    @IBAction func unwindToHomeVC(sender : UIStoryboardSegue){
        mainDelegate.CIImage = nil
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        
//        if(mainDelegate.loginFlag){
//            AR.isEnabled = true
//            AR.alpha = 1
//            AI.isEnabled = true
//            AI.alpha = 1
//        }
//        else{
//            AR.isEnabled = false
//            AR.alpha = 0.5
//            AI.isEnabled = false
//            AI.alpha = 0.5
//        }
//    }
//
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        db.collection("disposalRules").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID)")
                        self.regions.append("\(document.documentID)")
                        print(self.regions)
                    }
                    self.cityMenu.anchorView = self.citiesBarButton
                    self.cityMenu.dataSource = self.regions
                    self.cityMenu.cellConfiguration = {(index, item) in return "\(item)"}
                }
        }
    }
}
