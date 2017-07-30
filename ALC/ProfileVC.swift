//
//  ProfileVC.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-06.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ProfileHeaderCellDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let profilePostThumnailCellID = "profilePostThumnailCellID"
    let profileHeaderCellId = "profileHeaderCellId"
    //let homePostCellID = "homePostCellID"
    
    let storyCellID = "storyCellID"
    let storyCreateCellID = "storyCreateCellID"
    
    var isGridView = true
    var pickerType = ""
    
    var posts = [Post]()
    var stories = [Story]()
    
    //var stories = ["create", "A", "B", "C"]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 246, alpha: 1)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let editIcon: UIButton = {
        let btn = UIButton()
        let likeImage = UIImage (named: "CreatePost_Tab")
        btn.setImage(likeImage, for: .normal)
        btn.isUserInteractionEnabled = true
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(handleProfileImage), for: .touchUpInside)
        return btn
    }()
    
    let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.isHidden = true
        return view
    }()
    
    var createStoryPopup = StoryCreateStoryVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\nProfileVC\n")
        navigationItem.title = "Profile"
        
        addCollectionView()
        registerCell()
        
        fetchOrderedPosts()
        fetchOrderedStories()
        
               
        blurEffect()
        self.view.insertSubview(createStoryPopup.popupView, at: 17)
        createStoryPopup.backNavButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        createStoryPopup.saveNavButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        createStoryPopup.coverImageTextOverlay.addTarget(self, action: #selector(handleStoryCoverImage), for: .touchUpInside) //SAVE COVER IMAGE TO STORY
        
        createStoryPopup.storyTitle.delegate = self
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(" return ")
        textField.resignFirstResponder()
        dismissKeyboard()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(" end editing ")
        Variables.StoryTitle = textField.text!
        textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        
        if (textField.textColor == UIColor.darkGray) {
            textField.text = ""
            textField.textColor = UIColor.black
        }
        print(" begin editing ")
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
        print("\nGoToYourStory\n")
        let storyTimeline = StoryTimelineVC()
        self.present(storyTimeline, animated: true, completion: nil)
    }
    
    func blurEffect() {
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 15)
    }
    
    func createStoryPopupAction() {
        UIView.animate(withDuration: 1.8, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.createStoryPopup.addMode()
            self.blurEffectView.isHidden = false
            self.createStoryPopup.popupView.isHidden = false
            self.createStoryPopup.popupView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (finished: Bool) in
        }
    }
    
   
    
    func close() {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.blurEffectView.isHidden = true
            self.createStoryPopup.popupView.isHidden = true
            self.createStoryPopup.popupView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (finished: Bool) in
        }
    }

    func save() {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.blurEffectView.isHidden = true
            self.createStoryPopup.popupView.isHidden = true
            self.createStoryPopup.popupView.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            // FIREBASE STORE STORY
           
                
                AppDelegate.instance().showActivityIndicator()
                
                let storyCoverImageUrl = Variables.StoryCoverImageUrl
                let storyTitle = Variables.StoryTitle
                guard let uid = Auth.auth().currentUser?.uid else {return}
                let timestamp = NSNumber(value: Date().timeIntervalSince1970)
            
                
                let userPostRef = Database.database().reference().child("agencies").child(Variables.Agency).child("stories").child(uid)
                let userPostAutoId = userPostRef.childByAutoId()
                let key = userPostAutoId.key
                // state: public or draft
                let values = ["coverImageUrl": storyCoverImageUrl,
                              "title": storyTitle,
                              "timestamp": timestamp,
                              "state": "public",
                              "uid": uid] as [String : Any]
                userPostAutoId.updateChildValues(values) { (error, reference) in
                    if error != nil {
                        AppDelegate.instance().dismissActivityIndicator()
                        //self.navigationItem.rightBarButtonItem?.isEnabled = true
                        print("Failed to save post")
                        return
                    }
                    print("success")
                    AppDelegate.instance().dismissActivityIndicator()
                    //self.backFunction()
                }
            
            
        }) { (finished: Bool) in
        }
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
        
            header.user = Variables.CurrentUserProfile
        
        header.delegate = self
        
        //
        header.addSubview(editIcon)
        editIcon.anchor(top: nil, left: nil, bottom: header.profileImageView.bottomAnchor, right: header.profileImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 8, width: 25, height: 25)
        
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
        
        header.profileImageView.loadImageUsingCacheWithUrlString(urlString: (Variables.CurrentUserProfile?.ProfileImageUrl)!)
        
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
            // CREATE STORY BUTTON
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: storyCreateCellID, for: indexPath) as! StoryCreateCell
                return cell
            }
            //DRAFT VERSION
            //if indexPath.row == 1 {
            //STORIES (IF CURRENT USER, DONT SHOW PROFILE IMAGE & USERNAME)!
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: storyCellID, for: indexPath) as! StoryCell
            cell.profileImageThumb.isHidden = true
            cell.usernameLabel.isHidden = true
                cell.descriptionLabel.text = stories[indexPath.item].title
            if let seconds = stories[indexPath.item].timestamp?.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                cell.timeLabel.text = dateFormatter.string(from: timestampDate as Date)
            }
            cell.postImageView.loadImageUsingCacheWithUrlString(urlString: stories[indexPath.item].coverImageUrl)
            cell.typeLabel.text = "POSTS \( stories[indexPath.item].posts.count )"
                
            return cell
            //}
//            else {
//                //PUBLISHED VERSION
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: storyCellID, for: indexPath) as! StoryCell
//                cell.profileImageThumb.isHidden = true
//                cell.usernameLabel.isHidden = true
//                //cell.stories = stories[indexPath.item]
//                return cell
//            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        if isGridView {
            print("Grid")
        } else {
            print("List")
            if indexPath.row == 0 {
                createStoryPopupAction()
            } else {
                goToYourStory()
            }
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
            //Post Cell
        let width = (view.frame.width - 3) / 3
        return CGSize(width: width, height: width)
        } else {
            //Create New Story
            if indexPath.row == 0 {
                return CGSize(width: UIScreen.main.bounds.width, height: 60)
            }
            // Story Cell
            return CGSize(width: UIScreen.main.bounds.width, height: 280)
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
            
            self.posts.sort(by: { $0.timestamp?.compare($1.timestamp!) == .orderedDescending})
            
            DispatchQueue.main.async {
                print("fetchOrderedPosts")
                self.collectionView.reloadData()
            }
        }, withCancel: nil)
    }
    
    fileprivate func fetchOrderedStories() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        stories.removeAll()
        let ref = Database.database().reference().child("agencies").child(Variables.Agency).child("stories").child(uid)
        ref.queryOrdered(byChild: "timestamp").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            
            
            let story = Story(dictionary: dictionary)
            self.stories.append(story)
            
            self.stories.sort(by: { $0.timestamp?.compare($1.timestamp!) == .orderedDescending})
            
            DispatchQueue.main.async {
                print("fetchOrderedStories")
                self.collectionView.reloadData()
            }
        }, withCancel: nil)
    }

    
    //MARK: StoryCoverImage
    func handleStoryCoverImage() {
        pickerType = "cover"
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    //MARK: ProfileImage
    func handleProfileImage() {
        pickerType = "profile"
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if (pickerType == "profile") {
            print("profile")
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            guard let uploadData = UIImageJPEGRepresentation(editedImage, 0.1) else { return }
            
            let filename = NSUUID().uuidString
            Storage.storage().reference().child("profile_images").child(filename).putData(uploadData, metadata: nil, completion: { (metadata, err) in
                
                if let err = err {
                    print ("Failed to upload profile image", err)
                    return
                }
                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
                
                print("Successfully uploaded profile image", profileImageUrl)
                
                //CREATE USER
                guard let uid = Variables.CurrentUser?.uid else { return }
                let dictionaryValues = ["ProfileImageUrl": profileImageUrl,
                                        "uid": uid,
                                        "agency": Variables.CurrentUserProfile?.Agency,
                                        "invitecode": Variables.CurrentUserProfile?.InviteCode,
                                        "username": Variables.CurrentUserProfile?.UserName]
                let values = [uid: dictionaryValues]
                
                //Firebase call for ADOPTEE
                Database.database().reference().child("agencies").child(Variables.Agency).child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if let err = err {
                        print("Failed to save user into DB", err)
                        return
                    }
                    print("Successfully saved user into DB!")
                    
                    Variables.CurrentUserProfile?.ProfileImageUrl = profileImageUrl
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        
                    }
  
                    
                })
            })
        }
        } else {
        // Story Cover Image
            print(" cover ")
            if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
                
                guard let uploadData = UIImageJPEGRepresentation(editedImage, 0.1) else { return }
                
                let filename = NSUUID().uuidString
                Storage.storage().reference().child("cover_images").child(filename).putData(uploadData, metadata: nil, completion: { (metadata, err) in
                    
                    if let err = err {
                        print ("Failed to upload profile image", err)
                        return
                    }
                    guard let coverImageUrl = metadata?.downloadURL()?.absoluteString else { return }
                    
                    Variables.StoryCoverImageUrl = coverImageUrl
                    
                    print("Successfully uploaded cover image", coverImageUrl)
                    
                    self.createStoryPopup.coverImageView.loadImageUsingCacheWithUrlString(urlString: coverImageUrl)
                    self.createStoryPopup.coverImageTextOverlay.setTitle("", for: .normal)
                    
                })
            }
        }
        dismiss(animated: true, completion: nil)
    }

}
