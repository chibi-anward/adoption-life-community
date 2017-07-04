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

struct Dummy {
    static var Email = "patrik@mooi.ninja"
    static var Password = "password"
}

struct Variables {
    static var IsLoggedIn : Bool = false
    static var CurrentUser: User? = nil
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
