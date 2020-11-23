//
//  SearchTableViewController.swift
//  garbageSort
//
//  Created by Haoyue Wang on 2020-11-22.
//  Copyright © 2020 Xuanchen Liu. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UITableViewDataSource,
                                 UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
        let sections: [String] = ["Section 1", "Section 2", "Section 3"]
        let s1Data: [String] = ["Row 1", "Row 2", "Row 3"]
        let s2Data: [String] = ["Row 1", "Row 2", "Row 3"]
        let s3Data: [String] = ["Row 1", "Row 2", "Row 3"]
        
        var sectionData: [Int: [String]] = [:]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.delegate = self
            tableView.dataSource = self
            
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
