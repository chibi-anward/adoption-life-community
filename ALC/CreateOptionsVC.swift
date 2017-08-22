//
//  CreateOptionsVC.swift
//  ALC
//
//  Created by Chibi Anward on 2017-08-13.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit

class CreateOptionsVC: UIView {
    
    let backNavButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("close", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1), for: .normal)
        //button.addTarget(self, action: #selector(backAction), for: .touchDown)
        return button
    }()
    
    let createPostIcon: UIButton = {
        let btn = UIButton()
        let image = UIImage (named: "postIcon_create")?.withRenderingMode(.alwaysOriginal)
        btn.setImage(image, for: .normal)
        btn.isUserInteractionEnabled = true
        btn.isEnabled = true
        //btn.addTarget(self, action: #selector(handleProfileImage), for: .touchUpInside)
        return btn
    }()
    
    let postIconLabel: UILabel = {
        let label = UILabel()
        label.text = "Post"
        return label
    }()
    
    let createStoryIcon: UIButton = {
        let btn = UIButton()
        let image = UIImage (named: "storyIcon_create")?.withRenderingMode(.alwaysOriginal)
        btn.setImage(image, for: .normal)
        btn.isUserInteractionEnabled = true
        btn.isEnabled = true
        //btn.addTarget(self, action: #selector(handleProfileImage), for: .touchUpInside)
        return btn
    }()
    
    let storyIconLabel: UILabel = {
        let label = UILabel()
        label.text = "Story"
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        let blurEffect = UIBlurEffect(style: .dark)
        let sideEffectView = UIVisualEffectView(effect: blurEffect)
        sideEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sideEffectView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        addSubview(sideEffectView)
        
        insertSubview(backNavButton, at: 4)
        backNavButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        addSubview(createPostIcon)
        addSubview(createStoryIcon)
        
        sizeStyle()
    }
    
    func sizeStyle() {
        if DeviceType.IS_IPHONE_5 {
            createPostIcon.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 60, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
            createPostIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            createStoryIcon.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 60, width: 80, height: 80)
            createStoryIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        } else {
            createPostIcon.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 80, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
            createPostIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            createStoryIcon.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 80, width: 80, height: 80)
            createStoryIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
