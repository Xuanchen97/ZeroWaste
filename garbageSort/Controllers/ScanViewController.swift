//
//  ScanViewController.swift
//  garbageSort
//
//  Created Xuanchen Liu on 2020-03-09.
//  Copyright © 2020 ZeroWaste. All rights reserved.
//
//  Description: This controller is for the garbage scaning feature. Implement the well-trained model. Machine learning and Artificial Intellgence. Search the scaned object from trained ML Model and pass to firestore database to check the disposal rules.
//  Xuanchen Liu was responsible for looking for the image was classified in the ML Model, retrieving and matching the disposal rule from the firestore database

//  Haoyue Wang was responsible for the data passing between outsides controllers and created the segments controller for the scaned result

//  Saam Haghighat was responsible for pull up the camera and store the image into the user default
//
//  Author: Xuanchen Liu & Haoyue Wang & Saam Haghighat

import UIKit
import CoreML
import Vision
import SwiftyJSON
import Alamofire
import SDWebImage
import Firebase


class ScanViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var pickedImage : UIImage?
    var Region = ""
    var garbageName : String?
    
    var result1 = ""
    var result2 = ""
    var result3 = ""
    var result1Percentage = ""
    var result2Percentage = ""
    var result3Percentage = ""
    var garbageBin1 = ""
    var garbageBin2 = ""
    var garbageBin3 = ""
    
    
    @IBOutlet weak var ResultPercentage: UILabel!
    @IBOutlet weak var lblcorrectionResult: UILabel!
    @IBOutlet weak var lblScanResault: UILabel!
    @IBOutlet weak var Ntitle: UINavigationItem?
    @IBOutlet var imgScanResult: UIImageView!
    @IBOutlet var imgScanBackground: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var button : UIButton!
    
    var ScanedItem: String = ""
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        self.imgScanBackground.isHidden = false
        button.isHidden = true
        self.Region = mainDelegate.region
        segmentedControl.isHidden = true
        print("Selected region: \(self.Region)")
        
        if mainDelegate.CIImage != nil{
            detect(garbageImage: mainDelegate.CIImage)
            imageView.image = mainDelegate.userPickedImage
            //self.Ntitle?.title = mainDelegate.gn
            self.ScanedItem = mainDelegate.gn
            self.segmentedControl.isHidden = true
            self.ResultPercentage.isHidden = true
            self.lblcorrectionResult.isHidden = false
            self.imgScanBackground.isHidden = true
            button.isHidden = true
            self.lblcorrectionResult.text = mainDelegate.gn!
            self.readDisposalRules(ScanedItem: self.ScanedItem)
        }
        button.layer.cornerRadius = 5
        //button.backgroundColor = UIColor.systemBlue
    }
    
    // image Picker dekegate method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        //Convert user picked image to CI image
        if let userPickedImage = info[.originalImage] as? UIImage {
                   
                   guard let ciImage = CIImage(image: userPickedImage) else {
                       fatalError("Could not convert image to CIImage.")
                   }
                mainDelegate.CIImage = ciImage
                   pickedImage = userPickedImage
                mainDelegate.userPickedImage = userPickedImage
                   detect(garbageImage: ciImage)

                   imageView.image = userPickedImage
            
               }
        
               imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(garbageImage: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: GarbageClassifier1().model) else {
            fatalError("Can't load model")
        }
        //Process to look for the image was classified as
        let request = VNCoreMLRequest(model: model) { (request, error) in
            print(request.results?.first as? VNClassificationObservation)
            guard let result1 = request.results?.first as? VNClassificationObservation else {
                fatalError("Could not complete classfication")
            }
            //the string describes what the classification is
            self.garbageName = result1.identifier.capitalized
            //self.Ntitle?.title = self.garbageName
            self.ScanedItem = self.garbageName!
        
            
            //self.requestInfo(garbageName: result.identifier)
            
            self.result1 = result1.identifier.capitalized
            print(String(format: "%.2f", result1.confidence))
            self.result1Percentage = String(format: "%.2f", result1.confidence*100) + "%"
            //read data from the disposal rule database
            self.readDisposalRules(ScanedItem: self.result1)
            
            //self.Ntitle?.title = self.result1
            self.ResultPercentage.isHidden = false
            self.ResultPercentage.text = self.result1Percentage
            self.imgScanBackground.isHidden = true
            
            guard let result2 = request.results?[1] as? VNClassificationObservation else {
                fatalError("Could not complete classfication")
            }
            //the string describes what the classification is
            self.result2 = result2.identifier.capitalized
            self.result2Percentage = String(format: "%.2f", result2.confidence*100)+"%"
            print(String(format: "%.2f", result2.confidence))
            
            guard let result3 = request.results?[2] as? VNClassificationObservation else {
                fatalError("Could not complete classfication")
            }
            //the string describes what the classification is
            self.result3 = result3.identifier.capitalized
            self.result3Percentage = String(format: "%.2f", result3.confidence*100)+"%"

            self.segmentedControl.isHidden = false
            self.button.isHidden = false
            self.lblcorrectionResult.isHidden = true
            self.segmentedControl.setTitle(self.result1, forSegmentAt: 0)
            self.segmentedControl.setTitle(self.result2, forSegmentAt: 1)
            self.segmentedControl.setTitle(self.result3, forSegmentAt: 2)
            self.segmentedControl.selectedSegmentIndex = 0
        }
        let handler = VNImageRequestHandler(ciImage: garbageImage)
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    // func to read the data from the firestore database
    func readDisposalRules(ScanedItem: String) {
        let db = Firestore.firestore()
        
        let docRef = db.collection("disposalRules").document(self.Region)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let results = document.data()
                if let idData = results?[ScanedItem] as? [String: Any]{
                    let category = idData["Category"] as? String ?? "nil"
                    self.lblScanResault.text = "Belongs in \(category)"
                    print("Blongs to \(category)")
                    
                    if category == "Blue Box" {
                        let garbageboxImg = UIImage(named: "bluebox.jpg")
                        self.imgScanResult.image = garbageboxImg
                    }else if category == "Green Box" {
                        let garbageboxImg = UIImage(named: "greenbox.jpg")
                        self.imgScanResult.image = garbageboxImg
                    }else{
                        let garbageboxImg = UIImage(named: "blackbox.png")
                        self.imgScanResult.image = garbageboxImg
                    }
                  
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // func to update the segment control
    @IBAction func resultChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            //self.Ntitle?.title = self.result1
            self.ResultPercentage.text = self.result1Percentage
            self.readDisposalRules(ScanedItem: self.result1)
        case 1:
            //self.Ntitle?.title = self.result2
            self.ResultPercentage.text = self.result2Percentage
            self.readDisposalRules(ScanedItem: self.result2)
        case 2:
            //self.Ntitle?.title = self.result3
            self.ResultPercentage.text = self.result3Percentage
            self.readDisposalRules(ScanedItem: self.result3)
        default:
            break
        }
    }
    
    // launch the camera
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
         present(imagePicker, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "image" {
            var ac = segue.destination as! AnalysisViewController
            ac.newImage = self.pickedImage
        }
    }
    
    //Store the image into the user default
    private func storeImage(image: UIImage, forKey key: String) {
        if let pngRepresentation = image.pngData() {
            UserDefaults.standard.set(pngRepresentation, forKey: key)
        }
    }
    
    // retrieve the image
    private func retrieveImage(forKey key: String) -> UIImage? {
            if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
                let image = UIImage(data: imageData) {
                
                return image
            }
        return nil
    }
}

