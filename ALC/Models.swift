//
//  Models.swift
//  ALC
//
//  Created by Patrik Adolfsson on 2017-08-09.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

struct DummyC {
    static var Email = "patriktest@test.se"
    static var Password = "password"
    static var InviteCode = "C1456" // css
}
struct DummyB {
    static var Email = "fotograf@patrikadolfsson.com"
    static var Password = "password"
    static var InviteCode = "C1456" // css
}

struct Dummy {
    static var Email = "chibi@mooi.ninja"
    static var Password = "abc123"
    static var InviteCode = "C1456" // css
}


enum Roles: Int {
    case Unknown = 0, SuperAdmin = 1, Admin = 2, Parent = 3, Adoptee = 4, Common = 5
}

enum States: String {
    case Unknown = "", Public = "public", Draft = "draft"
}

struct Variables {
    static var IsLoggedIn : Bool = false
    static var CurrentUser: User? = nil
    static var CurrentUserProfile: Profile? = nil
    static var Agency: String = "css"
    static var Posts = [Post]()
    static var Stories = [Story]()
    static var StoryTitle : String = ""
    static var StoryCoverImageUrl : String = ""
    static var isStoryPost: Bool = false
    static var PostStory = [PostsStories]()
    static var SelectedIndexPath: IndexPath? = nil
    static var SelectedProfileUser: Profile? = nil
}

struct PostsStories {
    var timestamp: Double {
        return post?.timestamp as? Double ?? story?.timestamp as? Double ?? 0
    }
    var post: Post?
    var story: Story?
}

struct Story {
    var id : String
    var title: String
    var coverImageUrl: String
    var uid: String
    var timestamp: NSNumber?
    var state: String
    var posts: [Post]?
    var publishDate: NSNumber?
    var profileUserImageUrl: String?
    var profileUserName: String?
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        self.coverImageUrl = dictionary["coverImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.state = dictionary["state"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.posts = dictionary["posts"] as? [Post] ?? []
        self.publishDate = dictionary["publishDate"] as? NSNumber
        self.profileUserImageUrl = dictionary["profileUserImageUrl"] as? String ?? ""
        self.profileUserName = dictionary["profileUserName"] as? String ?? ""
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [
            "id" : id,
            "title" : title,
            "coverImageUrl" : coverImageUrl,
            "uid" : uid,
            "timestamp" : timestamp,
            "state" : state,
            "posts" : posts,
            "publishDate" : publishDate,
            "profileUserImageUrl" : profileUserImageUrl,
            "profileUserName" : profileUserName
        ]
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
    var userWhoLike: [String: Any]
    var IHaveLiked: Bool
    var postUserName: String
    var text: String
    var state: String
    var publishDate: NSNumber?
    var profileUserImageUrl: String?
    
    init(dictionary: [String: Any]) {
        self.caption = dictionary["caption"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.timestamp = (dictionary["timestamp"] as? NSNumber) ?? 0.0
        self.likes = (dictionary["likes"] as? Int) ?? 0
        self.comments = (dictionary["comments"] as? Int) ?? 0
        self.imageWidth = dictionary["imageWidth"] as? String ?? ""
        self.imageHeight = dictionary["imageHeight"] as? String ?? ""
        self.postID = dictionary["postID"] as? String ?? ""
        self.postUID = dictionary["postUID"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
        self.userWhoLike = ((dictionary["userWhoLike"] as? [String : Any]) ?? [:])!
        self.IHaveLiked = dictionary["IHaveLiked"] as? Bool ?? false
        self.postUserName = dictionary["postUserName"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        self.state = dictionary["state"] as? String ?? ""
        self.publishDate = (dictionary["publishDate"] as? NSNumber) ?? 0.0
        self.profileUserImageUrl = dictionary["profileUserImageUrl"] as? String ?? ""
    }
    
    
    var dictionaryRepresentation: [String: Any] {
        return [
            "caption" : caption,
            "imageUrl" : imageUrl,
            "timestamp" : timestamp,
            "likes" : likes,
            "comments" : comments,
            "imageWidth" : imageWidth,
            "imageHeight" : imageHeight,
            "postID" : postID,
            "postUID" : postUID,
            "location" : location,
            "userWhoLike" : userWhoLike,
            "IHaveLiked" : IHaveLiked,
            "postUserName" : postUserName,
            "text" : text,
            "state" : state,
            "publishDate" : publishDate,
            "profileUserImageUrl" : profileUserImageUrl
        ]
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
