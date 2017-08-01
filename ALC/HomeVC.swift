//
//  HomeVC.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-04.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    
    
    var refresher = UIRefreshControl()
    var PostStory = [PostsStories]()
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    let cellID = "cellID"
    let storyCellID = "storyCellID"
    
    let bgImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bg_gradient")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.clear
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let vcTitle: UILabel = {
        let label = UILabel()
        label.text = "Home"
        label.textAlignment = .center
        label.textColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18, weight: 15)
        return label
    }()
    
    let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.isHidden = true
        return view
    }()
    
    var viewPostPopup = ViewPostVC()
    
    //MARK:
    func refresh() {
        getPostsStories()
        refresher.endRefreshing()
    }
    
   var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bgImage)
        bgImage.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        refresher.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        collectionView.addSubview(refresher)
        
        getPostsStories()
        
        navigationItem.title = "Home"
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        
        registerCell()
        
        view.addSubview(vcTitle)
        vcTitle.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 35, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 35)
        
        view.addSubview(collectionView)
        collectionView.anchor(top: topLayoutGuide.topAnchor, left: view.leftAnchor, bottom: bottomLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 75, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        setupNavigationButtons()
        //Variables.Posts.append(Variables.Stories)
        
        blurEffect()
        self.navigationController!.view.insertSubview(viewPostPopup.popupView, at: 17)
        viewPostPopup.backNavButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        //viewPostPopup.saveNavButton.addTarget(self, action: #selector(save), for: .touchUpInside)
    }
    
    func blurEffect() {
        window = UIWindow(frame: UIScreen.main.bounds)
        blurEffectView.frame = self.navigationController!.view.bounds
        //blurEffectView.frame = self.tabBarController!.tabBar.bounds
        self.navigationController!.view.insertSubview(blurEffectView, at: 15)
    }
    
    func editPostPopupAction(indexPath: IndexPath) {
        UIView.animate(withDuration: 1.8, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.tabBarController?.tabBar.isHidden = true
            self.viewPostPopup.editMode()
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
            self.blurEffectView.isHidden = false
            self.viewPostPopup.popupView.isHidden = false
            self.viewPostPopup.popupView.transform = CGAffineTransform(scaleX: 0.9, y: 0.89)
        }) { (finished: Bool) in
            
        }
    }
    
    func close() {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.tabBarController?.tabBar.isHidden = false
            self.blurEffectView.isHidden = true
            self.viewPostPopup.popupView.isHidden = true
            self.viewPostPopup.popupView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (finished: Bool) in
        }
    }
    
    /*
 func save() {
 UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
 print("save story post")
 
 
 AppDelegate.instance().showActivityIndicator()
 
 let userPostRef = Database.database().reference().child("agencies").child(Variables.Agency).child("stories").child((Variables.CurrentUser?.uid)!).child(self.story.id).child("posts")
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
 */

 
    //CollectionView
    fileprivate func registerCell() {
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(StoryCell.self, forCellWithReuseIdentifier: storyCellID)
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomePostCell
        if let post = PostStory[indexPath.item].post {
            //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomePostCell
            cell.delegate = self
            cell.post = post
            cell.likeIcon.tag = indexPath.item
            
            if post.IHaveLiked == true {
                cell.likeIcon.setImage(UIImage(named: "like_selected"), for: .normal)
                cell.likeIcon.removeTarget(self, action: nil, for: .allEvents)
                //cell.likeIcon.addTarget(self, action: #selector(unlikePost), for: .touchUpInside)
            } else {
                cell.likeIcon.setImage(UIImage(named: "like_unselected"), for: .normal)
                cell.likeIcon.removeTarget(self, action: nil, for: .allEvents)
                //cell.likeIcon.addTarget(self, action: #selector(likePost), for: .touchUpInside)
            }
            
            //Check for POST USER ID
            let postUID = post.postUID
            Database.database().reference().child("agencies").child(Variables.Agency).child("users").child(postUID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                
                guard let username = dictionary["username"] as? String else { return }
                cell.usernameLabel.text = username
                
                if let profileImageUrl = dictionary["ProfileImageUrl"] as? String {
                    cell.profileImageThumb.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                }
                
                
                
                
            }) { (err) in
                print("Can't fetch profile information", err)
            }
        }
        
        if let story = PostStory[indexPath.item].story {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: storyCellID, for: indexPath) as! StoryCell
            cell.viewStoryHomeFeed()
            
            cell.story = story
            
            //            cell.descriptionLabel.text = story.title
            //            cell.postImageView.loadImageUsingCacheWithUrlString(urlString: story.coverImageUrl)
            
            //Check for POST USER ID
            let postUID = story.uid
            Database.database().reference().child("agencies").child(Variables.Agency).child("users").child(postUID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                
                guard let username = dictionary["username"] as? String else { return }
                cell.usernameLabel.text = username
                
                if let profileImageUrl = dictionary["ProfileImageUrl"] as? String {
                    cell.profileImageThumb.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                }
                
                
                
                
            }) { (err) in
                print("Can't fetch profile information", err)
            }
            
            return cell
        }
        
        return cell
        
        
    }
    
    func goToStory(indexPath: IndexPath) {
        print("\nGoToStory\n")
        let storyTimeline = StoryTimelineVC()
        storyTimeline.titleText.text = PostStory[indexPath.item].story?.title
        storyTimeline.coverImageThumb.loadImageUsingCacheWithUrlString(urlString: (PostStory[indexPath.item].story?.coverImageUrl)!)
        storyTimeline.storyPosts = (PostStory[indexPath.item].story?.posts!)!
        storyTimeline.story = PostStory[indexPath.item].story!
        self.present(storyTimeline, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let post = PostStory[indexPath.item].post {
            print("post")
            // Check currentUser post or else
            editPostPopupAction(indexPath: indexPath)
            viewPostPopupAction(indexPath: indexPath)
        }
        if let story = PostStory[indexPath.item].story {
            print("story")
            goToStory(indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return Variables.Posts.count
        return PostStory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let story = PostStory[indexPath.item].story {
            let width = UIScreen.main.bounds.width - 6
            return CGSize(width: width, height: width - 50)
        }
        let width = UIScreen.main.bounds.width - 6
        return CGSize(width: width, height: width)
    }
    
    //Other Functions
    func getPostsStories() {
        fetchPosts { (success) in
            self.fetchStories(completionHandler: { (success) in
                // merge array
                
                var res:[Story] = []
                Variables.Stories.forEach { (p) -> () in
                    if !res.contains (where: { $0.id == p.id }) {
                        res.append(p)
                    }
                }
                
                Variables.Stories = res
                
                
                let sortedArray = (Variables.Posts.map { PostsStories(post: $0, story: nil) } + Variables.Stories.map { PostsStories(post: nil, story: $0)}).sorted { $0.timestamp > $1.timestamp }
                
                self.PostStory = sortedArray
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    print("REALOAD DATA HomeFeedCV : 139")
                }
            })
        }
        
    }
    
    func fetchPosts(completionHandler:@escaping (Bool) -> ()) {
        if ( Variables.Agency != "" ) {
            Variables.Posts.removeAll()
            
            
            let ref = Database.database().reference().child("agencies").child(Variables.Agency).child("posts").observe(.childAdded, with: { (snapshot) in
                //queryOrdered(byChild: "timestamp")
                //    ref.queryOrdered(byChild: "timestamp").observe(.value, with: { (snapshot) in
                
                guard let dictionaries = snapshot.value as? [String: Any] else { return }
                
                
                dictionaries.forEach({ (key, value) in
                    
                    guard let dictionary = value as? [String: Any] else { return }
                    var post = Post(dictionary: dictionary)
                    
                    let dataHandler = DataHandler()
                    // Check if current user has liked post
                    if (post.userWhoLike != nil) {
                        for people in post.userWhoLike {
                            if people.value as? String == dataHandler.getLocalData(object: "uid")  {
                                post.IHaveLiked = true
                            }
                        }
                    }
                    Variables.Posts.append(post)
                })
                
                Variables.Posts.sort(by: { $0.timestamp?.compare($1.timestamp!) == .orderedDescending})
                completionHandler(true)
                //                DispatchQueue.main.async {
                //                    self.collectionView.reloadData()
                //                    print("REALOAD DATA HomeFeedCV : 139")
                //                }
            }) { (err) in
                print("Failed to fetch posts:", err)
                completionHandler(false)
            }
            
        }
        
    }
    

    func fetchStories(completionHandler:@escaping (Bool) -> ()) {
        if ( Variables.Agency != "" ) {
            Variables.Stories.removeAll()
            
            
            let ref = Database.database().reference().child("agencies").child(Variables.Agency).child("stories").observe(.childAdded, with: { (snapshot) in
                
                guard let dictionaries = snapshot.value as? [String: Any] else { return }
                
                
                dictionaries.forEach({ (key, value) in
                    
                    guard let dictionary = value as? [String: Any] else { return }
                    var story = Story(dictionary: dictionary)
                    
                    if (dictionary["posts"]) != nil {
                        let posts = dictionary["posts"] as! NSDictionary
                        for post in posts {
                            let p = Post(dictionary: post.value as! [String : Any])
                            story.posts?.append(p)
                        }
                    }
                    
                    
                    
                    Variables.Stories.append(story)
                })
                
                Variables.Stories.sort(by: { $0.timestamp?.compare($1.timestamp!) == .orderedDescending})
                completionHandler(true)
                //                DispatchQueue.main.async {
                //                    self.collectionView.reloadData()
                //                    print("REALOAD DATA HomeFeedCV : 139")
                //               }
            }) { (err) in
                print("Failed to fetch posts:", err)
                completionHandler(false)
            }
            
        }
        
    }
    
    func didLike(for cell: HomePostCell) {
        
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        let post =  PostStory[indexPath.item].post
        let selectedPost = post?.postID //
        let postUID = post?.postUID //
        
        if (PostStory[indexPath.item].post?.IHaveLiked == true) {
            didUnLike(for: cell)
            return
        }
        
        let ref = Database.database().reference()
        
        let keyToPost = ref.child("agencies").child(Variables.Agency).child("posts").child(postUID!).child(selectedPost!).childByAutoId().key
        
        //get values of the post
        ref.child("agencies").child(Variables.Agency).child("posts").child(postUID!).child(selectedPost!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let updateLikes: [String : Any] = ["userWhoLike/\(keyToPost)": Variables.CurrentUser?.uid ?? ""]
            
            
            ref.child("agencies").child(Variables.Agency).child("posts").child(postUID!).child(selectedPost!).updateChildValues(updateLikes, withCompletionBlock: { (error, reference) in
                if error == nil {
                    ref.child("agencies").child(Variables.Agency).child("posts").child(postUID!).child(selectedPost!).observeSingleEvent(of: .value, with: { (snap) in
                        if let properties = snap.value as? [String: AnyObject] {
                            //check how many people who's in "userWhoLike"
                            if let likes = properties["userWhoLike"] as? [String: AnyObject] {
                                let count = likes.count
                                let update = ["likes": count] as [String : Any]
                                ref.child("agencies").child(Variables.Agency).child("posts").child(postUID!).child(selectedPost!).updateChildValues(update, withCompletionBlock: { (error, reference) in
                                    
                                    
                                    ref.child("agencies").child(Variables.Agency).child("posts").child(postUID!).child(selectedPost!).observeSingleEvent(of: .value, with: { (snapshot) in
                                        var dictionary = snapshot.value as! [String: Any]
                                        
                                        var post = Post(dictionary: dictionary)
                                        post.IHaveLiked = true
                                        self.PostStory[indexPath.item].post = post
                                        
                                        self.collectionView.reloadItems(at: [indexPath])
                                        
                                    })
                                })
                            }
                        }
                    }, withCancel: nil)
                }
            })
        }, withCancel: nil)
        
        ref.removeAllObservers()
        
    }
    
    
    func didUnLike(for cell: HomePostCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        
        guard let uid = Variables.CurrentUser?.uid else { return }
        let post = PostStory[indexPath.item].post
        let selectedPost = post?.postID //
        let postUID = post?.postUID //
        
        let ref = Database.database().reference()
        
        var keyToPost: String?
        
        for people in (PostStory[indexPath.item].post?.userWhoLike)! {
            if people.value as? String == uid {
                keyToPost = people.key
                PostStory[indexPath.item].post?.userWhoLike.removeValue(forKey: keyToPost!) // ?[keyToPost!] = nil
                if ( PostStory[indexPath.item].post?.userWhoLike.count == 0 ) {
                    PostStory[indexPath.item].post?.userWhoLike = [:]
                }
                ref.child("agencies").child(Variables.Agency).child("posts").child(postUID!).child(selectedPost!).child("userWhoLike").child(keyToPost!).removeValue()
            }
        }
        
        
        //get values of the post
        ref.child("agencies").child(Variables.Agency).child("posts").child(postUID!).child(selectedPost!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            ref.child("agencies").child(Variables.Agency).child("posts").child(postUID!).child(selectedPost!).observeSingleEvent(of: .value, with: { (snap) in
                if let properties = snap.value as? [String: AnyObject] {
                    //check how many people who's in "userWhoLike"
                    
                    if let likes = properties["userWhoLike"] as? [String: AnyObject] {
                        let count = likes.count
                        let update = ["likes": count] as [String : Any]
                        ref.child("agencies").child(Variables.Agency).child("posts").child(postUID!).child(selectedPost!).updateChildValues(update)
                        self.PostStory[indexPath.item].post?.likes = count
                        self.PostStory[indexPath.item].post?.IHaveLiked = false
                        
                        self.collectionView.reloadItems(at: [indexPath])
                    } else {
                        let count = 0
                        let update = ["likes": count] as [String : Any]
                        ref.child("agencies").child(Variables.Agency).child("posts").child(postUID!).child(selectedPost!).updateChildValues(update)
                        self.PostStory[indexPath.item].post?.likes = count
                        self.PostStory[indexPath.item].post?
                            .IHaveLiked = false
                        
                        self.collectionView.reloadItems(at: [indexPath])
                    }
                }
            }, withCancel: nil)
        })
        ref.removeAllObservers()
    }
    
    func setupNavigationButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Messages", style: .plain, target: self, action: #selector(goToMessages))
    }
    
    func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            print("Perform log out action")
            
            let datahandler = DataHandler()
            datahandler.logOutUser() { success in
                if (success == true) {
                    // logged out
                    let startTutorial = StartTutorialVC()
                    self.present(startTutorial, animated: false, completion: nil)
                } else {
                    print("Error")
                }
            }
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func gotoMessages() {
        let messagesVC = MessageVC()
        let navController = UINavigationController(rootViewController: messagesVC)
        present(navController, animated: true, completion: nil)
    }
    
    
    func pushToMessages() {
        let messagesVC = MessageVC()
        let transition = CATransition()
        transition.duration = 0.0
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        let navController = UINavigationController(rootViewController: messagesVC)
        self.navigationController?.present(navController, animated: false, completion: nil)
    }
    
    func goToMessages() {
        let messageView = MessageVC()
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        let navController = UINavigationController(rootViewController: messageView)
        self.navigationController?.present(navController, animated: false, completion: nil)
    }
    
}
