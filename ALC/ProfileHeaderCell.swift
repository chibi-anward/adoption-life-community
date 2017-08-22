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
    var user: Profile? {
        didSet {
            guard let username = user?.UserName else {return}
            usernameLabel.text = username
            
            guard let profileImageUrl = user?.ProfileImageUrl else {return}
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
    }
    
    //Dummy
    let isCurrentUser = true
    
    lazy var profileImageFrame: UIView = {
        let imageView = UIView()
        imageView.frame = CGRect(x: 0, y: 0, width: 110, height: 110)
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.layer.borderWidth = 10
        imageView.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 0.2).cgColor
        return imageView
    }()
    lazy var profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.backgroundColor = UIColor.white
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        //imageView.layer.borderWidth = 6
        //imageView.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 0.3).cgColor
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
        let btn = UIButton()
        let btnImage = UIImage (named: "postBtn_profile_selected")
        btn.setImage(btnImage, for: .normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0,left: 30,bottom: 0,right: 10)
        btn.addTarget(self, action: #selector(handleChangeToGridView), for: .touchDown)
        return btn
    }()
    
    lazy var storyButton: UIButton = {
        let btn = UIButton()
        let btnImage = UIImage (named: "storyBtn_profile_unselected")
        btn.setImage(btnImage, for: .normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0,left: 30,bottom: 0,right: 10)
        btn.addTarget(self, action: #selector(handleChangeToListView), for: .touchDown)
        return btn
    }()
    
    let line: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "lineImage")?.withRenderingMode(.alwaysOriginal)
        return view
    }()
    
    let toolTopDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 0.1)
        return view
    }()
    
    let toolDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 0.1)
        return view
    }()
    
    let addNewStoryPostButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "createNewStoryBtn").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.isEnabled = false
        btn.isHidden = true
        return btn
    }()
    
    let profileFrame: UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage(named: "profileFrame")?.withRenderingMode(.alwaysOriginal)
        return imageV
    }()
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = UIColor.clear
        insertSubview(profileFrame, belowSubview: profileImageView)
        addSubview(profileImageView)
        addSubview(line)
        addSubview(addNewStoryPostButton)
        setupHeaderObjects()
        setupToolBar()
    }
    
    func handleChangeToListView() {
        addNewStoryPostButton.isHidden = false
        addNewStoryPostButton.isEnabled = true
        delegate?.didChangeToListView()
    }
    
    func handleChangeToGridView() {
        addNewStoryPostButton.isHidden = true
        addNewStoryPostButton.isEnabled = false
        delegate?.didChangeToGridView()
    }
    
    fileprivate func setupToolBar() {
        let stackView = UIStackView(arrangedSubviews: [postButton, storyButton])
        
        //stackView.backgroundColor = UIColor.rgb(red: 100, green: 255, blue: 255, alpha: 1)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(toolDividerLine)
        addSubview(toolDividerLine)
        
        stackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 22, paddingRight: 0, width: 0, height: 36)
        
        
        toolDividerLine.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        
    }
    
    fileprivate func setupHeaderObjects() {
        
        profileImageView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        profileFrame.anchor(top: profileImageView.topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        insertSubview(profileImageFrame, belowSubview: profileImageView)
        profileImageFrame.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 110, height: 110)
        profileImageFrame.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        profileImageFrame.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: profileImageView.frame.width, height: 18)
        usernameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        addNewStoryPostButton.anchor(top: usernameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 36)
        addNewStoryPostButton.centerXAnchor.constraint(equalTo: usernameLabel.centerXAnchor).isActive = true
        
        line.anchor(top: nil, left: nil, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 75, paddingRight: 0, width: frame.width, height: 1)
    }
    
}
