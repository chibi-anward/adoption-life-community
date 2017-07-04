//
//  DataHandler.swift
//  ALC
//
//  Created by Patrik Adolfsson on 2017-07-01.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase


var databaseRef: DatabaseReference!

struct Dummy {
    static var Email = "patrik@mooi.ninja"
    static var Password = "password"
}

struct DummyB {
    static var Email = "chibi@mooi.ninja"
    static var Password = "password"
}

struct Variables {
    static var IsLoggedIn : Bool = false
    static var CurrentUser: User? = nil
}


class DataHandler {
    
    func getLocalData(object: String) -> String {
        let defaults = UserDefaults.standard
        let _object = defaults.object(forKey: object)
        if (_object != nil) {
            return _object as! String
        } else {
            return ""
        }
    }
    
    
    func storeLocalData(object: String, value: String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: object)
        defaults.synchronize()
    }
    
    func clearLocalData() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
    
    func isLoggedIn() -> Bool {
        let uid = getLocalData(object: "uid")
        let email = getLocalData(object: "email")
        let password = getLocalData(object: "password")
        let inviteCode = getLocalData(object: "invitecode")
        
        if( uid != "" ) {
            loginUser(email: email, password: password, inviteCode: inviteCode){ user in
            }
            return true
        }
        return false
    }
    
    func registerUser(email: String, password: String, inviteCode: String, completionHandler:@escaping (User) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error: Error?) in
            if let err = error {
                print("Failed to create user:", err )
                Variables.IsLoggedIn = false
                return
            }
            print( "Successfully created a user", user?.uid ?? "" )
            Variables.CurrentUser = user
            Variables.IsLoggedIn = true
            self.storeLocalData(object: "uid", value: (user?.uid)!)
            self.storeLocalData(object: "email", value: (user?.email)!)
            self.storeLocalData(object: "password", value: password)
            self.storeLocalData(object: "invitecode", value: inviteCode)
            
            let userDetails = ["uid": user?.uid,
                               "invitecode": inviteCode]
            
            databaseRef = Database.database().reference()
            databaseRef.child("users").child((user?.uid)!).updateChildValues(userDetails)
            
            completionHandler(user!)
        }
    }
    
    
    func loginUser(email: String, password: String, inviteCode: String, completionHandler:@escaping (User) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print("Failed to login user:", err )
                Variables.IsLoggedIn = false
                return
            }
            
            print( "Successfully logged in as user", user?.uid ?? "" )
            Variables.CurrentUser = user
            Variables.IsLoggedIn = true
            completionHandler(user!)
            
        }
    }
    
    func updateUser(uid: String, values: Any, completionHandler:@escaping (Bool) -> ()) {
        let userDetails = values
        
        databaseRef = Database.database().reference()
        databaseRef.child("users").child(uid).updateChildValues(userDetails as! [AnyHashable : Any])
        
        completionHandler(true)
    }
}
