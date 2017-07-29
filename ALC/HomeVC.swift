//
//  HomeVC.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-04.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        fetchPosts()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetchPosts()
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
        
        cell.post = Variables.Posts[indexPath.item]
        
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
                    let post = Post(dictionary: dictionary)
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
