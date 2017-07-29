//
//  HomeVC.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-04.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    
    
    var refresher = UIRefreshControl()
    
    func didLike(for cell: HomePostCell) {
        
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        let post = Variables.Posts[indexPath.item]
        let selectedPost = post.postID //
        let postUID = post.postUID //
        
        if (Variables.Posts[indexPath.item].IHaveLiked == true) {
            didUnLike(for: cell)
            return
        }
        
        let ref = Database.database().reference()
        
        let keyToPost = ref.child("agencies").child(Variables.Agency).child("posts").child(postUID).child(selectedPost).childByAutoId().key
        
        //get values of the post
        ref.child("agencies").child(Variables.Agency).child("posts").child(postUID).child(selectedPost).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let updateLikes: [String : Any] = ["userWhoLike/\(keyToPost)": Variables.CurrentUser?.uid ?? ""]
            
            
            ref.child("agencies").child(Variables.Agency).child("posts").child(postUID).child(selectedPost).updateChildValues(updateLikes, withCompletionBlock: { (error, reference) in
                if error == nil {
                    ref.child("agencies").child(Variables.Agency).child("posts").child(postUID).child(selectedPost).observeSingleEvent(of: .value, with: { (snap) in
                        if let properties = snap.value as? [String: AnyObject] {
                            //check how many people who's in "userWhoLike"
                            if let likes = properties["userWhoLike"] as? [String: AnyObject] {
                                let count = likes.count
                                let update = ["likes": count] as [String : Any]
                                ref.child("agencies").child(Variables.Agency).child("posts").child(postUID).child(selectedPost).updateChildValues(update, withCompletionBlock: { (error, reference) in

                               
                                ref.child("agencies").child(Variables.Agency).child("posts").child(postUID).child(selectedPost).observeSingleEvent(of: .value, with: { (snapshot) in
                                    var dictionary = snapshot.value as! [String: Any]
                                    
                                    var post = Post(dictionary: dictionary)
                                    post.IHaveLiked = true
                                    Variables.Posts[indexPath.item] = post
                                    
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
        let post = Variables.Posts[indexPath.item]
        let selectedPost = post.postID //
        let postUID = post.postUID //
        
        let ref = Database.database().reference()
        
        var keyToPost: String?
        
        for people in Variables.Posts[indexPath.item].userWhoLike! {
            if people.value as? String == uid {
                keyToPost = people.key
                Variables.Posts[indexPath.item].userWhoLike?.removeValue(forKey: keyToPost!) // ?[keyToPost!] = nil
                if ( Variables.Posts[indexPath.item].userWhoLike?.count == 0 ) {
                    Variables.Posts[indexPath.item].userWhoLike = nil
                }
                ref.child("agencies").child(Variables.Agency).child("posts").child(postUID).child(selectedPost).child("userWhoLike").child(keyToPost!).removeValue()
            }
        }
        
       
        //get values of the post
        ref.child("agencies").child(Variables.Agency).child("posts").child(postUID).child(selectedPost).observeSingleEvent(of: .value, with: { (snapshot) in
            
            ref.child("agencies").child(Variables.Agency).child("posts").child(postUID).child(selectedPost).observeSingleEvent(of: .value, with: { (snap) in
                if let properties = snap.value as? [String: AnyObject] {
                    //check how many people who's in "userWhoLike"
                    
                    if let likes = properties["userWhoLike"] as? [String: AnyObject] {
                        let count = likes.count
                        let update = ["likes": count] as [String : Any]
                        ref.child("agencies").child(Variables.Agency).child("posts").child(postUID).child(selectedPost).updateChildValues(update)
                        Variables.Posts[indexPath.item].likes = count
                        Variables.Posts[indexPath.item].IHaveLiked = false
                        self.collectionView.reloadItems(at: [indexPath])
                    } else {
                        let count = 0
                        let update = ["likes": count] as [String : Any]
                        ref.child("agencies").child(Variables.Agency).child("posts").child(postUID).child(selectedPost).updateChildValues(update)
                        Variables.Posts[indexPath.item].likes = count
                        Variables.Posts[indexPath.item].IHaveLiked = false
                        self.collectionView.reloadItems(at: [indexPath])
                    }
                }
            }, withCancel: nil)
        })
        ref.removeAllObservers()
    }
    
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    let cellID = "cellID"
    
    //var posts = ["1", "2", "3"] // Temp Post array
    //var posts = [Post]() // Post array
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 246, alpha: 1)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    //MARK:
    func refresh() {
        fetchPosts()
        refresher.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //fetchPosts()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        collectionView.addSubview(refresher)
        
        fetchPosts()
        navigationItem.title = "Home"
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        
        registerCell()
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        setupNavigationButtons()
    }
    
    //CollectionView
    fileprivate func registerCell() {
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomePostCell
        
        cell.delegate = self
        
        cell.post = Variables.Posts[indexPath.item]
        cell.likeIcon.tag = indexPath.item
        
        if Variables.Posts[indexPath.item].IHaveLiked == true {
            cell.likeIcon.setImage(UIImage(named: "like_icon_active"), for: .normal)
            cell.likeIcon.removeTarget(self, action: nil, for: .allEvents)
            //cell.likeIcon.addTarget(self, action: #selector(unlikePost), for: .touchUpInside)
        } else {
            cell.likeIcon.setImage(UIImage(named: "like_icon_default"), for: .normal)
            cell.likeIcon.removeTarget(self, action: nil, for: .allEvents)
            //cell.likeIcon.addTarget(self, action: #selector(likePost), for: .touchUpInside)
        }
        
        //Check for POST USER ID
        let postUID = Variables.Posts[indexPath.item].postUID
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Variables.Posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: width)
    }
    
    //Other Functions
    func fetchPosts() {
        Variables.Posts.removeAll()
        if ( Variables.Agency != "" ) {
            
            let ref = Database.database().reference().child("agencies").child(Variables.Agency).child("posts")
            ref.observe(.childAdded, with: { (snapshot) in
                //queryOrdered(byChild: "timestamp")
                //    ref.queryOrdered(byChild: "timestamp").observe(.value, with: { (snapshot) in
                
                guard let dictionaries = snapshot.value as? [String: Any] else { return }
                
                
                dictionaries.forEach({ (key, value) in
                    
                    guard let dictionary = value as? [String: Any] else { return }
                    var post = Post(dictionary: dictionary)
                    
                    let dataHandler = DataHandler()
                    // Check if current user has liked post
                    if (post.userWhoLike != nil) {
                    for people in post.userWhoLike! {
                        if people.value as? String == dataHandler.getLocalData(object: "uid")  {
                           post.IHaveLiked = true
                        }
                    }
                    }
                    Variables.Posts.append(post)
                })
                
                Variables.Posts.sort(by: { $0.timestamp?.compare($1.timestamp!) == .orderedDescending})
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    print("REALOAD DATA HomeFeedCV : 139")
                }
            }) { (err) in
                print("Failed to fetch posts:", err)
            }
            
        }
        
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
