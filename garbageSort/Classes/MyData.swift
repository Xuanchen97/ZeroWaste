//  MyData.swift
//  garbageSort
//
//  Created by Haoyue Wang on 2020-04-11.
//  Copyright © 2020 ZeroWaste. All rights reserved.
//
//  Desciption: This app is for storing the user information
//  Author: Haoyue Wang

import UIKit

class MyData: NSObject {
    var id : Int?
    var avatar : String = ""
    var name : String = ""
    var pwd : String = ""
    var email : String = ""
    
    func initWithData(theRow i : Int, theAvatar a : String, theName n : String, thePwd p : String, theEmail e : String)
    {
        id = i
        avatar = a
        name = n
        pwd = p
        email = e
    }
}
