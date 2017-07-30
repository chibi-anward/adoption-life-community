//
//  HomePostCell.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-06.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit
import Firebase

protocol HomePostCellDelegate {
    func didLike(for cell: HomePostCell)
}

//MARK:
class HomePostCell: BaseCollectionCell {
    
    var delegate: HomePostCellDelegate?
    
    
    var post: Post? {
        didSet {
            
            guard let caption = post?.caption else {return}
            self.descriptionLabel.text = caption
            
            guard let likes = post?.likes else {return}
            self.likeLabel.text = "\(likes)"
            
            guard let comments = post?.comments else {return}
            self.commentLabel.text = "\(comments)"
            
//            guard let username = post?.postUserName else {return}
//            self.usernameLabel.text = "\(username)"
            
            guard let locationTag = post?.location else {return}
            self.locationLabel.text = locationTag
            
            if let seconds = post?.timestamp?.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                self.timeLabel.text = dateFormatter.string(from: timestampDate as Date)
            }
            
            guard let imageUrl = post?.imageUrl else {return}
            postImageView.loadImageUsingCacheWithUrlString(urlString: imageUrl)
        }
    }
    
    let postContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 8
        return view
    }()
    
    let postBottomContainerView: UIView = {
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
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "countryLabel"
        label.font = UIFont.systemFont(ofSize: 11)
        label.numberOfLines = 2
        label.textAlignment = .right
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let locationPinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "locationPin")
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
        label.textColor = UIColor.lightGray
        return label
    }()
    
    lazy var likeIcon: UIButton = {
        let btn = UIButton()
        let likeImage = UIImage (named: "like_unselected")
        btn.setImage(likeImage, for: .normal)
        btn.isUserInteractionEnabled = true
        btn.addTarget(self, action: #selector(likePost), for: .touchUpInside)
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
        label.text = "Maecenas et nibh tristique sem eleifend laoreet. Sed finibus lorem vitae metus convallis, eu faucibus quam tristique."
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = UIColor.white
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor.clear
        //setupPost()
        setupPostView()
        self.isUserInteractionEnabled = true
    }
    
    //MARK:
    func likePost() {
        delegate?.didLike(for: self)
    }
    
    func setupPostView() {
        
        //postContainerView.roundCorners(corners: [.topLeft, .topRight], radius: 8)
        //postBottomContainerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 8)
        
        insertSubview(postContainerView, at: 1)
        insertSubview(profileImageThumb, at: 7)
        addSubview(usernameLabel)
        addSubview(locationPinImageView)
        addSubview(locationLabel)
        insertSubview(postImageView, at: 2)
        insertSubview(descriptionContainerView, at: 4)
        addSubview(descriptionLabel)
        addSubview(timeLabel)
        addSubview(likeIcon)
        addSubview(commentIcon)
        
        
        postContainerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        profileImageThumb.anchor(top: postContainerView.topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        
        postImageView.anchor(top: profileImageThumb.centerYAnchor, left: leftAnchor, bottom: postContainerView.bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 50, paddingRight: 0, width: 0, height: 0)
        
        usernameLabel.anchor(top: nil, left: profileImageThumb.rightAnchor, bottom: postImageView.topAnchor, right: nil, paddingTop: 2, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 180, height: 30)
        
        locationPinImageView.anchor(top: nil, left: nil, bottom: nil, right: postContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 10, height: 13)
        locationPinImageView.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor).isActive = true
        
        locationLabel.anchor(top: nil, left: nil, bottom: usernameLabel.bottomAnchor, right: locationPinImageView.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 180, height: 35)
        
        descriptionContainerView.anchor(top: nil, left: leftAnchor, bottom: postImageView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 0, height: 40)
        
        descriptionLabel.anchor(top: nil, left: descriptionContainerView.leftAnchor, bottom: nil, right: descriptionContainerView.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 100, width: 0, height: 20)
        descriptionLabel.centerYAnchor.constraint(equalTo: descriptionContainerView.centerYAnchor).isActive = true
        
        timeLabel.anchor(top: nil, left: descriptionLabel.rightAnchor, bottom: nil, right: descriptionContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
        timeLabel.centerYAnchor.constraint(equalTo: descriptionContainerView.centerYAnchor).isActive = true
        
        likeIcon.anchor(top: postImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 34, height: 34)
        
         commentIcon.anchor(top: postImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 34, height: 34)
        
    }
    
    
    func setupPost() {
        addSubview(postContainerView)
        addSubview(postBottomContainerView)
        
        
                postBottomContainerView.addSubview(likeLabel)
        likeLabel.anchor(top: nil, left: nil, bottom: nil, right: postBottomContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 6, width: 40, height: 15)
        likeLabel.centerYAnchor.constraint(equalTo: postBottomContainerView.centerYAnchor).isActive = true
        
        insertSubview(likeIcon, at: 11)
        likeIcon.anchor(top: nil, left: nil, bottom: nil, right: likeLabel.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 38, height: 38)
        likeIcon.centerYAnchor.constraint(equalTo: postBottomContainerView.centerYAnchor).isActive = true
        
        postBottomContainerView.addSubview(commentLabel)
        commentLabel.anchor(top: nil, left: nil, bottom: nil, right: likeIcon.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 6, width: 40, height: 15)
        commentLabel.centerYAnchor.constraint(equalTo: postBottomContainerView.centerYAnchor).isActive = true
        
        
        insertSubview(commentIcon, at: 10)
        commentIcon.anchor(top: nil, left: nil, bottom: nil, right: commentLabel.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 38, height: 38)
        commentIcon.centerYAnchor.constraint(equalTo: postBottomContainerView.centerYAnchor).isActive = true
    }
    
    
}
