//
//  MyData.swift
//  garbageSort
//
//  Created by Xcode User on 2020-04-11.
//  Copyright © 2020 Xuanchen Liu. All rights reserved.
//

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
