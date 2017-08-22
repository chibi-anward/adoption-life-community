//
//  CustomTabBar.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-04.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBarController, UITabBarControllerDelegate {
    let layout = UICollectionViewFlowLayout()
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
        if index == 2 {
          
            create()
            return false
 
           /*
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorVC(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            present(navController, animated: true, completion: nil)
            return false
             */
            
        }
        return true
    }

    var createOptionVC = CreateOptionsVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        checkIfUserIsLoggedIn()
        setupViewControllers()
        
        tabBar.barTintColor = UIColor.rgb(red: 39, green: 47, blue: 62, alpha: 0.8)
        tabBar.isTranslucent = false
        
        view.addSubview(createOptionVC)
        createOptionVC.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        createOptionVC.isHidden = true
        
        
    }
    
    func checkIfUserIsLoggedIn() {
        
        let datahandler = DataHandler()
        
        datahandler.isLoggedIn { (object) in
            if ( object == false ) {
                DispatchQueue.main.async {
                    let startController = StartTutorialVC()
                    self.present(startController, animated: true, completion: nil)
                }
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshStories"), object: nil)
            }
            
        }
    }
    
    func setupViewControllers() {
      
        //Home
        let viewNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "feedTabBar_default").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "feedTabBar_selected").withRenderingMode(.alwaysOriginal), title: "Home", rootViewController: HomeVC())
        
        //Profile
        let profileNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "profileTabIcon_default").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "profileTabIcon_selected").withRenderingMode(.alwaysOriginal), title: "Profile", rootViewController: ProfileVC())
        
        //CreatePost
        let createPostNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "addBtn").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "addBtn").withRenderingMode(.alwaysOriginal), title: "", rootViewController: CreatePostVC())
        
        //Country
        let countryNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "countryTabBar_default").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "countryTabBar_selected").withRenderingMode(.alwaysOriginal), title: "Country", rootViewController: CountryVC())
        
        let agencyNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "agencyTabBar_default").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "agencyTabBar_selected").withRenderingMode(.alwaysOriginal), title: "Agency", rootViewController: AgencyVC())
        
        tabBar.tintColor = UIColor.rgb(red: 0, green: 186, blue: 255, alpha: 1)
        tabBar.isTranslucent = true
        
        viewControllers = [viewNavController, agencyNavController,  createPostNavController, countryNavController, profileNavController]
        
        //tab item insets
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        
        
    }
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if ( item.title == "Profile" ) {
           //Variables.SelectedProfileUser = nil
        }
    }
    
    //    public func setbadge() {
    //        // Access the elements (NSArray of UITabBarItem) (tabs) of the tab Bar
    //        let tabItems = self.tabBar.items as NSArray!
    //
    //        // In this case we want to modify the badge number of the third tab:
    //        let tabItem = tabItems?[2] as! UITabBarItem
    //
    //        // Now set the badge of the third tab
    //        tabItem.badgeValue = "1"
    //    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, title: String, rootViewController: UIViewController = UIViewController()) -> UINavigationController{
        
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.tabBarItem.title = title
        return navController
    }
    
    //CREATE
    func create() {
        print("create")
        createOptionVC.backNavButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        createOptionVC.createPostIcon.addTarget(self, action: #selector(createPost), for: .touchUpInside)
        createOptionVC.createStoryIcon.addTarget(self, action: #selector(createStory), for: .touchUpInside)
        createOptionVC.isHidden = false
    }
    
    func close() {
        print("close")
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.tabBarController?.tabBar.isHidden = false
            self.createOptionVC.isHidden = true
            
        }) { (finished: Bool) in
            //self.refresh()
        }
    }
    
    func createPost() {
        let layout = UICollectionViewFlowLayout()
        let photoSelectorController = PhotoSelectorVC(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: photoSelectorController)
    
        present(navController, animated: true, completion: {
            self.close()
        })
    }
    
    func createStory() {
        let storyTimelineVC = StoryTimelineVC()
        close()
        present(storyTimelineVC, animated: true, completion: {
            self.close()
        })
    }
    
}
