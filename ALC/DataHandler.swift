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

struct DummyB {
    static var Email = "patriktest@test.se"
    static var Password = "password"
    static var InviteCode = "C1456" // css
}

struct Dummy {
    static var Email = "chibi@mooi.ninja"
    static var Password = "password"
    static var InviteCode = "C1456" // css
}


enum Roles: Int {
    case Unknown = 0, SuperAdmin = 1, Admin = 2, Parent = 3, Adoptee = 4, Common = 5
}


struct Variables {
    static var IsLoggedIn : Bool = false
    static var CurrentUser: User? = nil
    static var CurrentUserProfile: Profile? = nil
    static var Agency: String = ""
    static var Posts = [Post]()
    static var Stories = [Story]()
    static var StoryTitle : String = ""
    static var StoryCoverImageUrl : String = ""
}

struct Story {
    var title: String
    var coverImageUrl: String
    var uid: String
    var timestamp: NSNumber?
    var state: String
    var posts: [Post]
    
    init(dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? ""
        self.coverImageUrl = dictionary["coverImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.state = dictionary["state"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.posts = dictionary["posts"] as? [Post] ?? []
    }
}

struct Post {
    var caption: String
    var imageUrl: String
    var timestamp: NSNumber?
    var likes: Int?
    var comments: Int?
    var imageWidth: String
    var imageHeight: String
    var postID: String
    var postUID: String
    var location: String
    var userWhoLike: [String: Any]?
    var IHaveLiked: Bool
    var postUserName: String

    init(dictionary: [String: Any]) {
        self.caption = dictionary["caption"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.likes = dictionary["likes"] as? Int
        self.comments = dictionary["comments"] as? Int
        self.imageWidth = dictionary["imageWidth"] as? String ?? ""
        self.imageHeight = dictionary["imageHeight"] as? String ?? ""
        self.postID = dictionary["postID"] as? String ?? ""
        self.postUID = dictionary["postUID"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
        self.userWhoLike = (dictionary["userWhoLike"] as? [String : Any]) ?? nil
        self.IHaveLiked = dictionary["IHaveLiked"] as? Bool ?? false
        self.postUserName = dictionary["postUserName"] as? String ?? ""
    }
}

struct Profile {
    var UID: String
    var InviteCode: String
    var FirstName: String
    var LastName: String
    var Email: String
    var Country: String
    var City: String
    var Role: Int
    var ProfileImageUrl: String
    var Agency: String?
    var Birth: Date?
    var UserName: String
    
    init(dictionary: [String: Any]) {
        self.UID = dictionary["uid"] as? String ?? ""
        self.InviteCode = dictionary["invitecode"] as? String ?? ""
        self.FirstName = dictionary["firstname"] as? String ?? ""
        self.LastName = dictionary["lastname"] as? String ?? ""
        self.Email = dictionary["email"] as? String ?? ""
        self.Country = dictionary["country"] as? String ?? ""
        self.City = dictionary["city"] as? String ?? ""
        self.Role = dictionary["role"] as? Int ?? 0
        self.ProfileImageUrl = dictionary["ProfileImageUrl"] as? String ?? ""
        self.Agency = dictionary["agency"] as? String ?? ""
        self.Birth = dictionary["birth"] as? Date
        self.UserName = dictionary["username"] as? String ?? ""
    }
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
                    
                    let userDetails = ["uid": user?.uid,
                                       "invitecode": inviteCode,
                                       "agency": Variables.Agency,
                                       "username": "PatrikAdolfsson"]
                    
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
                
                let userDetails = ["uid": user?.uid,
                                   "invitecode": inviteCode,
                                   "agency": Variables.Agency,
                                   "username": "CCTestUser"]
                
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
}









