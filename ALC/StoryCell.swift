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
    // Number of posts (inside the story) - eg. Story posts 6
    // Likes
    // Comments
    // ============================
    
    let storyTitle: UILabel = {
        let label = UILabel()
        label.text = "Story title"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = UIColor.white
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor.purple
        
        setupContents()
    }
    
    
    func setupContents() {
        let descriptionContainerView = UIView()
        addSubview(descriptionContainerView)
        descriptionContainerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        descriptionContainerView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        descriptionContainerView.addSubview(storyTitle)
        storyTitle.anchor(top: nil, left: descriptionContainerView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        storyTitle.centerYAnchor.constraint(equalTo: descriptionContainerView.centerYAnchor).isActive = true
        storyTitle.centerXAnchor.constraint(equalTo: descriptionContainerView.centerXAnchor).isActive = true
    }
    
}
