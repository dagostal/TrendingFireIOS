//
//  SignupViews.swift
//  TrendingFire
//
//  Created by alex on 4/21/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import UIKit


let trendingFireLabelSignup: UILabel = {
    let label = UILabel()
    label.text = "Create Account"
    label.textColor = .white
    label.backgroundColor = .black
        
    label.font = UIFont(name: "Herculanum",size: 24)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}()
    

let signupButton: UIButton = {
    let button = UIButton()
    
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .black
    button.setTitle("Create Account", for: .normal)
    button.titleLabel!.font = UIFont(name: "Herculanum",size: 18)!
    button.titleLabel?.textAlignment = .center
    return button
}()
    
let userNameTextFieldSignup: UITextField = {
    let inputField = UITextField()
    inputField.translatesAutoresizingMaskIntoConstraints = false
    inputField.layer.borderWidth = 5
    inputField.layer.cornerRadius = 13
  
    inputField.placeholder = "email"
    inputField.textColor = .white
    inputField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    inputField.font = UIFont(name: "Herculanum",size: 18)

    inputField.textAlignment = .center
    inputField.layer.borderColor = UIColor.white.cgColor
    inputField.layer.borderWidth = 1
    inputField.layer.cornerRadius = 1
    inputField.backgroundColor = .black
    
    inputField.borderStyle = UITextField.BorderStyle.roundedRect
    inputField.autocorrectionType = UITextAutocorrectionType.no
    inputField.keyboardType = UIKeyboardType.default
    inputField.returnKeyType = UIReturnKeyType.done
    inputField.clearButtonMode = UITextField.ViewMode.whileEditing
    inputField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
  
    return inputField
}()

let fireNameTextField: UITextField = {
    let inputField = UITextField()
    inputField.translatesAutoresizingMaskIntoConstraints = false
    inputField.layer.borderWidth = 5
    inputField.layer.cornerRadius = 13
    inputField.textColor = .black
    inputField.textAlignment = .center
    inputField.placeholder = "Name"

    inputField.textColor = .white
    inputField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    inputField.font = UIFont(name: "Herculanum",size: 18)

    inputField.textColor = .white
    inputField.textAlignment = .center
         
    inputField.layer.borderColor = UIColor.white.cgColor
    inputField.layer.borderWidth = 1
    inputField.layer.cornerRadius = 1
    inputField.backgroundColor = .black
        
    inputField.borderStyle = UITextField.BorderStyle.roundedRect
    inputField.autocorrectionType = UITextAutocorrectionType.no
    inputField.keyboardType = UIKeyboardType.default
    inputField.returnKeyType = UIReturnKeyType.done
    inputField.clearButtonMode = UITextField.ViewMode.whileEditing
    inputField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    

    return inputField
}()
    
let passwordTextFieldSignup: UITextField = {
    let inputField = UITextField()
    inputField.translatesAutoresizingMaskIntoConstraints = false
    inputField.layer.borderWidth = 5
    inputField.layer.cornerRadius = 13
    inputField.textColor = .black
    inputField.textAlignment = .center
    inputField.placeholder = "Password"
    inputField.isSecureTextEntry = true
    inputField.textColor = .white
    inputField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    inputField.font = UIFont(name: "Herculanum",size: 18)

    inputField.textColor = .white
    inputField.textAlignment = .center
     
    inputField.layer.borderColor = UIColor.white.cgColor
    inputField.layer.borderWidth = 1
    inputField.layer.cornerRadius = 1
    inputField.backgroundColor = .black
    
    inputField.borderStyle = UITextField.BorderStyle.roundedRect
    inputField.autocorrectionType = UITextAutocorrectionType.no
    inputField.keyboardType = UIKeyboardType.default
    inputField.returnKeyType = UIReturnKeyType.done
    inputField.clearButtonMode = UITextField.ViewMode.whileEditing
    inputField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    

    return inputField
}()
    


func setUpTrendingFireLabelSignup(v:UIView) {
    trendingFireLabelSignup.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
    trendingFireLabelSignup.topAnchor.constraint(equalTo: v.topAnchor, constant: 20).isActive = true
    trendingFireLabelSignup.heightAnchor.constraint(equalTo: v.heightAnchor, multiplier: 0.2).isActive = true
    trendingFireLabelSignup.widthAnchor.constraint(equalTo: v.widthAnchor).isActive = true
}

func setUpUserNameTextFieldSignup(v:UIView) {
    userNameTextFieldSignup.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
    NSLayoutConstraint(item: userNameTextFieldSignup, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 0.6, constant: 0).isActive = true
    userNameTextFieldSignup.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.1).isActive = true
    userNameTextFieldSignup.widthAnchor.constraint(equalTo: v.widthAnchor,multiplier: 0.6).isActive = true
}

func setUpPasswordTextFieldSignup(v:UIView) {
    passwordTextFieldSignup.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
    NSLayoutConstraint(item: passwordTextFieldSignup, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    passwordTextFieldSignup.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.1).isActive = true
    passwordTextFieldSignup.widthAnchor.constraint(equalTo: v.widthAnchor,multiplier: 0.6).isActive = true
}

func setUpFireNameTextField(v:UIView) {
    fireNameTextField.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
    NSLayoutConstraint(item: fireNameTextField, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 1.4, constant: 0).isActive = true
    fireNameTextField.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.1).isActive = true
    fireNameTextField.widthAnchor.constraint(equalTo: v.widthAnchor,multiplier: 0.6).isActive = true
}

func setUpSignUpButton(v:UIView) {
    signupButton.translatesAutoresizingMaskIntoConstraints = false
    signupButton.heightAnchor.constraint(equalTo:v.heightAnchor,multiplier:0.1).isActive = true
    signupButton.widthAnchor.constraint(equalTo:v.heightAnchor,multiplier:0.3).isActive = true
    signupButton.centerXAnchor.constraint(equalTo:v.centerXAnchor).isActive = true
    
    NSLayoutConstraint(item: signupButton, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 1.7, constant: 0).isActive = true
}

