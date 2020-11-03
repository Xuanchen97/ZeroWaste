//
//  ScanViewController.swift
//  garbageSort
//
//  Created Xuanchen Liu on 2020-03-09.
//  Copyright © 2020 Haoyue Wang. All rights reserved.
//
//  Description: This controller is for the scan the garbage. Implement the well-trained model. Machine learning and Artificial Intellgence
//
//  Author: Haoyue Wang

import UIKit
import CoreML
import Vision
import SwiftyJSON
import Alamofire
import SDWebImage
import Firebase


class ScanViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    var pickedImage : UIImage?
    var Region = ""
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var lblScanResault: UILabel!
    @IBOutlet weak var Ntitle: UINavigationItem?
    @IBOutlet var imgScanResult: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    var ScanedItem: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        self.Region = mainDelegate.region
        print("Selected region: \(self.Region)")
    }
    // image Picker dekegate method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        //Convert user picked image to CI image
        if let userPickedImage = info[.originalImage] as? UIImage {
                   
                   guard let ciImage = CIImage(image: userPickedImage) else {
                       fatalError("Could not convert image to CIImage.")
                   }
                   
                   pickedImage = userPickedImage

                   detect(garbageImage: ciImage)

                    imageView.image = userPickedImage
            
               }
        
               imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(garbageImage: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: GarbageClassifier().model) else {
            fatalError("Can't load model")
        }
        //Process to look for the image was classified as
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results?.first as? VNClassificationObservation else {
                fatalError("Could not complete classfication")
            }
            //the string describes what the classification is
            self.Ntitle?.title = result.identifier.capitalized
            self.ScanedItem = result.identifier.capitalized
        
            
          //  self.requestInfo(garbageName: result.identifier)
            
            //read data from the disposal rule database
            self.readDisposalRules(ScanedItem: self.ScanedItem)
        }
        let handler = VNImageRequestHandler(ciImage: garbageImage)
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    
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
    
    func requestInfo(garbageName: String) {
        let parameters : [String:String] = ["format" : "json", "action" : "query", "prop" : "extracts|pageimages", "exintro" : "", "explaintext" : "", "titles" : garbageName, "redirects" : "1", "pithumbsize" : "500", "indexpageids" : ""]
        
        
        Alamofire.request(wikipediaURl, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {

                let garbageJSON : JSON = JSON(response.result.value!)
                
                let pageid = garbageJSON["query"]["pageids"][0].stringValue
                
                let garbageImageURL = garbageJSON["query"]["pages"][pageid]["thumbnail"]["source"].stringValue
                
                self.imageView.sd_setImage(with: URL(string: garbageImageURL), completed: { (image, error,  cache, url) in
                    self.imageView.image = self.pickedImage

                })
                
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.label.text = "Connection Issues"
            }
        }
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
         present(imagePicker, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "image" {
            var ac = segue.destination as! AnalysisViewController
            ac.newImage = self.pickedImage
        }
    }
}

