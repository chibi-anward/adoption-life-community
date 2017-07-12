//
//  ProfileVC.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-06.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ProfileHeaderCellDelegate {
    
    let profilePostThumnailCellID = "profilePostThumnailCellID"
    let profileHeaderCellId = "profileHeaderCellId"
    //let homePostCellID = "homePostCellID"
    
    let storyCellID = "storyCellID"
    let storyCreateCellID = "storyCreateCellID"
    
    var isGridView = true
    
    var posts = [Post]()
    
    var stories = ["create", "A", "B"]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 246, alpha: 1)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Profile"
        
        addCollectionView()
        registerCell()
        
        fetchOrderedPosts()
        
    }

    func didChangeToGridView() {
        print("didChangeToGridView")
        isGridView = true
        collectionView.reloadData()
    }
    
    func didChangeToListView() {
        print("didChangeToListView")
        isGridView = false
        collectionView.reloadData()
    }
    
    func goToYourStory() {
        print("Go To Your Stories")
        let storyTimeline = StoryTimelineVC()
        self.present(storyTimeline, animated: true, completion: nil)
    }
    
    func addCollectionView() {
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func registerCell() {
        collectionView.register(ProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: profileHeaderCellId)
        collectionView.register(ProfilePostThumbnailCell.self, forCellWithReuseIdentifier: profilePostThumnailCellID)
        //collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellID)
        
        collectionView.register(StoryCreateCell.self, forCellWithReuseIdentifier: storyCreateCellID)
        collectionView.register(StoryCell.self, forCellWithReuseIdentifier: storyCellID)
    }
    
    //Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: profileHeaderCellId, for: indexPath) as! ProfileHeaderCell
        
            header.profile = Variables.CurrentUserProfile
        
        header.delegate = self
        
        /*
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("agency").child("css").child("members").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            guard let username = dictionary["username"] as? String else { return }
            header.usernameLabel.text = username
            
            if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                header.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
            }
        }) { (err) in
            print("Can't fetch profile information", err)
        }
        */
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isGridView {
            return posts.count
        } else {
            return stories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isGridView {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profilePostThumnailCellID, for: indexPath) as! ProfilePostThumbnailCell
        cell.post = posts[indexPath.item]
        return cell
        } else {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: storyCreateCellID, for: indexPath) as! StoryCreateCell
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: storyCellID, for: indexPath) as! StoryCell
            //cell.stories = stories[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        if indexPath.row == 0 {
            print("Create new story")
        } else {
            goToYourStory()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGridView {
        let width = (view.frame.width - 3) / 3
        return CGSize(width: width, height: width)
        } else {
            if indexPath.row == 0 {
                return CGSize(width: UIScreen.main.bounds.width, height: 60)
            }
            return CGSize(width: UIScreen.main.bounds.width, height: 220)
        }
    }
    
    fileprivate func fetchOrderedPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        posts.removeAll()
        let ref = Database.database().reference().child("agencies").child(Variables.Agency).child("posts").child(uid)
        ref.queryOrdered(byChild: "timestamp").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            let post = Post(dictionary: dictionary)
            self.posts.append(post)
            DispatchQueue.main.async {
                print("fetchOrderedPosts")
                self.collectionView.reloadData()
            }
        }, withCancel: nil)
    }
    
}
