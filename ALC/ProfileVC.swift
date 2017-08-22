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
    
    let profilePostThumnailCellID = "pvarilePostThumnailCellID"
    let profileHeaderCellId = "profileHeaderCellId"
    
    let storyCellID = "storyCellID"
    
    var isGridView = true
    var pickerType = ""
    
    var refresher = UIRefreshControl()
    var posts = [Post]()
    var stories = [Story]()
    var selectedPost: Post? = nil
    
    
    let bgTopImage: UIImageView = {
        let imageThumb = UIImageView()
        imageThumb.layer.masksToBounds = false
        imageThumb.clipsToBounds = true
        imageThumb.contentMode = .scaleAspectFill
        imageThumb.image = UIImage(named: "bgTopImage")
        return imageThumb
    }()
    
    let bgImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bg_gradient")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let vcTitle: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.textAlignment = .center
        label.textColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: 12)
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.clear
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let editImageIcon: UIButton = {
        let btn = UIButton()
        let likeImage = UIImage (named: "editImageIcon")
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
    var viewPostPopup = ViewPostVC()
    
    func refresh() {
  
        fetchOrderedPosts { (success) in
            self.fetchOrderedStories(completionHandler: { (success) in
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //refresh()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Variables.SelectedProfileUser = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        view.insertSubview(bgTopImage, at: 1)
        view.insertSubview(bgImage, at: 2)
        
        bgTopImage.anchor(top: topLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 210)
        
        bgImage.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: bottomLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(vcTitle)
        vcTitle.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 35, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 35)
        
        addCollectionView()
        registerCell()
               
        blurEffect()
        self.navigationController!.view.insertSubview(createStoryPopup.popupView, at: 17)
        createStoryPopup.backNavButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        createStoryPopup.saveNavButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        createStoryPopup.coverImageTextOverlay.addTarget(self, action: #selector(handleStoryCoverImage), for: .touchUpInside) //SAVE COVER IMAGE TO STORY
        
        createStoryPopup.storyTitle.delegate = self
        
        self.navigationController!.view.insertSubview(viewPostPopup.popupView, at: 17)
        viewPostPopup.backNavButton.addTarget(self, action: #selector(closeViewPost), for: .touchUpInside)
        viewPostPopup.deleteNavButton.addTarget(self, action: #selector(deleteUserPost), for: .touchUpInside)
        viewPostPopup.saveNavButton.addTarget(self, action: #selector(updateUserPost), for: .touchUpInside)
        
        //refresher.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
       // collectionView.addSubview(refresher)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchOrderedPosts), name:NSNotification.Name(rawValue: "refreshPosts"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name:NSNotification.Name(rawValue: "refreshStories"), object: nil)

        refresh()
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
        if ( posts.count == 0 ) {
            refresh()
        } else {
            collectionView.reloadData()
        }
    }
    
    func didChangeToListView() {
        print("didChangeToListView")
        isGridView = false
        if ( stories.count == 0 ) {
            refresh()
        } else {
            collectionView.reloadData()
        }
    }
    let storyTimeline = StoryTimelineVC()
    func goToYourStory(indexPath: IndexPath) {
        print("\nGoToYourStory\n")
        //let storyTimeline = StoryTimelineVC()
        storyTimeline.storyPosts = stories[indexPath.item].posts!
        storyTimeline.story = stories[indexPath.item]
        self.disableEditModeStory()
        if( Variables.CurrentUser?.uid == stories[indexPath.item].uid  ) {
            storyTimeline.editButton.isHidden = false
            storyTimeline.editButton.addTarget(self, action: #selector(enableEditModeStory), for: .touchUpInside)
        } else {
            storyTimeline.editButton.isHidden = true
        }
        self.present(storyTimeline, animated: true, completion: nil)
    }
    
    func blurEffect() {
        window = UIWindow(frame: UIScreen.main.bounds)
        blurEffectView.frame = self.navigationController!.view.bounds
        //blurEffectView.frame = self.tabBarController!.tabBar.bounds
        self.navigationController!.view.insertSubview(blurEffectView, at: 15)
    }
    
    func createStoryPopupAction() {
        UIView.animate(withDuration: 1.8, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.tabBarController?.tabBar.isHidden = true
            self.createStoryPopup.addMode()
            self.blurEffectView.isHidden = false
            self.createStoryPopup.popupView.isHidden = false
            self.createStoryPopup.popupView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (finished: Bool) in
        }
    }
    
    func editPostPopupAction(indexPath: IndexPath) {
        UIView.animate(withDuration: 1.8, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.tabBarController?.tabBar.isHidden = true
            self.viewPostPopup.editMode()
            self.viewPostPopup.post = self.posts[indexPath.item]
            self.viewPostPopup.loadPost()
            self.blurEffectView.isHidden = false
            self.viewPostPopup.popupView.isHidden = false
            self.viewPostPopup.popupView.transform = CGAffineTransform(scaleX: 0.9, y: 0.89)
        }) { (finished: Bool) in
            
        }
    }
    
    func viewPostPopupAction(indexPath: IndexPath) {
        UIView.animate(withDuration: 1.8, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.tabBarController?.tabBar.isHidden = true
            self.viewPostPopup.viewMode()
            self.viewPostPopup.post = self.posts[indexPath.item]
            self.viewPostPopup.loadPost()
            self.disableEditMode()
            if ( Variables.CurrentUser?.uid == self.posts[indexPath.item].postUID ) {
                self.viewPostPopup.editButton.isHidden = false
                self.viewPostPopup.editButton.addTarget(self, action: #selector(self.enableEditMode), for: .touchUpInside)
            } else {
                self.viewPostPopup.editButton.isHidden = true
            }
            Variables.isStoryPost = false
            self.blurEffectView.isHidden = false
            self.viewPostPopup.popupView.isHidden = false
            self.viewPostPopup.popupView.transform = CGAffineTransform(scaleX: 0.9, y: 0.89)
        }) { (finished: Bool) in
            
        }
    }
    
    func disableEditMode() {
        self.viewPostPopup.deleteNavButton.isHidden = true
        self.viewPostPopup.descriptionText.isUserInteractionEnabled = false
        self.viewPostPopup.descriptionText.isEditable = false
        self.viewPostPopup.descriptionLabel.isUserInteractionEnabled = false
    }
    
    func enableEditMode() {
        let alertController = UIAlertController(title: "Edit mode enabled", message: "Select text you want to edit", preferredStyle: .alert)
        // if iPads
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        alertController.popoverPresentationController?.permittedArrowDirections = []

        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
        self.viewPostPopup.deleteNavButton.isHidden = false
        self.viewPostPopup.descriptionText.isUserInteractionEnabled = true
        self.viewPostPopup.descriptionText.isEditable = true
        self.viewPostPopup.descriptionLabel.isUserInteractionEnabled = true
    }

    func disableEditModeStory() {
       // self.storyTimeline.saveDraftStoryButton.isHidden = true
       // self.storyTimeline.editImageIcon.isHidden = true
    }
    
    func enableEditModeStory() {
//        let alertController = UIAlertController(title: "Edit mode enabled", message: "Select text you want to edit", preferredStyle: .alert)
//        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//        alertController.addAction(defaultAction)
//        self.present(alertController, animated: true, completion: nil)
        
      //  self.storyTimeline.saveDraftStoryButton.isHidden = false
      //  self.storyTimeline.editImageIcon.isHidden = false
    }
    
    func close() {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.tabBarController?.tabBar.isHidden = false
            self.blurEffectView.isHidden = true
            self.createStoryPopup.popupView.isHidden = true
            self.createStoryPopup.popupView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (finished: Bool) in
        }
    }
    
    func closeViewPost() {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.tabBarController?.tabBar.isHidden = false
            self.blurEffectView.isHidden = true
            self.viewPostPopup.popupView.isHidden = true
            self.viewPostPopup.popupView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (finished: Bool) in
            self.fetchOrderedPosts(completionHandler: { (success) in
                
            })
        }
    }
    
    
    func updateUserPost() {
        print("save / update post")
        print( selectedPost! )
        selectedPost?.caption = viewPostPopup.descriptionLabel.text!
        selectedPost?.text = viewPostPopup.descriptionText.text
        let dataHandler = DataHandler()
        dataHandler.editPost(post: selectedPost!, isStory: false, story: nil) { (success) in
            print("post updated")
            self.closeViewPost()
            self.fetchOrderedPosts(completionHandler: { (nil) in
                DispatchQueue.main.async(execute: { () -> Void in
                    self.collectionView.reloadData()
                })
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
                self.dismissKeyboard()
            })
            
            
        }
        
    }
    
    func deleteUserPost() {
        let dataHandler = DataHandler()
        dataHandler.deletePost(post: selectedPost!, isStory: false, story: nil) { (success) in
            print("post deleted")
            self.closeViewPost()
            self.fetchOrderedPosts(completionHandler: { (nil) in
                DispatchQueue.main.async(execute: { () -> Void in
                    self.collectionView.reloadData()
                })
            })
 
            
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
                              "publishDate": timestamp,
                              "state": "draft",
                              "id" : key,
                              "uid": uid,
                              "profileUserImageUrl" : Variables.CurrentUserProfile?.ProfileImageUrl ?? "",
                              "profileUserName" : Variables.CurrentUserProfile?.UserName ?? ""
                              ] as [String : Any]
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
                    self.fetchOrderedStories(completionHandler: { (success) in
                        
                    })
                }
            
            
        }) { (finished: Bool) in
        }
    }
    
    func addCollectionView() {
        view.addSubview(collectionView)
        collectionView.anchor(top: topLayoutGuide.topAnchor, left: view.leftAnchor, bottom: bottomLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 75, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func registerCell() {
        collectionView.register(ProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: profileHeaderCellId)
        collectionView.register(ProfilePostThumbnailCell.self, forCellWithReuseIdentifier: profilePostThumnailCellID)
        //collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellID)
        //collectionView.register(StoryCreateCell.self, forCellWithReuseIdentifier: storyCreateCellID)
        collectionView.register(StoryCell.self, forCellWithReuseIdentifier: storyCellID)
    }
    
    //Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: profileHeaderCellId, for: indexPath) as! ProfileHeaderCell
        
        if ( Variables.SelectedProfileUser != nil ) {
            header.user = Variables.SelectedProfileUser
        } else {
            header.user = Variables.CurrentUserProfile
        }
        
        
        header.delegate = self
        
        //
        header.addSubview(editImageIcon)
        editImageIcon.anchor(top: nil, left: nil, bottom: header.profileImageView.bottomAnchor, right: header.profileImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 8, width: 25, height: 25)
        
        header.addNewStoryPostButton.addTarget(self, action: #selector(createStoryPopupAction), for: .touchUpInside)
        
        if (header.user?.ProfileImageUrl != nil) {
            header.profileImageView.loadImageUsingCacheWithUrlString(urlString: (header.user?.ProfileImageUrl)!)
        }
        
        if isGridView {
            header.postButton.setImage(#imageLiteral(resourceName: "postBtn_profile_selected"), for: .normal)
            header.storyButton.setImage(#imageLiteral(resourceName: "storyBtn_profile_unselected"), for: .normal)
        } else {
            header.postButton.setImage(#imageLiteral(resourceName: "postBtn_profile_unselected"), for: .normal)
            header.storyButton.setImage(#imageLiteral(resourceName: "storyBtn_profile_selected"), for: .normal)
        }
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: storyCellID, for: indexPath) as! StoryCell
            cell.storyMode()
            cell.profileImageThumb.isHidden = true
            cell.usernameLabel.isHidden = true
                cell.descriptionLabel.text = stories[indexPath.item].title
            if let seconds = stories[indexPath.item].timestamp?.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                let nowDate = Date()
                let fullString = nowDate.offsetFrom(date: timestampDate as Date)
                let toShow = fullString.components(separatedBy: " ")[0]
                cell.timeLabel.text = toShow
            }
            cell.postImageView.loadImageUsingCacheWithUrlString(urlString: stories[indexPath.item].coverImageUrl)
            
            if let postCount = stories[indexPath.item].posts?.count {
                cell.typeLabel.text = "POSTS \(postCount)"
            }
            
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        if isGridView {
            print("Posts")
            selectedPost = self.posts[indexPath.item]
            Variables.SelectedIndexPath = indexPath
            // Check currentUser post or else
//            if (Variables.CurrentUser?.uid == self.posts[indexPath.item].postUID) {
//                editPostPopupAction(indexPath: indexPath)
//            } else {
                viewPostPopupAction(indexPath: indexPath)
//            }
        } else {
            print("Stories")
            goToYourStory(indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGridView {
            //Post Cell
        let width = (view.frame.width - 3) / 3
        return CGSize(width: width, height: width)
        } else {
            //Create New Story
            return CGSize(width: UIScreen.main.bounds.width, height: 260)
        }
    }
    

    
    func fetchOrderedPosts(completionHandler:@escaping (Bool) -> ()) {
        var uid = ""
        if ( Variables.CurrentUser != nil ) {
            uid = (Auth.auth().currentUser?.uid)!
        }
        if (Variables.SelectedProfileUser != nil) {
            uid = (Variables.SelectedProfileUser?.UID)!
        }
         if( uid == "" ) { return }
        
        _ = Database.database().reference().child("agencies").child(Variables.Agency).child("posts").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
        //ref.queryOrdered(byChild: "timestamp").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            
            self.posts.removeAll()
            for _post in dictionary {
                let post = Post(dictionary: _post.value as! [String : Any])
                self.posts.append(post)
                self.posts.sort(by: { $0.timestamp?.compare($1.timestamp!) == .orderedDescending})
            }
            completionHandler(true)
        }, withCancel: nil)
    }
    
    func fetchOrderedStories(completionHandler:@escaping (Bool) -> ()) {
        var uid = ""
        if ( Variables.CurrentUser != nil ) {
            uid = (Auth.auth().currentUser?.uid)!
        }
        if (Variables.SelectedProfileUser != nil) {
            uid = (Variables.SelectedProfileUser?.UID)!
        }
        
        if( uid == "" ) { return }
        
        _ = Database.database().reference().child("agencies").child(Variables.Agency).child("stories").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
        
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            
            self.stories.removeAll()
            for _story in dictionary {
               
                var story = Story(dictionary: _story.value as! [String : Any])
                
                if (_story.value["posts"]!) != nil {
                    let posts = _story.value["posts"] as! NSDictionary
                    for post in posts {
                        let p = Post(dictionary: post.value as! [String : Any])
                        story.posts?.append(p)
                    }
                }
                
                if ( (Variables.SelectedProfileUser?.UID != nil && story.state != "draft" ) || Variables.SelectedProfileUser?.UID == nil  ) {
                    self.stories.append(story)
                }
                
                self.stories.sort(by: { $0.timestamp?.compare($1.timestamp!) == .orderedDescending})
                completionHandler(true)
                
                print( self.stories.count )

                
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
