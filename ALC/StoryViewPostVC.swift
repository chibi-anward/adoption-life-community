//
//  StoryViewPostVC.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-29.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit

class StoryViewPostVC: UIViewController {
    
    
    let backNavButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("back", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 100, green: 100, blue: 100, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(backAction), for: .touchDown)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 55, alpha: 1)
        
        setupViews()
        
        
    }
    
    fileprivate func setupViews() {
        
        view.addSubview(backNavButton)
        backNavButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 40)
        
        let stackview = UIStackView(arrangedSubviews: [])
        
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.distribution = .fillEqually
        stackview.axis = .vertical
        stackview.spacing = 10
        
        view.addSubview(stackview)
        
        stackview.anchor(top: view.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 300)
    }
    
    func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
