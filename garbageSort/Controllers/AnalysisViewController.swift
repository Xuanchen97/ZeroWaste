//
//  AnalysisViewController.swift
//  garbageSort
//
//  Created by Haoyue Wang on 2020-10-05.
//  Copyright © 2020 ZeroWaste. All rights reserved.
//
//  Description: This view controller is about 21 questions where users need to find the correct result by answering some questions. It has a child view controller connects to it. The parent is responsible for getting the photo taken from scan controller
//
//  Author: Haoyue Wang

import UIKit

class AnalysisViewController: UIViewController {
    
    @IBOutlet weak var browsingImage: UIImageView!
    var newImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        browsingImage.image = newImage
        // Do any additional setup after loading the view.
    }

}
