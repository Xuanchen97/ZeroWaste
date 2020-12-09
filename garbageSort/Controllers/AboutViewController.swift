//
//  AboutViewController.swift
//  garbageSort
//
//  Created by Xuanchen Liu on 2020-04-15.
//  Copyright © 2020 ZeroWaste. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

       // declare a new webview
       @IBOutlet var wbPage : UIWebView!
       
       
       override func viewDidLoad() {
           super.viewDidLoad()
           // deprecated - using UIWebview
          let urlAddress = URL(string: "https://github.com/Xuanchen97/ZeroWaste/blob/master/README.md")
           let url = URLRequest(url: urlAddress!)
           wbPage?.loadRequest(url as URLRequest)
        
    
       }
       


       override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
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
