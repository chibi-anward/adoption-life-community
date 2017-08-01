//
//  ViewPostVC.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-29.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit

class ViewPostVC: UIViewController {
    
    var post: Post? {
        didSet {
            
//            guard let caption = post?.caption else {return}
//            self.descriptionLabel.text = caption
//            
//            guard let likes = post?.likes else {return}
//            self.likeLabel.text = "\(likes)"
//            
//            guard let comments = post?.comments else {return}
//            self.commentLabel.text = "\(comments)"
//            
//            //            guard let username = post?.postUserName else {return}
//            //            self.usernameLabel.text = "\(username)"
//            
//            guard let locationTag = post?.location else {return}
//            self.locationLabel.text = locationTag
//            
//            if let seconds = post?.timestamp?.doubleValue {
//                let timestampDate = NSDate(timeIntervalSince1970: seconds)
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "hh:mm:ss a"
//                self.timeLabel.text = dateFormatter.string(from: timestampDate as Date)
//            }
//            
//            guard let imageUrl = post?.imageUrl else {return}
//            postImageView.loadImageUsingCacheWithUrlString(urlString: imageUrl)
        }
    }

    
    let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.isHidden = true
        view.layer.cornerRadius = 6
        return view
    }()
    
    let backNavButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("close", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 100, green: 100, blue: 100, alpha: 1), for: .normal)
        //button.addTarget(self, action: #selector(backAction), for: .touchDown)
        return button
    }()
    
    // Edit Options
    let saveNavButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("save", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 100, green: 100, blue: 100, alpha: 1), for: .normal)
        button.isHidden = true
        //button.addTarget(self, action: #selector(backAction), for: .touchDown)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("\nSTORY VIEW POST VC")
    }
    func loadPost() {
        let selectedPost = post
        print( selectedPost! )
    }
    func viewMode() {
        popupView.insertSubview(backNavButton, at: 20)
        backNavButton.anchor(top: popupView.topAnchor, left: popupView.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        //Edit options
        saveNavButton.isHidden = true
    }
    
    func editMode() {
        popupView.insertSubview(backNavButton, at: 20)
        backNavButton.anchor(top: popupView.topAnchor, left: popupView.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        //Edit options
        saveNavButton.isHidden = false
        popupView.insertSubview(saveNavButton, at: 20)
        saveNavButton.anchor(top: popupView.topAnchor, left: nil, bottom: nil, right: popupView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 40, height: 40)
    }
 
    
}
