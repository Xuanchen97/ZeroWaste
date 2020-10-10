//  AppDelegate.swift
//  garbageSort
//
//  Created by Haoyue Wang on 2020-03-09.
//  Copyright © 2020 Haoyue Wang. All rights reserved.
//
//  Desciption: This class use for SQLite DB - Create, Insert
//  Author: Haoyue Wang

import UIKit
import SQLite3
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var databaseName : String? = "finalProject.db"
    var databasePath : String?
    var people : [MyData] = []
    var loginFlag : Bool = false


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDir = documentPaths[0]
        databasePath = documentDir.appending("/" + databaseName!)
        
        checkAndCreateDB()
        readDataFromDB()
        FirebaseApp.configure();
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("region").document("iXJTXQnZJhcuBNWukqLR")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }

        return true
    }
    
    func insertIntoDB(person: MyData) -> Bool
    {
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        
        if(sqlite3_open(self.databasePath, &db) == SQLITE_OK)
        {
            var insertStatement : OpaquePointer? = nil
            var insertStatementString : String? = "insert into zw values(NULL, ?, ?, ?, ?)"
            
            if(sqlite3_prepare(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK)
            {
                let nameStr = person.name as NSString
                let pwdStr = person.pwd as NSString
                let avatarStr = person.avatar as NSString
                let emailStr = person.email as NSString
                
                sqlite3_bind_text(insertStatement, 1, avatarStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, nameStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, pwdStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, emailStr.utf8String, -1, nil)
                
                if(sqlite3_step(insertStatement) == SQLITE_DONE)
                {
                    let rowId = sqlite3_last_insert_rowid(db)
                    print("Success inserted row \(rowId)")
                }else
                {
                    print("Could not insert row")
                    returnCode = false
                }
                sqlite3_finalize(insertStatement)
            }else
            {
                print("Insert statement could not be prepared")
                returnCode = false
            }
            sqlite3_close(db)
        }else
        {
            print("Unable to open database")
            returnCode = false
        }
        
        return returnCode
    }
    
    func readDataFromDB()
    {
        people.removeAll()
        
        var db : OpaquePointer? = nil
        
        if (sqlite3_open(self.databasePath, &db) == SQLITE_OK)
        {
            print("Successfully open connection to database at \(self.databasePath)")
            
            var queryStatement : OpaquePointer? = nil
            var queryStatementString : String? = "select * from zw"
            
            if (sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK)
            {
                while(sqlite3_step(queryStatement) == SQLITE_ROW)
                {
                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cavatar = sqlite3_column_text(queryStatement, 1)
                    let cname = sqlite3_column_text(queryStatement, 2)
                    let cemail = sqlite3_column_text(queryStatement, 4)
                    let cpwd = sqlite3_column_text(queryStatement, 3)
                    
                    let avatar = String(cString: cavatar!)
                    let name = String(cString: cname!)
                    let pwd = String(cString: cpwd!)
                    let email = String(cString: cemail!)
                    
                    let data : MyData = MyData.init()
                    data.initWithData(theRow: id, theAvatar: avatar, theName: name, thePwd: pwd, theEmail: email)
                    people.append(data)
                    
                    print("Query result")
                    print("\(id) | \(avatar) | \(name) | \(pwd) | \(email)")
                    
                }
                sqlite3_finalize(queryStatement)
            }else
            {
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
        }else
        {
            print("Unable to open database")
        }
    }
    
    func checkAndCreateDB()
    {
        var success = false
        let fileManager = FileManager.default
        
        success = fileManager.fileExists(atPath: databasePath!)
        
        if(success)
        {
            return
        }
        
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
        
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
        
        return
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


}

