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
            /*
            let createTab = CreateTabVC()
            let navController = UINavigationController(rootViewController: createTab)
            present(navController, animated: true, completion: nil)
            return false
            */
           
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorVC(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            present(navController, animated: true, completion: nil)
            return false

        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        checkIfUserIsLoggedIn()
        setupViewControllers()
        
        
    }
    
    func checkIfUserIsLoggedIn() {

        let datahandler = DataHandler()
        if ( !datahandler.isLoggedIn() == true) {
            DispatchQueue.main.async {
                let startController = StartTutorialVC()
                self.present(startController, animated: true, completion: nil)
            }
            return
        }
    }
    
    func setupViewControllers() {
      
        //Home
        let viewNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "feedTabBar_default").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "feedTabBar_selected").withRenderingMode(.alwaysOriginal), title: "Home", rootViewController: HomeVC())
        
        //Profile
        let profileNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "profileTabIcon_default").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "profileTabIcon_selected").withRenderingMode(.alwaysOriginal), title: "Profile", rootViewController: ProfileVC())
        
        //CreatePost
        let createPostNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "CreatePost_Tab").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "CreatePost_Tab").withRenderingMode(.alwaysOriginal), title: "", rootViewController: CreatePostVC())
        
        //Country
        let countryNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "countryTabBar_default").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "countryTabBar_selected").withRenderingMode(.alwaysOriginal), title: "Country", rootViewController: CountryVC())
        
        let agencyNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "agencyTabBar_default").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "agencyTabBar_selected").withRenderingMode(.alwaysOriginal), title: "Agency", rootViewController: AgencyVC())
        
        tabBar.tintColor = UIColor.rgb(red: 109, green: 93, blue: 190, alpha: 1)
        
        viewControllers = [viewNavController, agencyNavController,  createPostNavController, countryNavController, profileNavController]
        
        //tab item insets
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
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
    
}
