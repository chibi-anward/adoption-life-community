//
//  SharePhotoController.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-06.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class SharePhotoController: UIViewController, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    
    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    let inputShareContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        return containerView
    }()
    
    let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor.rgb(red: 210, green: 210, blue: 210, alpha: 1)
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    let textView: UITextView = {
        let txtV = UITextView ()
        txtV.font = UIFont.systemFont(ofSize: 14)
        txtV.backgroundColor = UIColor.white
        return txtV
    }()
    
    let locationText: UITextView = {
        let lbl = UITextView()
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 10)
        lbl.text = "Your location..."
        return lbl
    }()
    
    //MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240, alpha: 1)
        navigationItem.title = "SharePhoto"
        self.hideKeyboardWhenTappedAround()
        setupInputSharePostViews()
        setupNavigationButtons()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }
    
    //MARK:
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .black
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(handleCancel))
        let locationBtn = UIBarButtonItem(title: "location", style: .plain, target: self, action: #selector(handleGetLocation))
        let shareBtn = UIBarButtonItem(title: "share", style: .plain, target: self, action: #selector(handleSharePost))
        
        navigationItem.rightBarButtonItems = [shareBtn, locationBtn]
    }
    
    func handleGetLocation() {
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarker, error) in
            
            if error != nil {
                print("There was an error")
            } else {
                if let place = placemarker?[0] {
                    let thoroughfare = (place.thoroughfare)! as String
                    let locality = (place.locality)! as String
                    self.locationText.text = "\(thoroughfare)\n\(locality)"
                    
                    
                }
            }
        }
        manager.stopUpdatingLocation()
    }
    
    func handleSharePost(){
        guard let caption = textView.text, caption.characters.count > 0 else {return}
        guard let image = selectedImage else {return}
        
        guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else {return}
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let filename = NSUUID().uuidString
        
        Storage.storage().reference().child("posts-image").child(filename).putData(uploadData, metadata: nil) { (metadata, err) in
            if err != nil {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload image")
            }
 
            guard let imageUrl = metadata?.downloadURL()?.absoluteString else {return}
            
            self.saveToDataBaseImageUrl(imageUrl: imageUrl)
            
        }
    }
    
    fileprivate func saveToDataBaseImageUrl(imageUrl: String) {
        
        AppDelegate.instance().showActivityIndicator()
        
        guard let postImage = selectedImage else {return}
        guard let caption = textView.text else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let timestamp = NSNumber(value: Date().timeIntervalSince1970)
        guard let loaction = locationText.text else {return}
        
        let userPostRef = Database.database().reference().child("agencies").child(Variables.Agency).child("posts").child(uid)
        let userPostAutoId = userPostRef.childByAutoId()
        let key = userPostAutoId.key
        
        let values = ["imageUrl": imageUrl,
                      "caption": caption,
                      "timestamp": timestamp,
                      "imageWidth": postImage.size.width,
                      "imageHeight": postImage.size.height,
                      "likes": 0,
                      "postID": key,
                      "postUID": uid,
                      "location": loaction,
                      "comments": 0,
                      "postUserName": Variables.CurrentUserProfile?.UserName as! String
            ] as [String : Any]
        userPostAutoId.updateChildValues(values) { (error, reference) in
            if error != nil {
                AppDelegate.instance().dismissActivityIndicator()
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post")
                return
            }
            print("success")
            AppDelegate.instance().dismissActivityIndicator()
            self.backFunction()
        }
    }
    
    func backFunction() {
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseIn, animations: {
            print("success")
        }, completion: { finish in
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                let homeVC = CustomTabBar()
                //let homeNavVC = UINavigationController(rootViewController: homeVC)
                self.navigationController?.present(homeVC, animated: true, completion: nil)
            }, completion: nil)
        })
    }
    
    
    //MARK:
    fileprivate func setupInputSharePostViews() {
        view.addSubview(inputShareContainerView)
        inputShareContainerView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 140)
        
        inputShareContainerView.addSubview(imageView)
        imageView.anchor(top: inputShareContainerView.topAnchor, left: inputShareContainerView.leftAnchor, bottom: inputShareContainerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 124, height: 0)
        
        inputShareContainerView.addSubview(textView)
        textView.anchor(top: inputShareContainerView.topAnchor, left: imageView.rightAnchor, bottom: inputShareContainerView.bottomAnchor, right: inputShareContainerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(locationText)
        locationText.anchor(top: inputShareContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: -16, width: 0, height: 80)
    }
    
}
