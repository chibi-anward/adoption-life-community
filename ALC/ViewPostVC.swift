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
            
            guard let caption = post?.caption else {return}
            self.descriptionLabel.text = caption
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
            guard let imageUrl = post?.imageUrl else {return}
            postImageView.loadImageUsingCacheWithUrlString(urlString: imageUrl)
        }
    }

    
    let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.isHidden = true
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
        return view
    }()
    
    let backNavButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("close", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1), for: .normal)
        //button.addTarget(self, action: #selector(backAction), for: .touchDown)
        return button
    }()
    
    let postImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "postImage_default")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18, weight: 15)
        label.textAlignment = .center
        label.textColor = UIColor.rgb(red: 55, green: 55, blue: 55, alpha: 1)
        return label
    }()
    
    let line: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "lineImage")?.withRenderingMode(.alwaysOriginal)
        return view
    }()
    
    let descriptionText: UITextView = {
        let textView = UITextView()
        textView.text = "Interdum et malesuada fames ac ante ipsum primis in faucibus. Sed ultricies felis at leö dldfnfdd placerat accumsan. Vestibulum non lss nibh rutrum sem pretium condimentum fu vopä scelerisque Ut imperdiet bibendum nisl pharetra hendrerit. Pellentesque vulputate dui ipsum, sit amet suscipit sapien luctus vitae. Sed urna ipsum, tristique sit amet mi quis, volutpat dignissim dolor. Mauris dignissim nec nibh dapibus varius. In viverra, justo in ullamcorper consequat, nisi ex viverra purus, vel placerat. Fu vopä scelerisque Ut imperdiet bibendum nisl pharetra hendrerit. Pellentesque vulputate dui ipsum, sit amet suscipit sapien luctus vitae. Sed urna ipsum. Vulputate dui ipsum, sit amet suscipit sapien luctus vitae. Sed urna ipsum, tristique sit amet mi quis, volutpat dignissim dolor."
        textView.textColor = UIColor.rgb(red: 105, green: 105, blue: 105, alpha: 1)
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        textView.isEditable = false
        textView.isScrollEnabled = true
        return textView
    }()
    
    lazy var likeIcon: UIButton = {
        let btn = UIButton()
        let likeImage = UIImage (named: "viewPostLike_selected")?.withRenderingMode(.alwaysOriginal)
        btn.setImage(likeImage, for: .normal)
        btn.isUserInteractionEnabled = true
        //btn.addTarget(self, action: #selector(likePost), for: .touchUpInside)
        btn.isEnabled = true
        return btn
    }()
    
    let likeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .right
        label.textColor = UIColor.rgb(red: 105, green: 105, blue: 105, alpha: 1)
        return label
    }()
    
    // ===== Edit Options =====
    let saveNavButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("save", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1), for: .normal)
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
        popupView.insertSubview(backNavButton, at: 6)
        popupView.insertSubview(postImageView, belowSubview: backNavButton)
        popupView.addSubview(descriptionLabel)
        popupView.addSubview(line)
        popupView.addSubview(likeIcon)
        popupView.addSubview(descriptionText)
        
        backNavButton.anchor(top: popupView.topAnchor, left: popupView.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        postImageView.anchor(top: popupView.topAnchor, left: popupView.leftAnchor, bottom: nil, right: popupView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 310)
        
        descriptionLabel.anchor(top: postImageView.bottomAnchor, left: popupView.leftAnchor, bottom: nil, right: popupView.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
        
        line.anchor(top: descriptionLabel.bottomAnchor, left: popupView.leftAnchor, bottom: nil, right: popupView.rightAnchor, paddingTop: 9, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 2)
        
        likeIcon.anchor(top: line.bottomAnchor, left: nil, bottom: nil, right: line.rightAnchor, paddingTop: 17, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 18, height: 17)
        
        descriptionText.anchor(top: likeIcon.bottomAnchor, left: popupView.leftAnchor, bottom: popupView.bottomAnchor, right: popupView.rightAnchor, paddingTop: 17, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 0)
        
        //Edit options
        saveNavButton.isHidden = true
    }
    
    func editMode() {
        popupView.insertSubview(backNavButton, at: 6)
        popupView.insertSubview(postImageView, belowSubview: backNavButton)
        popupView.addSubview(descriptionLabel)
        popupView.addSubview(line)
        popupView.addSubview(likeIcon)
        popupView.addSubview(descriptionText)
        
        backNavButton.anchor(top: popupView.topAnchor, left: popupView.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
         postImageView.anchor(top: popupView.topAnchor, left: popupView.leftAnchor, bottom: nil, right: popupView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 310)
        
        descriptionLabel.anchor(top: postImageView.bottomAnchor, left: popupView.leftAnchor, bottom: nil, right: popupView.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
        
        line.anchor(top: descriptionLabel.bottomAnchor, left: popupView.leftAnchor, bottom: nil, right: popupView.rightAnchor, paddingTop: 9, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 2)
        
        likeIcon.anchor(top: line.bottomAnchor, left: nil, bottom: nil, right: popupView.rightAnchor, paddingTop: 17, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 18, height: 17)
        
        descriptionText.anchor(top: likeIcon.bottomAnchor, left: popupView.leftAnchor, bottom: popupView.bottomAnchor, right: popupView.rightAnchor, paddingTop: 17, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 0)
        
        //Edit options
        saveNavButton.isHidden = false
        popupView.insertSubview(saveNavButton, at: 20)
        saveNavButton.anchor(top: popupView.topAnchor, left: nil, bottom: nil, right: popupView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 40, height: 40)
    }
 
    
}
