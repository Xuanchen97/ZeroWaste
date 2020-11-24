//
//  SearchViewController.swift
//  garbageSort
//
//  Created by Haoyue Wang on 2020-11-22.
//  Copyright © 2020 Xuanchen Liu. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource,
                            UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var postalCodeTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var postalCodeSearch: UISearchBar!
    
    let sections: [String] = ["Located region", "Regions", "Disposal rule"]
    var mainDelegate = UIApplication.shared.delegate as! AppDelegate
    var currentLoc = ""
    var sectionData: [Int: [String]] = [:]
    var postalCode = ""
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}
