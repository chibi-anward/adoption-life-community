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
    // Likes
    // Comments
    // ============================
    
    //CREATE NEW POST
    let addNewStoryPostButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "addStoryPostButton").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(test), for: .touchUpInside)
        return btn
    }()
    
    let addNewStoryPostBtn: UIImageView = {
        let btn = UIImageView()
        btn.image = UIImage(named: "addStoryPostButton")
        return btn
    }()
    
    let timeLineImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "timeLineImage")
        return image
    }()
    
    let timeLineNewPostMarker: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "timeLineNewPostMarker")
        return image
    }()
    
    let timeline: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.rgb(red: 0, green: 216, blue: 216, alpha: 1)
        return line
    }()
    
    let storyPostCardImage: UIImageView = {
        let cardImage = UIImageView()
        cardImage.image = UIImage(named: "storyPostCard_default")
        return cardImage
    }()
    
    override func setupViews() {
        super.setupViews()
        print("\nSTORY POST CELL")
        backgroundColor = UIColor.clear
        
        addSubview(timeline)
        addSubview(timeLineImage)
        addSubview(storyPostCardImage)
        addSubview(addNewStoryPostBtn)
        addSubview(timeLineNewPostMarker)
        
    }
    
    func setupContents() {
        timeLineImage.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 13, paddingBottom: 0, paddingRight: 0, width: 22, height: 22)
        timeLineImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        storyPostCardImage.anchor(top: nil, left: timeLineImage.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 7, paddingBottom: 0, paddingRight: 14, width: 0, height: 100)
        storyPostCardImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    func setupContentCreateNewPost() {
        timeLineNewPostMarker.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 13, paddingBottom: 0, paddingRight: 0, width: 22, height: 4)
        timeLineNewPostMarker.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addNewStoryPostBtn.anchor(top: topAnchor, left: timeLineNewPostMarker.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 7, paddingBottom: 0, paddingRight: 14, width: 0, height: 0)
    }
    
    func test() {
        print("test")
    }
    
}
