//
//  SearchViewController.swift
//  garbageSort
//
//  Created by Haoyue Wang on 2020-11-22.
//  Copyright © 2020 Xuanchen Liu. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource,
                            UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let sections: [String] = ["Located region", "Disposal rule"]
    var s2Data: [String] = ["Toronto \n\nhttps://www.toronto.ca/services-payments/recycling-organics-garbage/\n\nGreen Cart: Eggs, Fruits, Vegetables, Meat, Diapers\nBlue Box: Metal, Glass, Cardboard, Plastic, Tissue paper\nGarbage: Everything else",
                            "Halton \n\nhttps://www.halton.ca/For-Residents/Recycling-Waste/Waste-Recycling-Sorting-Guide\n\nGreen Cart: Eggs, Fruits, Vegetables, Meat, Tissue paper\nBlue Box: Metal, Glass, Cardboard, Plastic, Diapers\nGarbage: Everything else",
                            "York",
                            "Peel"]
    var mainDelegate = UIApplication.shared.delegate as! AppDelegate
    var sectionData: [Int: [String]] = [:]
    var selectedIndex = -1
    var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let s1Data: [String] = ["\(mainDelegate.region)"]
        sectionData = [0: s1Data, 1: s2Data]
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
            -> Int {
        return (sectionData[section]?.count)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)
            -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.selectedIndex == indexPath.row && isExpanded == true && indexPath.section == 1{
            return 256
        }else{
            return 48
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
            -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell");
        }
            
        cell!.textLabel?.text = sectionData[indexPath.section]![indexPath.row]
        cell!.textLabel?.numberOfLines = 0
        cell!.textLabel?.lineBreakMode = .byWordWrapping
        //cell!.textLabel?.mar
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
      
        if indexPath.section == 1 {
            
            if selectedIndex == indexPath.row
            {
                if self.isExpanded == false
                {
                    self.isExpanded = true
                }else{
                    self.isExpanded = false
                }
            }else{
                self.isExpanded = true
            }
        
            
            self.selectedIndex = indexPath.row
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
    }
    
}
