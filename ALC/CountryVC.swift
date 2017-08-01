//
//  CountryVC.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-06.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit

class CountryVC: UIViewController {
    
    let bgTopImage: UIImageView = {
        let imageThumb = UIImageView()
        imageThumb.layer.masksToBounds = false
        imageThumb.clipsToBounds = true
        imageThumb.contentMode = .scaleAspectFill
        imageThumb.image = UIImage(named: "bgTopImage")
        return imageThumb
    }()
    
    let bgImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bg_gradient")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        view.insertSubview(bgTopImage, at: 1)
        view.insertSubview(bgImage, at: 2)
        
        bgTopImage.anchor(top: topLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 210)
        
        bgImage.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}
