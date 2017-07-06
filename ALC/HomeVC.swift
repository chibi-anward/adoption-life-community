//
//  HomeVC.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-04.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Home"
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        
        setupNavigationButtons()
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
    
    func testFunction() {
        //
        let datahandler = DataHandler()
        datahandler.fetchUser(uid: (Variables.CurrentUser?.uid)!) { object in
            print ("\(object.Email)")
        }
        
        datahandler.fetchUser(uid: (Variables.CurrentUser?.uid)!) { (object) in
            // if object != nil
        }
        
        //
        datahandler.logOutUser { (success) in
            // if true or false
        }
        
    }
}
