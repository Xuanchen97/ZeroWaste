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
    
    let sections: [String] = ["Located region", "Regions", "Disposal rule"]
    var mainDelegate = UIApplication.shared.delegate as! AppDelegate
    var currentLoc = ""
    var sectionData: [Int: [String]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let s1Data: [String] = ["\(mainDelegate.region)"]
        let s2Data: [String] = ["Toronto", "Halton", "York", "Peel"]
        let s3Data: [String] = ["Toronto", "Halton"]
        
        sectionData = [0:s1Data, 1:s2Data, 2:s3Data]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
            -> Int {
        return (sectionData[section]?.count)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)
            -> String? {
        return sections[section]
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
        
        return cell!
    }

}
