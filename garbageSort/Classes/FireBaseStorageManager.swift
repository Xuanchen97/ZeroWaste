//
//  FireBaseStorageManager.swift
//  garbageSort
//
//  Created by Saam Haghighat on 2020-11-23.
//  Copyright © 2020 ZeroWaste. All rights reserved.
//

import Foundation

import UIKit
//import FirebaseStorage

//class FirebaseStorageManager {
//    
//    public func uploadImageData(data: Data, serverFileName: String, completionHandler: @escaping (_ isSuccess: Bool, _ url: String?) -> Void) {
//        
//        let storage = Storage.storage()
//        let storageRef = storage.reference()
//        // Create a reference to the file you want to upload
//        let directory = "Records/6mLsL3JQxscZ9AinVa4W/"
//        let fileRef = storageRef.child(directory + serverFileName)
//        
//        _ = fileRef.putData(data, metadata: nil) { metadata, error in
//            fileRef.downloadURL { (url, error) in
//                guard let downloadURL = url else {
//                    // Uh-oh, an error occurred!
//                    completionHandler(false, nil)
//                    return
//                }
//                // File Uploaded Successfully
//                completionHandler(true, downloadURL.absoluteString)
//            }
//        }
//    }
//}

/* UPLOADING IMAGE TO FIREBASE SAMPLE CODE
  
 if let data = image.pngData() { // convert your UIImage into Data object using png representation
       FirebaseStorageManager().uploadImageData(data: data, serverFileName: "your_server_file_name.png") { (isSuccess, url) in
              print("uploadImageData: \(isSuccess), \(url)")
        }
 }
 */
