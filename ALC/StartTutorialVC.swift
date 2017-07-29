//
//  StartTutorialVC.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-04.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit
import Firebase

class StartTutorialVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let loginALCBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login to My ALC", for: .normal)
        btn.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(loginALC), for: .touchUpInside)
        //btn.isEnabled = true
        return btn
    }()
    
    let loginCCBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login to Common Community", for: .normal)
        btn.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(loginCC), for: .touchUpInside)
        //btn.isEnabled = false
        return btn
    }()
    
    let registerCTA: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Register Now", for: .normal)
        btn.backgroundColor = UIColor.clear
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(register), for: .touchUpInside)
        //btn.isEnabled = false
        return btn
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 246, alpha: 1)
        print("StartTutorialVC")
        setupStackView()
    }
    
    fileprivate func setupStackView() {
        let stackview = UIStackView(arrangedSubviews: [loginALCBtn, loginCCBtn, registerCTA])
        
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.distribution = .fillEqually
        stackview.axis = .vertical
        stackview.spacing = 10
        
        view.addSubview(stackview)
        
        stackview.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 20, paddingRight: 40, width: 0, height: 140)
    }
    
    func loginALC() {
        print("login ALC")
        let dataHandler = DataHandler()
        // TODO: Chibi - Add fields for replace dummy data
        dataHandler.loginALCUser(email: DummyB.Email, password: DummyB.Password, inviteCode: Dummy.InviteCode) { object in
            if ( object == true ) {
                // TODO: Chibi - Open viewcontroller after succefully created new user.
                self.dismiss(animated: true, completion: nil)
            } else {
                // TODO: Failed to login. Show info to user
            }
        
        }
    }
    
    func loginCC() {
        print("login CC")
        let dataHandler = DataHandler()
        // TODO: Chibi - Add fields for replace dummy data
        Variables.Agency = "cc"
        dataHandler.loginCCUser(email: Dummy.Email, password: Dummy.Password) { object in
            if ( object == true ) {
                // TODO: Chibi - Open viewcontroller after succefully created new user.
                self.dismiss(animated: true, completion: nil)
            } else {
                // TODO: Failed to login. Show info to user
            }
            
        }
    }
    
    func register() {
        print("register")
        let registerController = RegisterVC()
        //let navController = UINavigationController(rootViewController: loginController)
        self.present(registerController, animated: true, completion: nil)
    }
}
