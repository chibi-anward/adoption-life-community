//
//  StoryCreateCell.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-11.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit

class StoryCreateCell: BaseCollectionCell {
    
    // ============================
    // This is: Create a new Story BUTTON (the look)
    // ============================
    /*
    let buttonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "createNewStory")
        return imageView
    }()
    */
    let addNewStoryPostButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "createNewStoryBtn").withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = UIColor.rgb(red: 54, green: 206, blue: 239, alpha: 1)
        
        setupContents()
        
    }
    
    func setupContents() {
        
        addSubview(addNewStoryPostButton)
        addNewStoryPostButton.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 48)
        addNewStoryPostButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
 
        /*
        addSubview(buttonImageView)
        buttonImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 60)
 */
    }
    
}
