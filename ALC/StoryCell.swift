//
//  StoryCell.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-06.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit

class StoryCell: BaseCollectionCell {
    
    var story: Story? {
        didSet {
            
            guard let title = story?.title else {return}
            self.descriptionLabel.text = title
            
            guard let postCount = story?.posts?.count else {return}
            self.typeLabel.text = "POSTS \(postCount)"
            
            
//            guard let likes = post?.likes else {return}
//            self.likeLabel.text = "\(likes)"
//            
//            guard let comments = post?.comments else {return}
//            self.commentLabel.text = "\(comments)"
            
            //            guard let username = post?.postUserName else {return}
            //            self.usernameLabel.text = "\(username)"
            
//            guard let locationTag = post?.location else {return}
//            self.locationLabel.text = locationTag
            
            if let seconds = story?.timestamp?.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                self.timeLabel.text = dateFormatter.string(from: timestampDate as Date)
            }
            
            guard let imageUrl = story?.coverImageUrl else {return}
            postImageView.loadImageUsingCacheWithUrlString(urlString: imageUrl)
        }
    }
    
    // ============================
    // This is: Story cell, viewed in StoryTimeLine (the look)
    //
    // Cover image
    // Story title
    // Total: Number of posts (inside the story) - eg. Story posts 6
    // ============================
    
    let postContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = false
        view.clipsToBounds = true
        return view
    }()
    
    let profileImageThumb: CustomImageView = {
        let imageThumb = CustomImageView()
        imageThumb.backgroundColor = UIColor.lightGray
        imageThumb.layer.cornerRadius = 30
        imageThumb.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        imageThumb.layer.masksToBounds = false
        imageThumb.clipsToBounds = true
        imageThumb.contentMode = .scaleAspectFill
        imageThumb.layer.borderWidth = 3
        imageThumb.layer.borderColor = UIColor.white.cgColor
        imageThumb.image = UIImage(named: "")
        return imageThumb
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@username"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.textColor = UIColor.darkGray
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "POSTS 0"
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        return label
    }()
    
    //For Home feed
    let typeIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "typeStoryIcon")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    //For Profile view
    let storyPostNumberImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "storyPostNumberPhl")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let postImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "postImage_default")
        return imageView
    }()
    
    let commentIcon: UIButton = {
        let btn = UIButton()
        let commentImage = UIImage (named: "comment_unselected")
        btn.setImage(commentImage, for: .normal)
        btn.isUserInteractionEnabled = true
        btn.isEnabled = true
        return btn
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.text = "0"
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let likeIcon: UIButton = {
        let btn = UIButton()
        let likeImage = UIImage (named: "like_unselected")
        btn.setImage(likeImage, for: .normal)
        btn.isUserInteractionEnabled = true
        btn.isEnabled = true
        return btn
    }()
    
    let likeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0"
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Published story"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        label.textColor = UIColor.rgb(red: 237, green: 237, blue: 237, alpha: 1)
        return label
    }()
    
    let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        return view
    }()
    
    let descriptionContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.rgb(red: 39, green: 47, blue: 62, alpha: 0.8)
        return containerView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Story Title"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = UIColor.white
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor.clear
        
        insertSubview(postContainerView, at: 1)
        insertSubview(profileImageThumb, at: 7)
        addSubview(usernameLabel)
        addSubview(typeIconImageView)
        addSubview(storyPostNumberImageView)
        addSubview(typeLabel)
        postContainerView.insertSubview(postImageView, at: 1)
        insertSubview(descriptionContainerView, at: 4)
        addSubview(descriptionLabel)
        addSubview(timeLabel)
        addSubview(likeIcon)
        addSubview(commentIcon)
        
        //storyMode()
        self.isUserInteractionEnabled = true
    }
    
    //Profile View
    func storyMode() {
        postContainerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        profileImageThumb.anchor(top: postContainerView.topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        
        postImageView.anchor(top: postContainerView.topAnchor, left: leftAnchor, bottom: postContainerView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        usernameLabel.anchor(top: nil, left: profileImageThumb.rightAnchor, bottom: postImageView.topAnchor, right: nil, paddingTop: 2, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 180, height: 30)
        
        storyPostNumberImageView.anchor(top: postContainerView.topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 18, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 98, height: 27)
        //typeIconImageView.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor).isActive = true
        
        typeLabel.anchor(top: storyPostNumberImageView.topAnchor, left: storyPostNumberImageView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 65, height: 18)
        
        typeLabel.textColor = UIColor.rgb(red: 237, green: 237, blue: 237, alpha: 1)
        
        descriptionContainerView.anchor(top: nil, left: leftAnchor, bottom: postImageView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 0, height: 40)
        
        descriptionLabel.anchor(top: nil, left: descriptionContainerView.leftAnchor, bottom: nil, right: descriptionContainerView.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 100, width: 0, height: 20)
        descriptionLabel.centerYAnchor.constraint(equalTo: descriptionContainerView.centerYAnchor).isActive = true
        
        timeLabel.anchor(top: nil, left: descriptionLabel.rightAnchor, bottom: nil, right: descriptionContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
        timeLabel.centerYAnchor.constraint(equalTo: descriptionContainerView.centerYAnchor).isActive = true
        /*
        likeIcon.anchor(top: postImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 34, height: 34)
        
        commentIcon.anchor(top: postImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 34, height: 34)
 */
    }
    
    // Home feedView
    func viewStoryHomeFeed() {
        postContainerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        profileImageThumb.anchor(top: postContainerView.topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        
        postImageView.anchor(top: profileImageThumb.centerYAnchor, left: leftAnchor, bottom: postContainerView.bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        usernameLabel.anchor(top: nil, left: profileImageThumb.rightAnchor, bottom: postImageView.topAnchor, right: nil, paddingTop: 2, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 180, height: 35)
        
        typeIconImageView.anchor(top: nil, left: nil, bottom: postImageView.topAnchor, right: postContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 16, width: 21, height: 21)
        
        typeLabel.textAlignment = .right
        typeLabel.anchor(top: nil, left: nil, bottom: usernameLabel.bottomAnchor, right: typeIconImageView.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 180, height: 35)
        
        descriptionContainerView.anchor(top: nil, left: leftAnchor, bottom: postImageView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 0, height: 40)
        
        descriptionLabel.anchor(top: nil, left: descriptionContainerView.leftAnchor, bottom: nil, right: descriptionContainerView.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 100, width: 0, height: 20)
        descriptionLabel.centerYAnchor.constraint(equalTo: descriptionContainerView.centerYAnchor).isActive = true
        
        timeLabel.anchor(top: nil, left: descriptionLabel.rightAnchor, bottom: nil, right: descriptionContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
        timeLabel.centerYAnchor.constraint(equalTo: descriptionContainerView.centerYAnchor).isActive = true
        /*
        likeIcon.anchor(top: postImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 34, height: 34)
        
        commentIcon.anchor(top: postImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 34, height: 34)
 */
    }
    
}
