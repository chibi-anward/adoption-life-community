//
//  StoryTimelineVC.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-07.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit
import Firebase

class StoryTimelineVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // ============================
    // Story title
    // Story Cover image
    // Filter by date
    // ============================
    
    
    var storyPosts = [Post]()
    //var story = Story(dictionary: [:])
    var post = Post(dictionary: [:])
    var textTitle = ""
    
    var story: Story? {
        didSet {
            
            guard let title = story?.title else {return}
            self.titleText.text = title
//
            
            var postLikes = 0
            for p in storyPosts {
                postLikes = postLikes + p.likes!
            }
           
//            self.likeLabel.text = "\(likes)"
            
            //            guard let comments = post?.comments else {return}
            //            self.commentLabel.text = "\(comments)"
            
            //            guard let username = post?.postUserName else {return}
            //            self.usernameLabel.text = "\(username)"
            
            //            guard let locationTag = post?.location else {return}
            //            self.locationLabel.text = locationTag
            
//            if let seconds = story?.timestamp?.doubleValue {
//                let timestampDate = NSDate(timeIntervalSince1970: seconds)
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "hh:mm:ss a"
//                self.timeLabel.text = dateFormatter.string(from: timestampDate as Date)
//            }
//            
            guard let imageUrl = story?.coverImageUrl else {return}
            coverImageThumb.loadImageUsingCacheWithUrlString(urlString: imageUrl)
        }
    }
    
    let cellID = "cellID"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.clear
        cv.delegate = self
        cv.dataSource = self
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    let bgImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bg_gradient")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let backNavButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("back", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 0.9), for: .normal)
        button.addTarget(self, action: #selector(backAction), for: .touchDown)
        return button
    }()
    
    let titleText: UITextField = {
        let textView = UITextField()
        textView.text = "Story title"
        textView.textAlignment = .center
        textView.textColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 0.9)
        textView.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold)
        textView.isUserInteractionEnabled = true
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        return textView
    }()
    
    let coverImageThumb: CustomImageView = {
        let imageThumb = CustomImageView()
        imageThumb.layer.masksToBounds = false
        imageThumb.clipsToBounds = true
        imageThumb.contentMode = .scaleAspectFill
        imageThumb.image = UIImage(named: "")
        return imageThumb
    }()
    
    let editIcon: UIButton = {
        let btn = UIButton()
        let likeImage = UIImage (named: "createPost_tab")
        btn.setImage(likeImage, for: .normal)
        btn.isUserInteractionEnabled = true
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(handleStoryCoverImage), for: .touchUpInside) // Change Cover Image
        return btn
    }()
    
    let startStoryImageThumb: CustomImageView = {
        let imageThumb = CustomImageView()
        imageThumb.backgroundColor = UIColor.lightGray
        imageThumb.layer.cornerRadius = 25
        imageThumb.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageThumb.layer.masksToBounds = false
        imageThumb.clipsToBounds = true
        imageThumb.contentMode = .scaleAspectFill
        imageThumb.image = UIImage(named: "addNewStoryTimeline")?.withRenderingMode(.alwaysOriginal)
        return imageThumb
    }()
    
    let endStoryImageThumb: CustomImageView = {
        let imageThumb = CustomImageView()
        imageThumb.backgroundColor = UIColor.lightGray
        imageThumb.layer.cornerRadius = 25
        imageThumb.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageThumb.layer.masksToBounds = false
        imageThumb.clipsToBounds = true
        imageThumb.contentMode = .scaleAspectFill
        imageThumb.image = UIImage(named: "publishStory")?.withRenderingMode(.alwaysOriginal)
        return imageThumb
    }()
    
    let saveDraftStoryButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "saveDraftStoryBtn").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(createStoryPostPopupAction), for: .touchUpInside)
        return btn
    }()
    
    let publishStoryPostButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "publishStoryButton").withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    let timeline: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.rgb(red: 216, green: 216, blue: 216, alpha: 1)
        return line
    }()
    
    let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.isHidden = true
        return view
    }()
    
    var viewPostPopup = ViewPostVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        
        view.insertSubview(coverImageThumb, at: 1)
        view.insertSubview(bgImage, at: 2)
        
        coverImageThumb.anchor(top: topLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 210)
        
        bgImage.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        registerCell()
        
        //hideKeyboardWhenTappedAround()
        
        titleText.delegate = self
        
        setupBackNavigation()
        setupContents()
        
        blurEffect()
        self.view.insertSubview(viewPostPopup.popupView, at: 17)
        viewPostPopup.backNavButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        viewPostPopup.saveNavButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        //let dictionary =
        //let dummyPost = Post.init(dictionary: <#T##[String : Any]#>) (dictionary: <#T##[String : Any]#>)
        
        post = Post.init(dictionary: [
            "caption" : "dummy",
            "imageUrl" : "https://firebasestorage.googleapis.com/v0/b/adoption-life-community.appspot.com/o/posts-image%2F6C4A0F48-9A10-4EA9-9CE4-C4B7797F53A8?alt=media&token=452f3b96-b176-49b1-abe6-850836f61edd",
            "timestamp" : 1501325124.306627,
            "likes" : 1,
            "comments" : 0,
            "imageWidth" : 100,
            "imageHeight" : 100,
            "postID" : "123123",
            "postUID" : "123123",
            "location" : "Stockholm",
            "userWhoLike" : [:],
            "IHaveLiked" : false,
            "postUserName" : "namn"
            ])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textTitle = textField.text!
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if ( textField.text != textTitle ) {
            guard let uid = Auth.auth().currentUser?.uid else {return}
            Database.database().reference().child("agencies").child(Variables.Agency).child("stories").child(uid).child((self.story?.id)!).observeSingleEvent(of: .value, with: {( snapshot ) in
                
                let values =  snapshot.value as! NSMutableDictionary
                values.setValue(textField.text, forKey: "title")
                
                Database.database().reference().child("agencies").child(Variables.Agency).child("stories").child(uid).child((self.story?.id)!).updateChildValues(values as! [AnyHashable : Any]) { (error, reference) in
                    if error != nil {
                        AppDelegate.instance().dismissActivityIndicator()
                        //self.navigationItem.rightBarButtonItem?.isEnabled = true
                        print("Failed to save post")
                        return
                    }
                    print("success")
                    
                }
                
                
                
            })
        }
    }
    func handleStoryCoverImage() {
        //pickerType = "cover"
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Story Cover Image
        
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
                self.coverImageThumb.loadImageUsingCacheWithUrlString(urlString: coverImageUrl)
                
                let storyCoverImageUrl = Variables.StoryCoverImageUrl
                
                guard let uid = Auth.auth().currentUser?.uid else {return}
                
                
                
                Database.database().reference().child("agencies").child(Variables.Agency).child("stories").child(uid).child((self.story?.id)!).observeSingleEvent(of: .value, with: {( snapshot ) in
                    
                    let values =  snapshot.value as! NSMutableDictionary
                    values.setValue(storyCoverImageUrl, forKey: "coverImageUrl")
                    
                    Database.database().reference().child("agencies").child(Variables.Agency).child("stories").child(uid).child((self.story?.id)!).updateChildValues(values as! [AnyHashable : Any]) { (error, reference) in
                        if error != nil {
                            AppDelegate.instance().dismissActivityIndicator()
                            //self.navigationItem.rightBarButtonItem?.isEnabled = true
                            print("Failed to save post")
                            return
                        }
                        print("success")
                        
                    }
                })
            })
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func blurEffect() {
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 15)
    }
    
    func createStoryPostPopupAction() {
        UIView.animate(withDuration: 1.8, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.viewPostPopup.editMode()
            self.blurEffectView.isHidden = false
            self.viewPostPopup.popupView.isHidden = false
            self.viewPostPopup.popupView.transform = CGAffineTransform(scaleX: 0.9, y: 0.89)
        }) { (finished: Bool) in
            
        }
    }
    
    func viewStoryPostPopupAction(indexPath: IndexPath) {
        UIView.animate(withDuration: 1.8, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.viewPostPopup.viewMode()
            self.viewPostPopup.post = self.storyPosts[indexPath.item]
            self.viewPostPopup.loadPost()
            self.blurEffectView.isHidden = false
            self.viewPostPopup.popupView.isHidden = false
            self.viewPostPopup.popupView.transform = CGAffineTransform(scaleX: 0.9, y: 0.89)
        }) { (finished: Bool) in
            
        }
    }
    
    func save() {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            print("save story post")
            
            
            AppDelegate.instance().showActivityIndicator()
            
            let userPostRef = Database.database().reference().child("agencies").child(Variables.Agency).child("stories").child((Variables.CurrentUser?.uid)!).child((self.story?.id)!).child("posts")
            let userPostAutoId = userPostRef.childByAutoId()
            let key = userPostAutoId.key
            
            let values = self.post.dictionaryRepresentation
            
            
            userPostAutoId.updateChildValues(values) { (error, reference) in
                if error != nil {
                    AppDelegate.instance().dismissActivityIndicator()
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to save post")
                    return
                }
                print("success")
                AppDelegate.instance().dismissActivityIndicator()
                //self.backFunction()
                
                self.storyPosts.append(self.post)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
            
            
            self.blurEffectView.isHidden = true
            self.viewPostPopup.popupView.isHidden = true
            self.viewPostPopup.popupView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (finished: Bool) in
        }
    }
    
    func close() {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.blurEffectView.isHidden = true
            self.viewPostPopup.popupView.isHidden = true
            self.viewPostPopup.popupView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (finished: Bool) in
        }
    }
    
    func setupBackNavigation() {
        view.addSubview(backNavButton)
        backNavButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 35, height: 40)
    }
    
    func setupContents() {
        view.addSubview(titleText)
        view.addSubview(startStoryImageThumb)
        view.addSubview(endStoryImageThumb)
        view.addSubview(editIcon)
        
        
        view.addSubview(collectionView)
        view.addSubview(timeline)
        
        view.addSubview(saveDraftStoryButton)
        view.addSubview(publishStoryPostButton)
        
        titleText.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 65, paddingBottom: 0, paddingRight: 30, width: 0, height: 30)
        
        editIcon.anchor(top: nil, left: nil, bottom: coverImageThumb.bottomAnchor, right: coverImageThumb.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 8, width: 25, height: 25)
        
        startStoryImageThumb.anchor(top: coverImageThumb.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 7, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        let stackview = UIStackView(arrangedSubviews: [saveDraftStoryButton])
        
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.distribution = .fillEqually
        stackview.axis = .horizontal
        stackview.spacing = 50
        
        view.addSubview(stackview)
        
        stackview.anchor(top: nil, left: startStoryImageThumb.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 22, paddingBottom: 20, paddingRight: 6, width: 0, height: 0)
        
        collectionView.anchor(top: startStoryImageThumb.bottomAnchor, left: view.leftAnchor, bottom: stackview.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 32, paddingRight: 6, width: 0, height: 0)
        
        endStoryImageThumb.anchor(top: collectionView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 7, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
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
        //        if indexPath.row == 0 {
        //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! StoryPostCell
        //            cell.setupContentCreateNewStoryPost()
        //        return cell
        //        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! StoryPostCell
        cell.storyPostTitle.text = storyPosts[indexPath.item].caption
        cell.storyPostCardImage.loadImageUsingCacheWithUrlString(urlString: storyPosts[indexPath.item].imageUrl)
        cell.setupStoryPostCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storyPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 160)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func editPostPopupAction(indexPath: IndexPath) {
        UIView.animate(withDuration: 1.8, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.tabBarController?.tabBar.isHidden = true
            self.viewPostPopup.editMode()
            self.viewPostPopup.post = self.storyPosts[indexPath.item]
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
            self.viewPostPopup.post = self.storyPosts[indexPath.item]
            self.viewPostPopup.loadPost()
            self.blurEffectView.isHidden = false
            self.viewPostPopup.popupView.isHidden = false
            self.viewPostPopup.popupView.transform = CGAffineTransform(scaleX: 0.9, y: 0.89)
        }) { (finished: Bool) in
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //viewStoryPostPopupAction(indexPath: indexPath)
        // Check currentUser post or else
        if (Variables.CurrentUser?.uid == post.postUID) {
            editPostPopupAction(indexPath: indexPath)
        } else {
            viewPostPopupAction(indexPath: indexPath)
        }
    }
    
}
