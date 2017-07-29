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
    
    let buttonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "createNewStory")
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = UIColor.rgb(red: 54, green: 206, blue: 239, alpha: 1)
        
        setupContents()
        
    }
    
    func setupContents() {
        addSubview(buttonImageView)
        buttonImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 60)
    }
    
}
