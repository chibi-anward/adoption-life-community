//
//  ProfileHeaderCell.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-06.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit

protocol ProfileHeaderCellDelegate {
    func didChangeToListView()
    func didChangeToGridView()
}

class ProfileHeaderCell: BaseCollectionCell {
    
    var delegate: ProfileHeaderCellDelegate?
    var profile: Profile? {
        didSet {
            guard let username = profile?.UserName else {return}
            usernameLabel.text = username
            
            guard let profileImageUrl = profile?.ProfileImageUrl else {return}
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
    }
    
    /*
     var user: User? {
     didSet {
     print(2)
     guard let profileImageUrl = user?.profileImageUrl else {return}
     profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
     }
     }
     */
    
    //Dummy
    let isCurrentUser = true
    
    lazy var profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.backgroundColor = UIColor.white
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.rgb(red: 220, green: 220, blue: 220, alpha: 1).cgColor
        return imageView
    }()
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "username"
        return label
    }()
    
    let countryLabel: UILabel = {
        let label = UILabel()
        label.text = "countryLabel"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.textColor = UIColor.lightGray
        return label
    }()
    
    lazy var postButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "toolBarIcon_default"), for: .normal)
        btn.setTitle("Posts", for: .normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0,left: 30,bottom: 0,right: 10)
        btn.addTarget(self, action: #selector(handleChangeToGridView), for: .touchDown)
        return btn
    }()
    
    lazy var storyButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "toolBarIcon_default"), for: .normal)
        btn.tintColor = UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 0.2)
        btn.setTitle("Stories", for: .normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0,left: 30,bottom: 0,right: 10)
        btn.addTarget(self, action: #selector(handleChangeToListView), for: .touchDown)
        return btn
    }()
    
    let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220, alpha: 1)
        return view
    }()
    
    let toolTopDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220, alpha: 1)
        return view
    }()
    
    let toolDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220, alpha: 1)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        //backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        addSubview(profileImageView)
        addSubview(dividerLine)
        
        setupHeaderObjects()
        setupToolBar()
    }
    /*
    func storyButtonAction() {
        if isCurrentUser == true {
            print("Is Current User")
            handleChangeToListView()
            //let profileVC = ProfileVC()
            //profileVC.goToYourStories()
        } else {
            print("NOT Current User")
            handleChangeToListView()
        }
    }
    */
    
    func handleChangeToListView() {
        storyButton.tintColor = UIColor.rgb(red: 100, green: 100, blue: 100, alpha: 1)
        postButton.tintColor = UIColor.rgb(red: 220, green: 220, blue: 220, alpha: 1)
        delegate?.didChangeToListView()
    }
    
    func handleChangeToGridView() {
        postButton.tintColor = UIColor.rgb(red: 100, green: 100, blue: 100, alpha: 1)
        storyButton.tintColor = UIColor.rgb(red: 220, green: 220, blue: 220, alpha: 1)
        delegate?.didChangeToGridView()
    }
    
    fileprivate func setupToolBar() {
        let stackView = UIStackView(arrangedSubviews: [postButton, storyButton])
        
        stackView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(toolDividerLine)
        addSubview(toolDividerLine)
        
        stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        
        toolDividerLine.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        
    }
    
    fileprivate func setupHeaderObjects() {
        profileImageView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: profileImageView.frame.width, height: 18)
        usernameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        dividerLine.anchor(top: nil, left: nil, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 1)
    }
    
}
