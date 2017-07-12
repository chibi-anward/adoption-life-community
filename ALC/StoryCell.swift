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
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor.purple
    }
    
}
