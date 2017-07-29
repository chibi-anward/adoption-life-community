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

    let addNewStoryPostButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "createNewStoryBtn").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.isEnabled = false
        return btn
    }()
    
    let addNewStoryPost: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "createNewStoryBtn")
        return image
    }()
    
    override func setupViews() {
        super.setupViews()
        
        //backgroundColor = UIColor.rgb(red: 54, green: 206, blue: 239, alpha: 1)
        
        setupContents()
        
    }
    
    func setupContents() {
        
        addSubview(addNewStoryPostButton)
        addNewStoryPostButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
 
    }
    
}
