//
//  ProfileViewControllerViews.swift
//  TrendingFire
//
//  Created by alex on 3/29/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import UIKit

let addPhotoButton: UIButton = {
  let button = UIButton()
  return button
}()



let toggleContainerView: UISwitch = {
    let toggle = UISwitch()
    toggle.backgroundColor = .black
    toggle.onTintColor = .white
    toggle.addTarget(ProfileViewController(), action: #selector(ProfileViewController.changeToggle), for: .touchUpInside)
    return toggle
}()


let toggleLabel:UILabel = {
    let t = UILabel()
    t.text = "My Cards"
    t.textColor = .white
    t.textAlignment = .center
    t.font! = UIFont(name: "Herculanum",size: 16)!
    return t
}()

let createCardButton: UIButton = {
    let button = UIButton()
    button.layer.cornerRadius = 6
    button.backgroundColor = UIColor.black
    button.setImage(UIImage(named: "create_flame_2"), for: .normal)
    button.addTarget(ProfileViewController(), action: #selector(ProfileViewController.createCard), for: .touchUpInside)
    return button
}()

let profileProfileButton: UIButton = {
    let button = UIButton()
    if #available(iOS 13.0, *) {
        let congif = UIImage.SymbolConfiguration(pointSize: 25, weight: .black, scale: .large)
        let profileImg = UIImage(systemName: "person.crop.circle.fill", withConfiguration: congif)?.withTintColor(.white,renderingMode:.alwaysOriginal)
        button.setImage(profileImg,for: .normal)
    } else {
        button.setImage(UIImage(named: "blackprofileicon"), for: .normal)
    }
    
    button.addTarget(ProfileViewController(), action: #selector(ProfileViewController.profileImageTap), for: .touchUpInside)
   return button
}()

let profileBackButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "logowhite"), for: .normal)
    button.addTarget(ProfileViewController(), action: #selector(ProfileViewController.backTap), for: .touchUpInside)
    return button
}()

let profileLoadingView: UIView = {
    let lView = UIView()
    lView.layer.borderColor = UIColor.green.cgColor
    lView.backgroundColor = .green
    lView.translatesAutoresizingMaskIntoConstraints = false
    return lView
}()

let nameLabel:UILabel = {
    let name = UILabel()
    name.textColor = .white
    name.textAlignment = .center
    name.font! = UIFont(name: "Herculanum",size: 20)!
    name.translatesAutoresizingMaskIntoConstraints = false
    return name
}()

public let profileRankView:UILabel = {
    let rLabel = UILabel()
    rLabel.textColor = .green
    
    rLabel.textAlignment = .center
    rLabel.translatesAutoresizingMaskIntoConstraints = false
    return rLabel
}()

public let userNameView:UILabel = {
    let rLabel = UILabel()
    rLabel.textColor = .green
    
    rLabel.textAlignment = .center
    rLabel.translatesAutoresizingMaskIntoConstraints = false
    return rLabel
}()



func setUpProfileRankView(rank:String,profileView:UIView) {
    profileRankView.text = rank

    profileRankView.widthAnchor.constraint(equalTo: profileView.widthAnchor).isActive = true
    profileRankView.heightAnchor.constraint(equalTo: profileView.heightAnchor,multiplier: 0.5).isActive = true
    profileRankView.topAnchor.constraint(equalTo: profileView.bottomAnchor).isActive = true
    NSLayoutConstraint(item: profileRankView, attribute: .centerX, relatedBy: .equal, toItem: profileView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//    NSLayoutConstraint(item: rankView, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 0.17, constant: 0).isActive = true
}



func setUpProfileProfileButton(v:UIView){
    profileProfileButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint(item: profileProfileButton, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 0.15, constant: 0).isActive = true
    NSLayoutConstraint(item: profileProfileButton, attribute: .centerX, relatedBy: .equal, toItem: v, attribute: .centerX, multiplier: 0.15, constant: 0).isActive = true
    
    profileProfileButton.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.06).isActive = true
    profileProfileButton.widthAnchor.constraint(equalTo: v.widthAnchor,multiplier: 0.1).isActive = true
  }

func setupProfileBackButton(v:UIView){
    profileBackButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint(item: profileBackButton, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 0.15, constant: 0).isActive = true
    NSLayoutConstraint(item: profileBackButton, attribute: .centerX, relatedBy: .equal, toItem: v, attribute: .centerX, multiplier: 1.85, constant: 0).isActive = true
    
    profileBackButton.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.1).isActive = true
    profileBackButton.widthAnchor.constraint(equalTo: v.widthAnchor,multiplier: 0.15).isActive = true
}

func setupNameLabel(name:String,v:UIView){
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.text = name
    
    NSLayoutConstraint(item: nameLabel, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 0.15, constant: 0).isActive = true
    NSLayoutConstraint(item: nameLabel, attribute: .centerX, relatedBy: .equal, toItem: v, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    
    nameLabel.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.06).isActive = true
    nameLabel.widthAnchor.constraint(equalTo: v.widthAnchor,multiplier: 0.7).isActive = true

}

func setUpCreateCardButton(v:UIView) {
    createCardButton.translatesAutoresizingMaskIntoConstraints = false
    createCardButton.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
    createCardButton.widthAnchor.constraint(equalTo: v.widthAnchor,multiplier: 0.5).isActive = true
    createCardButton.heightAnchor.constraint(equalTo: v.heightAnchor, multiplier: 0.22).isActive = true
    NSLayoutConstraint(item: createCardButton, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 0.45, constant: 0).isActive = true
    
    createCardButton.layer.borderWidth = 2.0
    setUptoggleContainerView(v:v)
}



func setUpTableView(t:UITableView,v:UIView){
    t.layer.borderWidth = 3.0
    t.layer.cornerRadius = 20
    t.layer.backgroundColor = UIColor.green.cgColor
    
    t.translatesAutoresizingMaskIntoConstraints = false
    t.widthAnchor.constraint(equalTo: v.widthAnchor,multiplier: 0.8).isActive = true
    t.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.48).isActive = true
    t.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
    
    NSLayoutConstraint(item: t, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 1.45, constant: 0).isActive = true
}
func setUpCreateCardNewView(newView:UIView,v:UIView) {
    newView.backgroundColor = UIColor.black
    newView.layer.borderColor = UIColor.white.cgColor
    newView.layer.borderWidth = 1
    newView.layer.cornerRadius = 1
    
    newView.translatesAutoresizingMaskIntoConstraints = false
    newView.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
    newView.topAnchor.constraint(equalTo: v.topAnchor,constant: 70).isActive = true
    newView.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.85).isActive = true
    newView.widthAnchor.constraint(equalTo: v.widthAnchor,multiplier: 0.85).isActive = true
}


func setUpAddPhotoButton(newView:UIView) {
    addPhotoButton.setImage(UIImage(named:"addImage"), for: .normal)
    addPhotoButton.layer.borderColor = UIColor.white.cgColor
    addPhotoButton.layer.borderWidth = 1
    
    addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
    addPhotoButton.centerXAnchor.constraint(equalTo: newView.centerXAnchor).isActive = true
    addPhotoButton.topAnchor.constraint(equalTo: newView.topAnchor,constant: 15).isActive = true
    addPhotoButton.widthAnchor.constraint(equalTo: newView.widthAnchor,multiplier: 0.45).isActive = true
    addPhotoButton.heightAnchor.constraint(equalTo: newView.heightAnchor,multiplier: 0.25).isActive = true
}

func setUpNameTextField(nameTextFieldInput:UITextField,newView:UIView){
    nameTextFieldInput.layer.borderColor = UIColor.white.cgColor
    nameTextFieldInput.layer.borderWidth = 1
    nameTextFieldInput.layer.cornerRadius = 2
        
    nameTextFieldInput.placeholder = "Card Name"
    nameTextFieldInput.textAlignment = .center
        
    nameTextFieldInput.font = UIFont(name: "Herculanum",size: 16)!
    nameTextFieldInput.borderStyle = UITextField.BorderStyle.roundedRect
    nameTextFieldInput.autocorrectionType = UITextAutocorrectionType.no
    nameTextFieldInput.keyboardType = UIKeyboardType.default
    nameTextFieldInput.returnKeyType = UIReturnKeyType.done
    nameTextFieldInput.clearButtonMode = UITextField.ViewMode.whileEditing
    nameTextFieldInput.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    
    nameTextFieldInput.translatesAutoresizingMaskIntoConstraints = false
    nameTextFieldInput.centerXAnchor.constraint(equalTo: newView.centerXAnchor).isActive = true
    nameTextFieldInput.heightAnchor.constraint(equalTo: newView.heightAnchor,multiplier: 0.09).isActive = true
    nameTextFieldInput.widthAnchor.constraint(equalTo: newView.widthAnchor,multiplier: 0.7).isActive = true
    NSLayoutConstraint(item: nameTextFieldInput, attribute: .centerY, relatedBy: .equal, toItem: newView, attribute: .centerY, multiplier: 0.75, constant: 0).isActive = true
}


func setUpDescTextField(descFieldInput:UITextField,newView:UIView){
    descFieldInput.layer.borderColor = UIColor.white.cgColor
    descFieldInput.layer.borderWidth = 1
    descFieldInput.layer.cornerRadius = 2

    descFieldInput.placeholder = "Card Description"
    descFieldInput.textAlignment = .center
            
    descFieldInput.font = UIFont(name: "Herculanum",size: 16)!
    descFieldInput.borderStyle = UITextField.BorderStyle.roundedRect
    descFieldInput.autocorrectionType = UITextAutocorrectionType.no
    descFieldInput.keyboardType = UIKeyboardType.default
    descFieldInput.returnKeyType = UIReturnKeyType.done
    descFieldInput.clearButtonMode = UITextField.ViewMode.whileEditing
    descFieldInput.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    
    descFieldInput.translatesAutoresizingMaskIntoConstraints = false
    descFieldInput.centerXAnchor.constraint(equalTo: newView.centerXAnchor).isActive = true
    descFieldInput.heightAnchor.constraint(equalTo: newView.heightAnchor,multiplier: 0.09).isActive = true
    descFieldInput.widthAnchor.constraint(equalTo: newView.widthAnchor,multiplier: 0.7).isActive = true
    NSLayoutConstraint(item: descFieldInput, attribute: .centerY, relatedBy: .equal, toItem: newView, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
}



func setUpLinkTextField(linkFieldInput:UITextField,newView:UIView) {
    linkFieldInput.layer.borderColor = UIColor.white.cgColor
    linkFieldInput.layer.borderWidth = 1
    linkFieldInput.layer.cornerRadius = 2
    linkFieldInput.placeholder = "Link"
    linkFieldInput.textAlignment = .center
                         
    linkFieldInput.font = UIFont(name: "Herculanum",size: 16)!
    linkFieldInput.borderStyle = UITextField.BorderStyle.roundedRect
    linkFieldInput.autocorrectionType = UITextAutocorrectionType.no
    linkFieldInput.keyboardType = UIKeyboardType.default
    linkFieldInput.returnKeyType = UIReturnKeyType.done
    linkFieldInput.clearButtonMode = UITextField.ViewMode.whileEditing
    linkFieldInput.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    
    linkFieldInput.translatesAutoresizingMaskIntoConstraints = false
    linkFieldInput.centerXAnchor.constraint(equalTo: newView.centerXAnchor).isActive = true
    linkFieldInput.heightAnchor.constraint(equalTo: newView.heightAnchor,multiplier: 0.09).isActive = true
    linkFieldInput.widthAnchor.constraint(equalTo: newView.widthAnchor,multiplier: 0.7).isActive = true
    NSLayoutConstraint(item: linkFieldInput, attribute: .centerY, relatedBy: .equal, toItem: newView, attribute: .centerY, multiplier: 1.25, constant: 0).isActive = true
}


func setUpCatPickerView(catView:UIPickerView,newView:UIView) {
    catView.backgroundColor = .black
    catView.translatesAutoresizingMaskIntoConstraints = false
    catView.centerXAnchor.constraint(equalTo: newView.centerXAnchor).isActive = true
    catView.heightAnchor.constraint(equalTo: newView.heightAnchor,multiplier: 0.15).isActive = true
    catView.widthAnchor.constraint(equalTo: newView.heightAnchor,multiplier: 0.4).isActive = true
    NSLayoutConstraint(item: catView, attribute: .centerY, relatedBy: .equal, toItem: newView, attribute: .centerY, multiplier: 1.5, constant: 0).isActive = true
}

func setUpSubmitButton(submitButton:UIButton,newView:UIView){
    submitButton.backgroundColor = .black
    submitButton.layer.borderColor = UIColor.white.cgColor
    submitButton.layer.borderWidth = 1
    
    submitButton.setTitle("Submit Card",for:.normal)
    submitButton.titleLabel?.font! = UIFont(name: "Herculanum",size: 16)!
             
    submitButton.translatesAutoresizingMaskIntoConstraints = false
    submitButton.centerXAnchor.constraint(equalTo: newView.centerXAnchor).isActive = true
    submitButton.heightAnchor.constraint(equalTo: newView.heightAnchor,multiplier: 0.1).isActive = true
    submitButton.widthAnchor.constraint(equalTo: newView.heightAnchor,multiplier: 0.3).isActive = true
    NSLayoutConstraint(item: submitButton, attribute: .centerY, relatedBy: .equal, toItem: newView, attribute: .centerY, multiplier: 1.85, constant: 0).isActive = true
}

func setUpToggleLabel(v:UIView){
    toggleLabel.layer.borderWidth = 1
    toggleLabel.translatesAutoresizingMaskIntoConstraints = false
    toggleLabel.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
    toggleLabel.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.05).isActive = true
    toggleLabel.widthAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.2).isActive = true
    NSLayoutConstraint(item: toggleLabel, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 0.9, constant: 0).isActive = true
}

func setUptoggleContainerView(v:UIView) {
    toggleContainerView.translatesAutoresizingMaskIntoConstraints = false
    toggleContainerView.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
    toggleContainerView.widthAnchor.constraint(equalTo: v.widthAnchor,multiplier: 0.1).isActive = true
    toggleContainerView.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.04).isActive = true
    NSLayoutConstraint(item: toggleContainerView, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 0.76, constant: 0).isActive = true
}
