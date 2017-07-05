//
//  RegisterVC.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-04.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var containerView = UIView()

    let loginRegisterBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(checkLoginRegisterBtn), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    

    let registerParentBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Register Parent", for: .normal)
        btn.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(.white, for: .normal)
        //btn.addTarget(self, action: #selector(handleRegisterParent), for: .touchUpInside)
        btn.alpha = 0
        btn.isEnabled = false
        return btn
    }()
    
    let registerAdopteeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Register Adoptee", for: .normal)
        btn.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(.white, for: .normal)
        //btn.addTarget(self, action: #selector(handleRegisterAdoptee), for: .touchUpInside)
        btn.alpha = 0
        btn.isEnabled = false
        return btn
    }()
   /*
    let linkLabel: TextView = {
        let label = TextView()
        let formattedString = NSMutableAttributedString()
        formattedString
            .bold("Work is just a word we made up;")
            .normal("\nWhat it means is you as a person adding some kind of value to the world.\n\n")
            .bold("What do you want to be remembered for?")
            .normal("\nImagine lying on your deathbed, what do you want to reminisce on with your loved ones? What are the values that you want to give to the world?\n\n")
            .bold("Repeat the exercise and try to go a little bit deeper")
            .normal("\nIt’s ok if your answers are the same, but it’s an awesome challenge to go closer to your core as a person.\n")
        label.attributedText = formattedString
        label.textColor = UIColor.rgb(red: 114, green: 114, blue: 114, alpha: 1)
        label.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 246, alpha: 1)
        label.textAlignment = .left
        label.displayScrolling = true
        label.isEditable = false
        return label
    }()
    */
    
    let registerTextView: UITextView = {
        let textView = UITextView()
        let formattedString = NSMutableAttributedString()
        formattedString
            .bold("Register")
            .normal("\nSome information about register…\nbla bla bla\n")
        textView.attributedText = formattedString
        textView.textColor = UIColor.rgb(red: 114, green: 114, blue: 114, alpha: 1)
        textView.textAlignment = .center
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    let loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["ALC", "CC"])
        sc.tintColor = UIColor.rgb(red: 100, green: 100, blue: 100, alpha: 1)
        sc.addTarget(self, action: #selector(handleLoginRegisterSegemtedControl), for: .valueChanged)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    //
    let userCountryTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250, alpha: 1)
        textField.text = "UserCountry..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let userGroupParent: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250, alpha: 1)
        textField.text = "Parent"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let userGroupAdoptee: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250, alpha: 1)
        textField.text = "Adoptee"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let userGroupAdmin: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250, alpha: 1)
        textField.text = "Admin"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let userDescriptionTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250, alpha: 1)
        textField.text = "UserDescription..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let isAdmin: UISwitch = {
        let adminSwitch = UISwitch()
        //adminSwitch.setOn(false, animated: false)
        adminSwitch.isOn = true
        //adminSwitch.addTarget(self, action: #selector(switchIsChanged(adminSwitch:)), for: .valueChanged)
        return adminSwitch
    }()
    
    
    //MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CC")
        
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width: view.bounds.width, height: 1000)
        
        containerView = UIView()
        
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        
        view.backgroundColor = UIColor.white

        self.hideKeyboardWhenTappedAround()
        setupViews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        containerView.frame = CGRect(x:0, y:0, width:scrollView.contentSize.width, height:scrollView.contentSize.height)
    }
    
    //
    fileprivate func setupViews() {
        containerView.addSubview(registerTextView)
        registerTextView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 100, paddingLeft: 40, paddingBottom: 0, paddingRight: -40, width: 0, height: 140)
   
        scrollView.addSubview(loginRegisterSegmentedControl)
        loginRegisterSegmentedControl.anchor(top: registerTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: -40, width: 0, height: 40)
        
        
        
        let stackview = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, loginRegisterBtn, registerParentBtn, registerAdopteeBtn])
        
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.distribution = .fillEqually
        stackview.axis = .vertical
        stackview.spacing = 10
        
        view.addSubview(stackview)
        
        stackview.anchor(top: loginRegisterSegmentedControl.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: -40, width: 0, height: 300)
    }
    
    func handleTextInputChange() {
        let isEmailValid = emailTextField.text?.characters.count ?? 0 > 0 &&
            usernameTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
        if isEmailValid {
            loginRegisterBtn.isEnabled = true
            loginRegisterBtn.backgroundColor = UIColor.rgb(red: 50, green: 145, blue: 255, alpha: 1)
            registerAdopteeBtn.backgroundColor = UIColor.rgb(red: 50, green: 145, blue: 255, alpha: 1)
            registerParentBtn.backgroundColor = UIColor.rgb(red: 50, green: 145, blue: 255, alpha: 1)
        } else {
            loginRegisterBtn.isEnabled = false
            loginRegisterBtn.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244, alpha: 1)
            registerParentBtn.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244, alpha: 1)
            registerAdopteeBtn.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244, alpha: 1)
        }
    }
    
    func loginAlert() {
        let alertController = UIAlertController(title: "Sorry", message: "Wrong email or password", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func registerAlert() {
        let alertController = UIAlertController(title: "Please", message: "Enter all the needed information.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func handleLoginRegisterSegemtedControl() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterBtn.setTitle(title, for: .normal)
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            self.registerParentBtn.alpha = 0
            self.registerParentBtn.isEnabled = false
            self.registerAdopteeBtn.alpha = 0
            self.registerAdopteeBtn.isEnabled = false
            self.view.backgroundColor = UIColor.white
        } else {
            self.registerParentBtn.alpha = 1
            self.registerParentBtn.isEnabled = true
            self.registerAdopteeBtn.alpha = 1
            self.registerAdopteeBtn.isEnabled = true
            self.loginRegisterBtn.isEnabled = true
            self.view.backgroundColor = UIColor.brown
        }
    }
    
    
    func checkLoginRegisterBtn() {
        let dataHandler = DataHandler()
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            // ALC
            guard let email = emailTextField.text, email.characters.count > 0 else { return }
            guard let password = passwordTextField.text, password.characters.count > 0 else { return }
            
            dataHandler.registerUser(email: email, password: password, inviteCode: "") { user in
                print( user.email! )
                // TODO: Implelemnt inviteCode
                // Open viewcontroller after succefully created new user.
            }
            
        } else {
            // CC
            guard let email = emailTextField.text, email.characters.count > 0 else { return }
            guard let password = passwordTextField.text, password.characters.count > 0 else { return }
            
            dataHandler.registerUser(email: email, password: password, inviteCode: "") { user in
                print( user.email! )
                // Open viewcontroller after succefully created new user.
            }

           
        }
    }
    
    //MARK: ProfileImage
    func handleProfileImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            //profileImageBtn.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            //profileImageBtn.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    
}
