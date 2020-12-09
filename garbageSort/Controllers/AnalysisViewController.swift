//
//  AnalysisViewController.swift
//  garbageSort
//
//  Created by Haoyue Wang on 2020-10-05.
//  Copyright © 2020 ZeroWaste. All rights reserved.
//

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
