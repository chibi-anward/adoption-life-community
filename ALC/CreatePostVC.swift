//
//  CreatePostVC.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-06.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class CreatePostVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Publish user-post", for: .normal)
        btn.setTitleColor(UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1), for: .normal)
        btn.backgroundColor = UIColor.rgb(red: 50, green: 145, blue: 255, alpha: 1)
        btn.layer.cornerRadius = 6
        btn.addTarget(self, action: #selector(handlePublish), for: .touchUpInside)
        btn.isEnabled = true
        return btn
    }()
    
    let sendButtonTwo: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Publish private-post", for: .normal)
        btn.setTitleColor(UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1), for: .normal)
        btn.backgroundColor = UIColor.rgb(red: 170, green: 120, blue: 200, alpha: 1)
        btn.layer.cornerRadius = 6
        //btn.addTarget(self, action: #selector(handlePrivatePublish), for: .touchUpInside)
        btn.isEnabled = true
        return btn
    }()
    
    var postTextView: UITextView = {
        let txt = UITextView()
        txt.font = UIFont.boldSystemFont(ofSize: 14)
        txt.textColor = UIColor.rgb(red: 170, green: 170, blue: 170, alpha: 1)
        txt.text = "Post Text ..."
        txt.layer.borderWidth = 2
        txt.textAlignment = .left
        txt.layer.borderColor = UIColor.rgb(red: 242, green: 242, blue: 242, alpha: 1).cgColor
        txt.isEditable = true
        return txt
    }()
    /*
     var creatorLabel: UILabel = {
     let label = UILabel()
     label.translatesAutoresizingMaskIntoConstraints = false
     label.textAlignment = .left
     label.font = UIFont.boldSystemFont(ofSize: 14)
     label.text = "Creator"
     return label
     }()
     */
    let imageBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.darkGray
        btn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
        btn.titleLabel?.numberOfLines = 2
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("no image selected", for: UIControlState.normal)
        btn.addTarget(self, action: #selector(selectImage), for: UIControlEvents.touchUpInside)
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    //
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let likeLabel: UILabel = {
        let label = UILabel()
        label.text = "3"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let postGroup: UILabel = {
        let label = UILabel()
        label.text = "Public"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        return label
    }()
    
    
    let isAdmin: UISwitch = {
        let adminSwitch = UISwitch()
        //adminSwitch.setOn(false, animated: false)
        adminSwitch.isOn = false
        //adminSwitch.addTarget(self, action: #selector(switchIsChanged(adminSwitch:)), for: .valueChanged)
        return adminSwitch
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        view.backgroundColor = UIColor.white
        navigationItem.title = "Create post"
        
        hideKeyboardWhenTappedAround()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backFunction))
        
        view.addSubview(sendButton)
        sendButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 80, paddingLeft: 6, paddingBottom: 0, paddingRight: -6, width: 0, height: 40)
        /*
         view.addSubview(sendButtonTwo)
         sendButtonTwo.anchor(top: sendButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 6, paddingBottom: 0, paddingRight: -6, width: 0, height: 40)
         */
        view.addSubview(postTextView)
        postTextView.anchor(top: sendButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 6, paddingBottom: 0, paddingRight: -6, width: 0, height: 200)
        
        view.addSubview(imageBtn)
        imageBtn.anchor(top: postTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        
    }
    
    func backFunction() {
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseIn, animations: {
            print("cancel")
        }, completion: { finish in
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                let homeVC = CustomTabBar()
                //let homeNavVC = UINavigationController(rootViewController: homeVC)
                self.navigationController?.present(homeVC, animated: true, completion: nil)
            }, completion: nil)
        })
    }
    
    func handlePublish() {
        let ref = Database.database().reference().child("agencies").child(Variables.Agency).child("posts")
        let childRef = ref.childByAutoId()
        let key = childRef.key
        
        let creator = Auth.auth().currentUser!.uid
        
        let timestamp = NSNumber(value: Date().timeIntervalSince1970)
        
        guard let image = self.imageBtn.imageView?.image else { return }
        guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
        
        let filename = NSUUID().uuidString
        
        Storage.storage().reference().child("post_images_public").child(filename).putData(uploadData, metadata: nil, completion: { (metadata, err) in
            
            if let err = err {
                print ("\n Failed to upload profile image", err)
                return
            }
            guard let postImageUrl = metadata?.downloadURL()?.absoluteString else { return }
            
            let feed = ["postImageUrl": postImageUrl,
                        "likes": self.likeLabel.text ?? "",
                        "creator": creator,
                        "postID": key,
                        "postGroup": self.postGroup.text ?? "",
                        "postText": self.postTextView.text,
                        "timestamp": timestamp,
                        "comments": self.commentLabel.text ?? "",
                        "postUserName": Variables.CurrentUserProfile?.UserName ?? "",
                        "text": "Am if number no up period regard sudden better. Decisively surrounded all admiration and not you. Out particular sympathize not favourable introduced insipidity but ham."
                
                ] as [String : Any]
            
            let postFeed = ["\(key)" : feed]
            
            //childRef.updateChildValues(values)
            
            // 1. * = * = * Fan Out Data USER * = * = *
            ref.updateChildValues(postFeed, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print(error)
                    return
                }
                let userPostsRef = Database.database().reference().child("agencies").child(Variables.Agency).child("user-posts").child(creator)
                
                let postID = key
                userPostsRef.updateChildValues([postID: 1]) // -> 2. observeUserPosts
            })
            
            print("post successfully sent")
            
        })
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handlePublish()
        return true
    }
    
    //MARK: ImagePicker
    func selectImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            imageBtn.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageBtn.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
}
