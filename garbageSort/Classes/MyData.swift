//
//  MyData.swift
//  garbageSort
//
//  Created by Xcode User on 2020-04-11.
//  Copyright © 2020 Xuanchen Liu. All rights reserved.
//

import UIKit

class MyData: NSObject {
    var avatar : String = ""
    var name : String = ""
    var pwd : String = ""
    var email : String = ""
    
    func initWithData(theAvatar a : String, theName n : String, thePwd p : String, theEmail e : String)
    {
        avatar = a
        name = n
        pwd = p
        email = e
    }
}
