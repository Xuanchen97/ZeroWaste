//
//  ViewController.swift
//  garbageSort
//
//  Created Xuanchen Liu on 2020-03-09.
//  Copyright © 2020 Xuanchen Liu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var AR : UIButton!
    @IBOutlet var AI : UIButton!
    
    var soundPlayer : AVAudioPlayer?
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func unwindToHomeVC(sender : UIStoryboardSegue){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if(mainDelegate.loginFlag){
            AR.isEnabled = true
            AR.alpha = 1
            AI.isEnabled = true
            AI.alpha = 1
        }
        else{
            AR.isEnabled = false
            AR.alpha = 0.5
            AI.isEnabled = false
            AI.alpha = 0.5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let soundURL = Bundle.main.path(forResource: "bgm", ofType: "mp3")
        let url = URL(fileURLWithPath: soundURL!)
        soundPlayer = try! AVAudioPlayer.init(contentsOf: url)
        soundPlayer?.currentTime = 0
        soundPlayer?.volume = 0.5
        soundPlayer?.numberOfLoops = -1
        soundPlayer?.play()
        
    }
    

}
