//
//  MessageVC.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-11.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit

class MessageVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Messages"
        
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        
        setupNavigationButtons()
    }
    
    func setupNavigationButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "close", style: .plain, target: self, action: #selector(backAction))
    }
    
    func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
}
