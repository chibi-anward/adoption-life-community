//
//  StoryPostCell.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-07.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit

class StoryPostCell: BaseCollectionCell {
    
    // ============================
    // This is: Each story post (the look)
    // Show max
    // Likes
    // Comments
    // ============================
    
    let timeline: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.rgb(red: 0, green: 216, blue: 216, alpha: 1)
        return line
    }()
    
    //CREATE NEW POST
    let addNewStoryPostBtn: UIImageView = {
        let btn = UIImageView()
        btn.image = UIImage(named: "addStoryPostButton")
        return btn
    }()
    
    let timeLineNewPostMarker: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "timeLineNewPostMarker")
        return image
    }()
    
    //Story Post
    let timeLineImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "timeLineImage")
        return image
    }()
    
    let storyPostCardImage: CustomImageView = {
        let cardImage = CustomImageView()
        cardImage.image = UIImage(named: "storyPostCard_default")?.withRenderingMode(.alwaysOriginal)
        cardImage.contentMode = .scaleAspectFill
        cardImage.layer.cornerRadius = 8
        cardImage.layer.masksToBounds = false
        cardImage.clipsToBounds = true
        return cardImage
    }()
    
    let storyPostTitle: UITextView = {
        let textView = UITextView()
        textView.isUserInteractionEnabled = false
        textView.text = "Post Title... g"
        textView.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .left
        return textView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 246, alpha: 1)
        //cv.delegate = self
        //cv.dataSource = self
        return cv
    }()
    
    let storyPostImageThumb: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "typeIcon")
        return imageView
    }()
    
   
    
    override func setupViews() {
        super.setupViews()
        print("\nSTORY POST CELL")
        backgroundColor = UIColor.clear
        
        addSubview(timeline)
        addSubview(timeLineImage)
        
        // Create new Story Post
        addSubview(addNewStoryPostBtn)
        addSubview(timeLineNewPostMarker)
        
        //Story Post
        addSubview(storyPostCardImage)
        
    }
    
    //Story Post
    func setupStoryPostCell() {
        timeLineImage.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 13, paddingBottom: 0, paddingRight: 0, width: 22, height: 22)
        timeLineImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        storyPostCardImage.anchor(top: nil, left: timeLineImage.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 7, paddingBottom: 0, paddingRight: 14, width: 0, height: 150)
        storyPostCardImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        storyPostCardImage.addSubview(storyPostTitle)
        storyPostTitle.anchor(top: storyPostCardImage.topAnchor, left: storyPostCardImage.leftAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 180, height: 25)
        
        
        
    }
    
    // Create new Story Post
    func setupContentCreateNewStoryPost() {
        timeLineNewPostMarker.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 13, paddingBottom: 0, paddingRight: 0, width: 22, height: 4)
        timeLineNewPostMarker.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addNewStoryPostBtn.anchor(top: topAnchor, left: timeLineNewPostMarker.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 7, paddingBottom: 0, paddingRight: 14, width: 0, height: 0)
    }
  
    
}
