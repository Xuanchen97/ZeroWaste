//
//  SearchViewController.swift
//  garbageSort
//
//  Created by Haoyue Wang on 2020-11-22.
//  Copyright © 2020 ZeroWaste. All rights reserved.
//  Description: In this controller, Haoyue Wang was responsible for displaying the region disposal rules into the table view with the button to link outside website.
//  Xuanchen Liu was responsible for build the API connection with 'Geocoder' to find the proper city by entering the Postal code.
//  Author: Haoyue Wang & Xuanchen Liu

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource,
                            UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var postalCodeTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    let sections: [String] = ["Located region", "Disposal rule"]
    var s2Data: [String] = ["Toronto \n\nGreen Cart: Eggs, Fruits, Vegetables, Meat, Diapers\nBlue Box: Metal, Glass, Cardboard, Plastic, Tissue paper\nGarbage: Everything else",
                            "Halton \n\nGreen Cart: Eggs, Fruits, Vegetables, Meat, Tissue paper\nBlue Box: Metal, Glass, Cardboard, Plastic, Diapers\nGarbage: Everything else",
                            "York",
                            "Peel"]
    var linkData: [String] = ["https://www.toronto.ca/services-payments/recycling-organics-garbage/","https://www.halton.ca/For-Residents/Recycling-Waste/Waste-Recycling-Sorting-Guide","https://www.york.ca/wps/portal/yorkhome/environment/yr/garbageandrecycling/recyclingbluebox/!ut/p/z1/jZDbToQwEIafxQsupUP3QPWuwUNhRXYTdbE3pmC3kEBLCivq09usxsSo6FzNTL7_nwPiKEdci6daiaE2WjSuvufLh5hexoytIMnmJAIKGU1wSOB8MUPbAwC_BAXE_6OfAPi0ffLXAHcBtmmUKsQ7MVTHtd4ZlCthC6Gk0I9Wli9lU2uF8s-0aPayMM9uOX6wx3i-ZEEECQThCcQX19HNJsUY7uAbwDLigHC9OCMsgBX-AKYvUI0p3p9NdTEjblUrd9JK6--ta1fD0PWnHngwjqOvjFGN9EvTevCTpDL9gPKvJOra2_z1ikG9brekp0dvuMR2Bg!!/dz/d5/L2dBISEvZ0FBIS9nQSEh/#.X8cnSi2z2Rs","https://www.peelregion.ca/scripts/waste/how-to-sort-your-waste.pl?action=category&query=Recycle" ]
    var mainDelegate = UIApplication.shared.delegate as! AppDelegate
    var sectionData: [Int: [String]] = [:]
    var selectedIndex = -1
    var isExpanded = false
    var currentLoc = ""
    var postalCode = ""
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
            return 206
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

        return cell!
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search bar triggered!")
    }
    
    func DismissKeyboard(){
        self.view.endEditing(true)
    }
    
    @IBAction func search(_ sender: Any) {
        DismissKeyboard()

        struct Response: Codable {
            let standard: Data
        }
        
        struct Data : Codable {
            let city : String
        }
        if postalCodeTextField.text != ""{
            self.postalCode = postalCodeTextField.text!
            
            if let url = URL(string: "https://geocoder.ca/?locate="+self.postalCode+"&json=1") {
               URLSession.shared.dataTask(with: url) { data, response, error in
                  if let data = data {
                    
                   
                      do {
                         let res = try JSONDecoder().decode(Response.self, from: data)
//                        self.mainDelegate.region = res.standard.city
//                        print(self.mainDelegate.region)
                        print(res.standard.city)
                        self.currentLoc = res.standard.city
         
                      } catch let error {
                         print("Undefined Postal Code")
                        
             }

                   }
               }.resume()
            }
            delayWithSeconds(0.7){
                let alert = UIAlertController(title: self.currentLoc, message: "", preferredStyle: .alert)
        
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
                self.present(alert, animated: true)
            }


        }else{
            let alert = UIAlertController(title: "Please enter your Postal Code", message: "", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            self.present(alert, animated: true)
            print("please enter the postal code")
        }

        
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            let contextItem = UIContextualAction(style: .destructive, title: "View More") { (contextualAction, view, boolValue) in
                if let url = URL(string: self.linkData[indexPath.row]) {
                    UIApplication.shared.open(url)
                }
            }
            let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
            return swipeActions
        }
        else{
            return nil
        }
   }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
