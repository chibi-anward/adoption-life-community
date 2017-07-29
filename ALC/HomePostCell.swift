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
        let commentImage = UIImage (named: "comment_icon_default")
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
        let likeImage = UIImage (named: "like_icon_default")
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
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        return view
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "descriptionLabel ..."
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = UIColor.white
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor.rgb(red: 200, green: 200, blue: 200, alpha: 1)
        setupPost()
        self.isUserInteractionEnabled = true
    }
    
    //MARK:
    func likePost() {
        delegate?.didLike(for: self)
    }
    
//    @objc func unlikePost(sender: UIButton!) {
//        let row = sender.tag
//        //let post = posts[row]
//        
//        guard let uid = Variables.CurrentUser?.uid else { return }
//        
//        let selectedPost = Variables.Posts[row].postID //
//        let postUID = Variables.Posts[row].postUID //
//        
//        let ref = Database.database().reference()
//        
//        var keyToPost: String?
//        
//        for people in Variables.Posts[row].userWhoLike! {
//            if people.value as? String == uid {
//                keyToPost = people.key
//                Variables.Posts[row].userWhoLike?[keyToPost!] = nil
//                ref.child("agencies").child(Variables.Agency).child("posts").child(postUID).child(selectedPost).child("userWhoLike").child(keyToPost!).removeValue()
//            }
//        }
//        
//        //get values of the post
//        ref.child("agency").child("css").child("posts").child(postUID).child(selectedPost).observeSingleEvent(of: .value, with: { (snapshot) in
//            if let post = snapshot.value as? [String: AnyObject] {
//                
//                ref.child("agency").child("css").child("posts").child(postUID).child(selectedPost).observeSingleEvent(of: .value, with: { (snap) in
//                    if let properties = snap.value as? [String: AnyObject] {
//                        if let likes = properties["userWhoLike"] as? [String: AnyObject] {
//                            let count = likes.count
//                            let update = ["likes": count,
//                                          "IHaveLiked": false] as [String : Any]
//                            ref.child("agency").child("css").child("posts").child(postUID).child(selectedPost).updateChildValues(update)
//                            self.posts[row].likes = count
//                            self.posts[row].IHaveLiked = false
//                            self.collectionView?.reloadData()
//                        }
//                    }
//                    
//                })
//            }
//        }, withCancel: nil)
//        ref.removeAllObservers()
//    }
    
    
    
    func setupPost() {
        let postHeaderContainerView = UIView()
        addSubview(postHeaderContainerView)
        postHeaderContainerView.backgroundColor = UIColor.white
        
        postHeaderContainerView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        insertSubview(profileImageThumb, at: 6)
        
        profileImageThumb.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        
        postHeaderContainerView.addSubview(usernameLabel)
        usernameLabel.anchor(top: nil, left: postHeaderContainerView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 82, paddingBottom: 0, paddingRight: 0, width: 180, height: postHeaderContainerView.frame.height)
        usernameLabel.centerYAnchor.constraint(equalTo: postHeaderContainerView.centerYAnchor).isActive = true
        
        postHeaderContainerView.addSubview(locationPinImageView)
        locationPinImageView.anchor(top: nil, left: nil, bottom: nil, right: postHeaderContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 10, height: 13)
        locationPinImageView.centerYAnchor.constraint(equalTo: postHeaderContainerView.centerYAnchor).isActive = true
        
        postHeaderContainerView.addSubview(locationLabel)
        locationLabel.anchor(top: nil, left: nil, bottom: nil, right: locationPinImageView.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 180, height: 50)
        locationLabel.centerYAnchor.constraint(equalTo: postHeaderContainerView.centerYAnchor).isActive = true
        
        let postBottomContainerView = UIView()
        addSubview(postBottomContainerView)
        postBottomContainerView.backgroundColor = UIColor.white
        
        postBottomContainerView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 68)
        
        insertSubview(postImageView, at: 1)
        postImageView.anchor(top: postHeaderContainerView.bottomAnchor, left: leftAnchor, bottom: postBottomContainerView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        postBottomContainerView.addSubview(timeLabel)
        timeLabel.anchor(top: nil, left: postBottomContainerView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 80, height: 15)
        timeLabel.centerYAnchor.constraint(equalTo: postBottomContainerView.centerYAnchor).isActive = true
        
        postBottomContainerView.addSubview(likeLabel)
        likeLabel.anchor(top: nil, left: nil, bottom: nil, right: postBottomContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 6, width: 40, height: 15)
        likeLabel.centerYAnchor.constraint(equalTo: postBottomContainerView.centerYAnchor).isActive = true
        
        insertSubview(likeIcon, at: 11)
        likeIcon.anchor(top: nil, left: nil, bottom: nil, right: likeLabel.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 16, height: 15)
        likeIcon.centerYAnchor.constraint(equalTo: postBottomContainerView.centerYAnchor).isActive = true
        
        postBottomContainerView.addSubview(commentLabel)
        commentLabel.anchor(top: nil, left: nil, bottom: nil, right: likeIcon.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 6, width: 40, height: 15)
        commentLabel.centerYAnchor.constraint(equalTo: postBottomContainerView.centerYAnchor).isActive = true
        
        
        insertSubview(commentIcon, at: 10)
        commentIcon.anchor(top: nil, left: nil, bottom: nil, right: commentLabel.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 18, height: 15)
        commentIcon.centerYAnchor.constraint(equalTo: postBottomContainerView.centerYAnchor).isActive = true
        
        addSubview(dividerLine)
        dividerLine.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        let descriptionContainerView = UIView()
        addSubview(descriptionContainerView)
        descriptionContainerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        descriptionContainerView.anchor(top: nil, left: leftAnchor, bottom: postBottomContainerView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        descriptionContainerView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: nil, left: descriptionContainerView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        descriptionLabel.centerYAnchor.constraint(equalTo: descriptionContainerView.centerYAnchor).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: descriptionContainerView.centerXAnchor).isActive = true
    }
}
