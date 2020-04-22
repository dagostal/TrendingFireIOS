//
//  RegistrationViews.swift
//  TrendingFire
//
//  Created by alex on 4/21/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import UIKit


//login views

let trendingFireLabel: UILabel = {
    let label = UILabel()
    label.text = "Trending Fire"
    label.textColor = .white
    label.backgroundColor = .black
    label.font = UIFont(name: "Herculanum",size: 24)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}()
    
let loginButton: UIButton = {
    let button = UIButton()
    button.setTitle("Login", for: .normal)
    button.titleLabel!.font = UIFont(name: "Herculanum",size: 18)!
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}()

let userNameTextField: UITextField = {
    let inputField = UITextField()
    inputField.translatesAutoresizingMaskIntoConstraints = false
    inputField.layer.borderWidth = 5
    inputField.layer.cornerRadius = 13
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
    
let passwordTextField: UITextField = {
    let inputField = UITextField()
    inputField.translatesAutoresizingMaskIntoConstraints = false
    inputField.layer.borderWidth = 5
    inputField.layer.cornerRadius = 13
    inputField.textAlignment = .center

    inputField.textColor = .white
    inputField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    inputField.font = UIFont(name: "Herculanum",size: 18)

    inputField.isSecureTextEntry = true
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
    
    

func setUpUserNameTextField(v:UIView) {
    userNameTextField.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
    userNameTextField.topAnchor.constraint(equalTo: trendingFireLabel.bottomAnchor,constant:45).isActive = true
    userNameTextField.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.1).isActive = true
    userNameTextField.widthAnchor.constraint(equalTo: v.widthAnchor,multiplier: 0.6).isActive = true
    
}

func setUpPasswordTextField(v:UIView) {    
    passwordTextField.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
    passwordTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 45).isActive = true
    passwordTextField.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.1).isActive = true
    passwordTextField.widthAnchor.constraint(equalTo: v.widthAnchor,multiplier: 0.6).isActive = true
    
}

func setUpLoginButton(v:UIView) {
    loginButton.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
    loginButton.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.2).isActive = true
    loginButton.widthAnchor.constraint(equalTo: v.widthAnchor,multiplier: 0.3).isActive = true
    NSLayoutConstraint(item: loginButton, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 1.4, constant: 0).isActive = true
}
    
    
func setUpTrendingFireLabel(v:UIView) {
    trendingFireLabel.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
    trendingFireLabel.topAnchor.constraint(equalTo: v.topAnchor, constant: 50).isActive = true
    trendingFireLabel.heightAnchor.constraint(equalTo: v.heightAnchor, multiplier: 0.2).isActive = true
    trendingFireLabel.widthAnchor.constraint(equalTo: v.widthAnchor).isActive = true
}


