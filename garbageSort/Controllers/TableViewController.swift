//
//  TableViewController.swift
//  garbageSort
//
//  Created by Xuanchen Liu on 2020-04-11.
//  Copyright © 2020 Xuanchen Liu. All rights reserved.
//
import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        mainDelegate.readDataFromDB()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.people.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell  = tableView.dequeueReusableCell(withIdentifier: "cell") as? SiteCell ?? SiteCell(style: .default, reuseIdentifier: "cell")
        
        let rowNum = indexPath.row
        var avatarFromDB : String
        if mainDelegate.people[rowNum].avatar == "Avatar 1" {
            avatarFromDB = "lion.png"
        }else if mainDelegate.people[rowNum].avatar == "Avatar 2"{
            avatarFromDB = "elephant.png"
        }else{
            avatarFromDB = "crab.png"
        }
        let imgName = UIImage(named: avatarFromDB)
        tableCell.primaryLabel.text = mainDelegate.people[rowNum].name
        tableCell.secondaryLabel.text = mainDelegate.people[rowNum].email
        tableCell.myImageView.image = imgName
        
        
        tableCell.accessoryType = .disclosureIndicator
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowNum = indexPath.row
        let alertController = UIAlertController(title: mainDelegate.people[rowNum].name, message: mainDelegate.people[rowNum].email, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
        // move on to PickerViewController.swift
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
