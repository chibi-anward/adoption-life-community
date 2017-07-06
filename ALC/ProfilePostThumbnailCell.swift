//
//  ProfilePostThumbnailCell.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-06.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit

class ProfilePostThumbnailCell: BaseCollectionCell {
    
    var post: Post? {
        didSet {
            
            guard let imageUrl = post?.imageUrl else {return}
            postImageView.loadImageUsingCacheWithUrlString(urlString: imageUrl)
        }
    }
    
    let postImageView: CustomImageView = {
        let imageView = CustomImageView()
        //imageView.image = UIImage(named: "postImage_default")
        imageView.backgroundColor = UIColor.lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        setupPost()
    }
    
    func setupPost() {
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }

}

