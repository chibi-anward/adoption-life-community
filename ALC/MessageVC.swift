//
//  MessageVC.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-11.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit

class MessageVC: UIViewController, UITextFieldDelegate {
    
    //, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 246, alpha: 1)
        //cv.delegate = self
        //cv.dataSource = self
        return cv
    }()
    
    let sendbtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Send", for: .normal)
        let titleColorNormal = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        let titleColorPushed = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        btn.setTitleColor(titleColorNormal, for: .normal)
        btn.setTitleColor(titleColorPushed, for: .highlighted)
        btn.backgroundColor = UIColor.rgb(red: 170, green: 120, blue: 200, alpha: 1)
        btn.layer.cornerRadius = 6
        btn.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return btn
    }()
    
    let inputTxtField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Enter comment here..."
        txtField.layer.cornerRadius = 8
        txtField.font = UIFont.systemFont(ofSize: 13)
        txtField.textColor = UIColor(red: 143.0/255.0, green: 143.0/255.0, blue: 143.0/255.0, alpha: 1.0)
        txtField.backgroundColor = UIColor.rgb(red: 243, green: 243, blue: 243, alpha: 1)
        //txtField.delegate = self
        return txtField
    }()
    
    let commentInputContainter: UIView = {
        let inputContainer = UIView()
        inputContainer.backgroundColor = UIColor.rgb(red: 228, green: 228, blue: 228, alpha: 1)
        return inputContainer
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Messages"
        
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        self.hideKeyboardWhenTappedAround()
        
        setupNavigationButtons()
        setupInputCommentViews()
        
        //
        bottomConstraint = NSLayoutConstraint(item: commentInputContainter, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        view.addConstraint(bottomConstraint!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
    }
    
    func setupNavigationButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "close", style: .plain, target: self, action: #selector(backActionTransition))
    }
    
    func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func backActionTransition() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupInputCommentViews() {
        view.addSubview(commentInputContainter)
        commentInputContainter.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 48)
        
        commentInputContainter.addSubview(inputTxtField)
        inputTxtField.anchor(top: commentInputContainter.topAnchor, left: commentInputContainter.leftAnchor, bottom: commentInputContainter.bottomAnchor, right: commentInputContainter.rightAnchor, paddingTop: 3, paddingLeft: 8, paddingBottom: -3, paddingRight: -80, width: 0, height: 40)
        
        commentInputContainter.addSubview(sendbtn)
        sendbtn.anchor(top: commentInputContainter.topAnchor, left: inputTxtField.rightAnchor, bottom: commentInputContainter.bottomAnchor, right: commentInputContainter.rightAnchor, paddingTop: 3, paddingLeft: 6, paddingBottom: -3, paddingRight: -8, width: 0, height: 40)
        
    }
    
    //MARK: INPUT COMMENT
    func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboard = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            
            let isKeyboardShowing = notification.name == .UIKeyboardWillShow
            bottomConstraint?.constant = isKeyboardShowing ? -(keyboard?.height)! : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                //scroll
                if isKeyboardShowing {
                    print("\n\n isKeyboardShowing")
                    //self.collectionView?.scrollToItem(at: IndexPath(row: self.comments.count - 1, section: 0), at: .bottom, animated: true)
                }
            })
        }
    }
    
    func handleSendMessage() {
        print("handleSendMessage")
        /*
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let values = ["message": inputTxtField.text!, "name": "Chibi"]
        ref.updateChildValues(values)
 */
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSendMessage()
        return true
        
    }
    
}
