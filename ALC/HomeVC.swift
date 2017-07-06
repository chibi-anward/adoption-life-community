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
        
        navigationItem.title = "Home"
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        
        registerCell()
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        fetchPosts()
        setupNavigationButtons()
    }
    
    //CollectionView
    fileprivate func registerCell() {
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomePostCell
        
        cell.post = Variables.Posts[indexPath.item]
        
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
            ref.queryOrdered(byChild: "timestamp").observe(.childAdded, with: { (snapshot) in
                
                guard let dictionaries = snapshot.value as? [String: Any] else { return }
               
                dictionaries.forEach({ (key, value) in
                    
                    guard let dictionary = value as? [String: Any] else { return }
                    let post = Post(dictionary: dictionary)
                    Variables.Posts.append(post)
                })
                
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogOut))
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
    
   }
