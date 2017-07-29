//
//  StoryCreateStoryVC.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-29.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit

class StoryCreateStoryVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // ===================================
    // Cover image
    // Story Title
    // ===================================
 
    
    let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        view.frame = CGRect(x: 0, y: 80, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2.4)
        view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.isHidden = true
        view.layer.cornerRadius = 6
        return view
    }()
    
    let backNavButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("close", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 100, green: 100, blue: 100, alpha: 1), for: .normal)
        //button.addTarget(self, action: #selector(backAction), for: .touchDown)
        return button
    }()
    
    let informationLabel: UILabel = {
        let label = UILabel()
        label.text = "Create a story"
        label.textAlignment = .center
        return label
    }()
    
    let storyTitle: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.rgb(red: 100, green: 100, blue: 100, alpha: 0.1)
        textField.layer.cornerRadius = 8
        textField.text = "Story title"
        textField.textAlignment = .center
        return textField
    }()
    
    lazy var coverImageView: CustomImageView = {
        let imageView = CustomImageView()
        //imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 0.7)
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.rgb(red: 220, green: 220, blue: 220, alpha: 1).cgColor
        imageView.image = UIImage(named: "storyCoverImageDefault.png")
        return imageView
    }()
    
    let coverImageTextOverlay: UIButton = {
        let btn = UIButton()
        btn.setTitle("Cover Image", for: .normal)
        return btn
    }()
    
    let saveNavButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("save", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 100, green: 100, blue: 100, alpha: 1), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\nSTORY CREATE STORY")
        view.backgroundColor = UIColor.rgb(red: 200, green: 255, blue: 255, alpha: 1)
    }
    
    func addMode() {
        popupView.addSubview(backNavButton)
        backNavButton.anchor(top: popupView.topAnchor, left: popupView.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        popupView.addSubview(saveNavButton)
        saveNavButton.anchor(top: popupView.topAnchor, left: nil, bottom: nil, right: popupView.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 40, height: 40)
        
        popupView.addSubview(informationLabel)
        informationLabel.anchor(top: backNavButton.bottomAnchor, left: popupView.leftAnchor, bottom: nil, right: popupView.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 0, width: 0, height: 30)
        
        popupView.addSubview(storyTitle)
        storyTitle.anchor(top: informationLabel.bottomAnchor, left: popupView.leftAnchor, bottom: nil, right: popupView.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        
        popupView.addSubview(coverImageView)
        coverImageView.anchor(top: storyTitle.bottomAnchor, left: popupView.leftAnchor, bottom: popupView.bottomAnchor, right: popupView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 0)
        
        coverImageView.insertSubview(coverImageTextOverlay, at: 6)
        coverImageTextOverlay.anchor(top: coverImageView.topAnchor, left: coverImageView.leftAnchor, bottom: coverImageView.bottomAnchor, right: coverImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    
}
