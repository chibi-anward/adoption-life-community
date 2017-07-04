//
//  ViewController.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-01.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let dataHandler = DataHandler()
        if ( !dataHandler.isLoggedIn() ) {
            dataHandler.registerUser(email: DummyB.Email, password: DummyB.Password, inviteCode: ""){ user in
                print(user.email!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

