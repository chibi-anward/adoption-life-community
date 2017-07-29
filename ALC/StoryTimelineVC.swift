//
//  StoryTimelineVC.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-07.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit

class StoryTimelineVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // ============================
    // Story title
    // Story creator profile image
    // Filter by date
    // 
    // ============================
    
    let storyPosts = ["post 1", "post 2","post 3", "post 4"]
    
    let cellID = "cellID"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let backNavButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("back", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 100, green: 100, blue: 100, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(backAction), for: .touchDown)
        return button
    }()
    
    let titleText: UITextView = {
        let textView = UITextView()
        textView.text = "Story title"
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold)
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    let profileImageThumb: CustomImageView = {
        let imageThumb = CustomImageView()
        imageThumb.backgroundColor = UIColor.lightGray
        imageThumb.layer.cornerRadius = 20
        imageThumb.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageThumb.layer.masksToBounds = false
        imageThumb.clipsToBounds = true
        imageThumb.contentMode = .scaleAspectFill
        imageThumb.layer.borderWidth = 3
        imageThumb.layer.borderColor = UIColor.white.cgColor
        imageThumb.image = UIImage(named: "")
        return imageThumb
    }()
    
    let startStoryImageThumb: CustomImageView = {
        let imageThumb = CustomImageView()
        imageThumb.backgroundColor = UIColor.lightGray
        imageThumb.layer.cornerRadius = 12
        imageThumb.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        imageThumb.layer.masksToBounds = false
        imageThumb.clipsToBounds = true
        imageThumb.contentMode = .scaleAspectFill
        imageThumb.image = UIImage(named: "")
        return imageThumb
    }()
    
    let endStoryImageThumb: CustomImageView = {
        let imageThumb = CustomImageView()
        imageThumb.backgroundColor = UIColor.lightGray
        imageThumb.layer.cornerRadius = 12
        imageThumb.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        imageThumb.layer.masksToBounds = false
        imageThumb.clipsToBounds = true
        imageThumb.contentMode = .scaleAspectFill
        imageThumb.image = UIImage(named: "")
        return imageThumb
    }()
    
    let addNewStoryPostButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "saveDraftStoryPostBtn").withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    let saveNewStoryPostButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "saveStoryButton").withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    let timeline: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.rgb(red: 216, green: 216, blue: 216, alpha: 1)
        return line
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\nStoryTimeLineVC\n")
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        
        registerCell()
        
        setupBackNavigation()
        setupContents()
    }
    
    func setupBackNavigation() {
        view.addSubview(backNavButton)
        backNavButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 35, height: 40)
    }
    
    func setupContents() {
        view.addSubview(titleText)
        view.addSubview(profileImageThumb)
        view.addSubview(startStoryImageThumb)
        view.addSubview(endStoryImageThumb)
        view.addSubview(addNewStoryPostButton)
        view.addSubview(saveNewStoryPostButton)
        view.addSubview(collectionView)
        view.addSubview(timeline)
        
        titleText.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 65, paddingBottom: 0, paddingRight: 30, width: 0, height: 30)
        
        profileImageThumb.anchor(top: titleText.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileImageThumb.centerXAnchor.constraint(equalTo: titleText.centerXAnchor).isActive = true
        
        startStoryImageThumb.anchor(top: profileImageThumb.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 24, height: 24)
        
        saveNewStoryPostButton.anchor(top: nil, left: startStoryImageThumb.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 18, paddingBottom: 20, paddingRight: 20, width: 0, height: 48)
        
        addNewStoryPostButton.anchor(top: nil, left: startStoryImageThumb.rightAnchor, bottom: saveNewStoryPostButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 18, paddingBottom: 10, paddingRight: 20, width: 0, height: 48)
        
        collectionView.anchor(top: startStoryImageThumb.bottomAnchor, left: view.leftAnchor, bottom: addNewStoryPostButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 20, paddingRight: 16, width: 0, height: 0)
        
        endStoryImageThumb.anchor(top: collectionView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 24, height: 24)
        
        timeline.anchor(top: startStoryImageThumb.bottomAnchor, left: nil, bottom: endStoryImageThumb.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 2, height: 0)
        timeline.centerXAnchor.constraint(equalTo: startStoryImageThumb.centerXAnchor).isActive = true
    }
    
    func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //
    func registerCell() {
        collectionView.register(StoryPostCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! StoryPostCell
            cell.setupContentCreateNewPost()
        return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! StoryPostCell
        cell.setupContents()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storyPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
        return CGSize(width: collectionView.frame.width, height: 90)
        }
        return CGSize(width: collectionView.frame.width, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        let viewStory = StoryViewPostVC()
        self.present(viewStory, animated: true, completion: nil)
    }
    
}
