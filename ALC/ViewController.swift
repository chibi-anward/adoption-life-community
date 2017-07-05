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
        dataHandler.fetchUser(uid: dataHandler.getLocalData(object: "uid") ){ profile in
            
        }
        /*
        if ( !dataHandler.isLoggedIn() ) {
            dataHandler.registerUser(email: DummyB.Email, password: DummyB.Password, inviteCode: ""){ user in
                print(user.email!)
            }
        }
        */
        view.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 246, alpha: 1)
        
        print("ViewController")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

