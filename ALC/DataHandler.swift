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
import FirebaseStorage

var databaseRef: DatabaseReference!

class DataHandler {
    // ******************************************************
    // 
    // Helper Functions
    //
    // ******************************************************
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
    
    func deleteLocalData(object: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: object)
        defaults.synchronize()
    }
    
    func clearLocalData() {
        deleteLocalData(object: "uid")
        deleteLocalData(object: "email")
        deleteLocalData(object: "password")
        deleteLocalData(object: "invitecode")
        deleteLocalData(object: "agency")

    }
    
    // ******************************************************
    //
    // FIrebase Functions
    //
    // ******************************************************
    func isLoggedIn(completionHandler:@escaping (Bool) -> ()) {
        
        if (Auth.auth().currentUser != nil)  {
            let uid = getLocalData(object: "uid")
            let email = getLocalData(object: "email")
            let password = getLocalData(object: "password")
            let inviteCode = getLocalData(object: "invitecode")
            let agency = getLocalData(object: "agency")
            Variables.Agency = agency
            if( uid != "" ) {
                if ( agency != "cc" ) {
                    loginALCUser(email: email, password: password, inviteCode: inviteCode, completionHandler: { (object) in
                        completionHandler(true)
                        return
                    })
                } else {
                    loginCCUser(email: email, password: password, completionHandler: { (object) in
                        completionHandler(true)
                        return
                    })
                }
                
            } else {
                completionHandler(false)
                return
            }
            return
        } else {
            completionHandler(false)
        }
    }
    
    func handleInviteCode(inviteCode: String, completionHandler:@escaping (Bool) -> ()) {
        databaseRef = Database.database().reference()
        databaseRef.child("inviteCodes").child(inviteCode).observeSingleEvent(of: .value, with: {( snapshot ) in
            
            if ( snapshot.exists() ) {
                if let agency = snapshot.value {
                    Variables.Agency = agency as! String
                    self.storeLocalData(object: "agency", value: agency as! String)
                    completionHandler(true)
                } else {
                    Variables.Agency = ""
                    completionHandler(false)
                }
            } else {
                Variables.Agency = ""
                completionHandler(false)
            }
            
        }, withCancel: {(error) in
            Variables.Agency = ""
            completionHandler(false)
            
        })
    }
    
    func registerUser(email: String, password: String, inviteCode: String, completionHandler:@escaping (Bool) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error: Error?) in
            if let err = error {
                print("Failed to create user:", err )
                Variables.IsLoggedIn = false
                return
            }
            if ( inviteCode != "" ) {
                self.handleInviteCode(inviteCode: inviteCode, completionHandler: { (object) in
                    if ( object == false ) {
                        print("Failed to create user: Invalid invite code" )
                        Variables.Agency = ""
                        Variables.IsLoggedIn = false
                        completionHandler(false)
                        return
                    }
                    
                    print( "Successfully created a user", user?.uid ?? "" )
                    Variables.CurrentUser = user
                    Variables.IsLoggedIn = true
                    
                    self.storeLocalData(object: "uid", value: (user?.uid) ?? "")
                    self.storeLocalData(object: "email", value: (user?.email)!)
                    self.storeLocalData(object: "password", value: password)
                    self.storeLocalData(object: "agency", value: Variables.Agency)
                    
                    self.storeLocalData(object: "invitecode", value: inviteCode)
                    
                    guard let userDetails = ["uid": user?.uid,
                                             "invitecode": inviteCode,
                                             "agency": Variables.Agency,
                                             "username": "PatrikAdolfsson"] as? [String: String] else { return }
                    
                    databaseRef = Database.database().reference()
                    databaseRef.child("agencies").child(Variables.Agency).child("users").child((user?.uid)!).updateChildValues(userDetails)
                    
                    self.fetchUser(uid: (user?.uid)!, completionHandler: { (profile) in
                        Variables.CurrentUserProfile = profile
                    })
                    
                    completionHandler(true)
                    
                })
                
            } else {
                Variables.Agency = "cc"
                print( "Successfully created a user", user?.uid ?? "" )
                Variables.CurrentUser = user
                
                
                Variables.IsLoggedIn = true
                self.storeLocalData(object: "uid", value: (user?.uid) ?? "")
                self.storeLocalData(object: "email", value: (user?.email)!)
                self.storeLocalData(object: "password", value: password)
                self.storeLocalData(object: "agency", value: Variables.Agency)
                self.storeLocalData(object: "invitecode", value: inviteCode)
                
                guard let userDetails = ["uid": user?.uid,
                                         "invitecode": inviteCode,
                                         "agency": Variables.Agency,
                                         "username": "CCTestUser"] as? [String: String] else { return }
                
                databaseRef = Database.database().reference()
                databaseRef.child("agencies").child(Variables.Agency).child("users").child((user?.uid)!).updateChildValues(userDetails)
                
                self.fetchUser(uid: (user?.uid)!, completionHandler: { (profile) in
                    Variables.CurrentUserProfile = profile
                })
                completionHandler(true)
            }
        }
    }
    
    func loginALCUser(email: String, password: String, inviteCode: String, completionHandler:@escaping (Bool) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print("Failed to login user:", err )
                Variables.IsLoggedIn = false
                completionHandler(false)
                return
            }
            
            print( "Successfully logged in as user", user?.email ?? "" )
            self.handleInviteCode(inviteCode: inviteCode, completionHandler: { (object) in
                Variables.CurrentUser = user
                self.fetchUser(uid: (user?.uid)!, completionHandler: { (profile) in
                    Variables.CurrentUserProfile = profile
                    Variables.IsLoggedIn = true
                    self.storeLocalData(object: "uid", value: (user?.uid)!)
                    self.storeLocalData(object: "email", value: (user?.email)!)
                    self.storeLocalData(object: "password", value: password)
                    self.storeLocalData(object: "invitecode", value: inviteCode)
                    self.storeLocalData(object: "agency", value: Variables.Agency)
                    completionHandler(true)
                })
            })
        }
    }
    
    func loginCCUser(email: String, password: String, completionHandler:@escaping (Bool) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print("Failed to login user:", err )
                Variables.IsLoggedIn = false
                completionHandler(false)
                return
            }
            
            Variables.Agency = "cc"
            Variables.CurrentUser = user
            self.fetchUser(uid: (user?.uid)!, completionHandler: { (profile) in
                Variables.CurrentUserProfile = profile
                Variables.IsLoggedIn = true
                self.storeLocalData(object: "uid", value: (user?.uid)!)
                self.storeLocalData(object: "email", value: (user?.email)!)
                self.storeLocalData(object: "password", value: password)
                self.storeLocalData(object: "invitecode", value: "")
                self.storeLocalData(object: "agency", value: Variables.Agency)
                completionHandler(true)
            })
        }
    }
    
    func updateUser(uid: String, values: Any, completionHandler:@escaping (Bool) -> ()) {
        let userDetails = values
        
        databaseRef = Database.database().reference()
        databaseRef.child("agencies").child("css").child("users").child(uid).updateChildValues(userDetails as! [AnyHashable : Any], withCompletionBlock: { (err , ref ) in
            if let err = err {
                print( "Failed to store data in db", err )
                completionHandler(false)
                return
            }
            
            print( "Successfully stored data in db" )
            completionHandler(true)
        })
    }
    
    func logOutUser(completionHandler:@escaping (Bool) -> ()) {
        do {
            try Auth.auth().signOut()
            Variables.Posts.removeAll()
            clearLocalData()
            completionHandler(true)
            return
        } catch let err {
            print("Failed to sign out", err)
        }
        completionHandler(false)
    }
    
    func fetchUser(uid: String, completionHandler:@escaping (Profile) -> ()) {
        databaseRef = Database.database().reference()
        databaseRef.child("agencies").child(Variables.Agency).child("users").child(uid).observeSingleEvent(of: .value, with: {( snapshot ) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                
                let profile = Profile(dictionary: dictionary)
                completionHandler(profile)
            }
        }, withCancel: nil)
    }
    
    func editPost(post: Post, isStory: Bool,story: Story?, completionHandler:@escaping (Bool) -> ()) {
        var ref: DatabaseReference? = nil
        if ( isStory ) {
            ref = Database.database().reference().child("agencies").child(Variables.Agency).child("stories").child((Variables.CurrentUser?.uid)!).child((story?.id)!).child("posts")
        } else {
            ref = Database.database().reference().child("agencies").child(Variables.Agency).child("posts").child((Variables.CurrentUser?.uid)!)
        }
        let updatedValues = ["caption": post.caption,
                             "text" : post.text
                             ]
        ref?.child(post.postID).updateChildValues(updatedValues as [AnyHashable : Any], withCompletionBlock: { (err , ref ) in
            if let err = err {
                print( "Failed to store data in db", err )
                completionHandler(false)
                return
            }
        completionHandler(true)
        })
    }
    
    func deletePost(post: Post, isStory: Bool,story: Story?, completionHandler:@escaping (Bool) -> ()) {
        var ref: DatabaseReference? = nil
        if ( isStory ) {
            ref = Database.database().reference().child("agencies").child(Variables.Agency).child("stories").child((Variables.CurrentUser?.uid)!).child((story?.id)!).child("posts")
        } else {
            ref = Database.database().reference().child("agencies").child(Variables.Agency).child("posts").child((Variables.CurrentUser?.uid)!)
        }
        
        // Remove the post from the DB
        ref?.child(post.postID).removeValue { err in
            if( isStory == false ) {
                
            // Remove the image from Storage
            let storageRef = Storage.storage().reference(forURL: post.imageUrl)
            storageRef.delete { (err) in
                if let err = err {
                    print( "Failed to delete image in db", err )
                    completionHandler(false)
                    return
                }
                
                completionHandler(true)
            }
            } else {
                completionHandler(true)
            }
        }
    }
}









