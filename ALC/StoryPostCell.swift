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
    
    let timeLineImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "timeLineImage")
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
        backgroundColor = UIColor.clear
        
        setupContents()
    }
    
    func setupContents() {
        addSubview(timeline)
        addSubview(timeLineImage)
        addSubview(storyPostCardImage)
        
        timeLineImage.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 13, paddingBottom: 0, paddingRight: 0, width: 22, height: 22)
        timeLineImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        storyPostCardImage.anchor(top: nil, left: timeLineImage.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 7, paddingBottom: 0, paddingRight: 14, width: 0, height: 100)
        storyPostCardImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    func viewStoryPostCell() {
        
    }
    
}
