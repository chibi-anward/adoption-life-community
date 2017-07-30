//
//  StoryCell.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-06.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit

class StoryCell: BaseCollectionCell {
    
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
        label.text = "POSTS 4"
        label.font = UIFont.systemFont(ofSize: 11)
        label.numberOfLines = 2
        label.textAlignment = .right
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let typeIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "typeIcon")
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
        addSubview(typeLabel)
        postContainerView.insertSubview(postImageView, at: 1)
        insertSubview(descriptionContainerView, at: 4)
        addSubview(descriptionLabel)
        addSubview(timeLabel)
        addSubview(likeIcon)
        addSubview(commentIcon)
        
        storyMode()
        self.isUserInteractionEnabled = true
    }
    
    func storyMode() {
        postContainerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        profileImageThumb.anchor(top: postContainerView.topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        
        postImageView.anchor(top: postContainerView.topAnchor, left: leftAnchor, bottom: postContainerView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        usernameLabel.anchor(top: nil, left: profileImageThumb.rightAnchor, bottom: postImageView.topAnchor, right: nil, paddingTop: 2, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 180, height: 30)
        
        typeIconImageView.anchor(top: postContainerView.topAnchor, left: nil, bottom: nil, right: postContainerView.rightAnchor, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 10, height: 13)
        //typeIconImageView.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor).isActive = true
        
        typeLabel.anchor(top: postContainerView.topAnchor, left: nil, bottom: nil, right: typeIconImageView.leftAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 180, height: 35)
        
        typeLabel.textColor = UIColor.rgb(red: 237, green: 237, blue: 237, alpha: 1)
        
        descriptionContainerView.anchor(top: nil, left: leftAnchor, bottom: postImageView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 0, height: 40)
        
        descriptionLabel.anchor(top: nil, left: descriptionContainerView.leftAnchor, bottom: nil, right: descriptionContainerView.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 100, width: 0, height: 20)
        descriptionLabel.centerYAnchor.constraint(equalTo: descriptionContainerView.centerYAnchor).isActive = true
        
        timeLabel.anchor(top: nil, left: descriptionLabel.rightAnchor, bottom: nil, right: descriptionContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
        timeLabel.centerYAnchor.constraint(equalTo: descriptionContainerView.centerYAnchor).isActive = true
        
        likeIcon.anchor(top: postImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 34, height: 34)
        
        commentIcon.anchor(top: postImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 34, height: 34)
    }
    
    func viewStoryHomeFeed() {
        postContainerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        profileImageThumb.anchor(top: postContainerView.topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        
        postImageView.anchor(top: profileImageThumb.centerYAnchor, left: leftAnchor, bottom: postContainerView.bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 50, paddingRight: 0, width: 0, height: 0)
        
        usernameLabel.anchor(top: nil, left: profileImageThumb.rightAnchor, bottom: postImageView.topAnchor, right: nil, paddingTop: 2, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 180, height: 30)
        
        typeIconImageView.anchor(top: nil, left: nil, bottom: nil, right: postContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 10, height: 13)
        typeIconImageView.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor).isActive = true
        
        typeLabel.anchor(top: nil, left: nil, bottom: usernameLabel.bottomAnchor, right: typeIconImageView.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 180, height: 35)
        
        descriptionContainerView.anchor(top: nil, left: leftAnchor, bottom: postImageView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 0, height: 40)
        
        descriptionLabel.anchor(top: nil, left: descriptionContainerView.leftAnchor, bottom: nil, right: descriptionContainerView.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 100, width: 0, height: 20)
        descriptionLabel.centerYAnchor.constraint(equalTo: descriptionContainerView.centerYAnchor).isActive = true
        
        timeLabel.anchor(top: nil, left: descriptionLabel.rightAnchor, bottom: nil, right: descriptionContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
        timeLabel.centerYAnchor.constraint(equalTo: descriptionContainerView.centerYAnchor).isActive = true
        
        likeIcon.anchor(top: postImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 34, height: 34)
        
        commentIcon.anchor(top: postImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 34, height: 34)
    }
    
}
