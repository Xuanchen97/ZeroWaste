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


class ScanViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    var pickedImage : UIImage?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var Ntitle: UINavigationItem?
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

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
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results?.first as? VNClassificationObservation else {
                fatalError("Could not complete classfication")
            }
            self.Ntitle?.title = result.identifier.capitalized
            self.requestInfo(garbageName: result.identifier)
        }
        let handler = VNImageRequestHandler(ciImage: garbageImage)
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    
    func requestInfo(garbageName: String) {
        let parameters : [String:String] = ["format" : "json", "action" : "query", "prop" : "extracts|pageimages", "exintro" : "", "explaintext" : "", "titles" : garbageName, "redirects" : "1", "pithumbsize" : "500", "indexpageids" : ""]
        
        
        Alamofire.request(wikipediaURl, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {

                let garbageJSON : JSON = JSON(response.result.value!)
                
                let pageid = garbageJSON["query"]["pageids"][0].stringValue
                
                let garbageDescription = garbageJSON["query"]["pages"][pageid]["extract"].stringValue
                let garbageImageURL = garbageJSON["query"]["pages"][pageid]["thumbnail"]["source"].stringValue
            
                self.label.text = garbageDescription
                
                
                
                
                self.imageView.sd_setImage(with: URL(string: garbageImageURL), completed: { (image, error,  cache, url) in
                    
                    if let currentImage = self.imageView.image {
                        
//                        guard let dominantColor = ColorThief.getColor(from: currentImage) else {
//                            fatalError("Can't get dominant color")
//                        }
//
                        
                        DispatchQueue.main.async {
                            self.navigationController?.navigationBar.isTranslucent = true
                            
                        }
                    } else {
                        self.imageView.image = self.pickedImage
                        self.label.text = "Could not get information from Wikipedia."
                    }
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
}

