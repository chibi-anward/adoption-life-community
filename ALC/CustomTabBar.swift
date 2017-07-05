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
        _ = viewControllers?.index(of: viewController)
        /*
         if index == 2 {
         //let layout = UICollectionViewFlowLayout()
         return false
         }*/
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
      
    
        let viewNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_tab_icon_unselected").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "home_tab_icon_selected").withRenderingMode(.alwaysOriginal), title: "Test", rootViewController: RegisterVC())
        
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_tab_icon_unselected").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "home_tab_icon_selected").withRenderingMode(.alwaysOriginal), title: "Home", rootViewController: HomeVC())
        
        tabBar.tintColor = UIColor.rgb(red: 109, green: 93, blue: 190, alpha: 1)
        
        viewControllers = [viewNavController, homeNavController]
        
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