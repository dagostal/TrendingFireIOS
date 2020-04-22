//
//  ViewControllerViews.swift
//  TrendingFire
//
//  Created by alex on 3/26/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//


//views and autolayout setup for the view controler

import UIKit



//Subviews

public let profileButton: UIButton = {
    let button = UIButton()
    
    if #available(iOS 13.0, *) {
        let congif = UIImage.SymbolConfiguration(pointSize: 25, weight: .black, scale: .large)
        let profileImg = UIImage(systemName: "person.crop.circle.fill", withConfiguration: congif)?.withTintColor(.white,renderingMode:.alwaysOriginal)
        button.setImage(profileImg,for: .normal)
    } else {
        button.setImage(UIImage(named: "blackprofileicon"), for: .normal)
    }
    button.addTarget(ViewController(), action: #selector(ViewController.profileImageTap), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}()

public let fireBoardButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "rank"), for: .normal)
    button.addTarget(ViewController(), action: #selector(ViewController.fireBoardButtonTap), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}()
   
    
public let trendingFireLabelView: UILabel = {
    let label = UILabel()
    label.text = "Trending Fire"
    label.font = UIFont(name: "Herculanum",size: 24)
    label.textColor = .white
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}()

public let loadingView: UIImageView = {
    let lView = UIImageView()
    lView.image = UIImage(named:"logowhite")
    lView.translatesAutoresizingMaskIntoConstraints = false
    return lView
}()

public let rankView:UILabel = {
    let rLabel = UILabel()
    rLabel.textColor = .green
    
    rLabel.textAlignment = .center
    rLabel.translatesAutoresizingMaskIntoConstraints = false
    return rLabel
}()



//var profileCatButton: dropDownBtn = {
//    let pbutton = dropDownBtn.init(frame:CGRect(x:0,y:0,width:0,height:0))
//    pbutton.translatesAutoresizingMaskIntoConstraints = false
//    pbutton.addBorders(edges: [.bottom], color:.white,thickness:1)
//    return pbutton
//}()




//view auto layouts

func setUpLoadingView(v:UIView) {
    
   loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
    //    kView.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        NSLayoutConstraint(item: loadingView, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 0.85, constant: 0).isActive = true
        loadingView.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.45).isActive = true
        loadingView.widthAnchor.constraint(equalTo: v.widthAnchor,multiplier: 0.7).isActive = true
}


func setUpProfileButton(v:UIView){
    profileButton.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.06).isActive = true
    profileButton.widthAnchor.constraint(equalTo: v.widthAnchor,multiplier: 0.1).isActive = true
    NSLayoutConstraint(item: profileButton, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 0.15, constant: 0).isActive = true
    NSLayoutConstraint(item: profileButton, attribute: .centerX, relatedBy: .equal, toItem: v, attribute: .centerX, multiplier: 0.15, constant: 0).isActive = true
}

func setUpFireBoardButton(v:UIView){
    NSLayoutConstraint(item: fireBoardButton, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 0.15, constant: 0).isActive = true
    NSLayoutConstraint(item: fireBoardButton, attribute: .centerX, relatedBy: .equal, toItem: v, attribute: .centerX, multiplier: 1.85, constant: 0).isActive = true
    
    fireBoardButton.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.06).isActive = true
    fireBoardButton.widthAnchor.constraint(equalTo: v.widthAnchor,multiplier: 0.1).isActive = true
}

func setUpTrendingLabel(v:UIView){
    trendingFireLabelView.leadingAnchor.constraint(equalTo: profileButton.trailingAnchor).isActive = true
    trendingFireLabelView.trailingAnchor.constraint(equalTo: fireBoardButton.leadingAnchor).isActive = true
    trendingFireLabelView.topAnchor.constraint(equalTo: v.safeAreaLayoutGuide.topAnchor,constant: 5 ).isActive = true
    trendingFireLabelView.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.04).isActive = true
}


func setUpKolodaView(v:UIView,kView:KolodaView){
    kView.translatesAutoresizingMaskIntoConstraints = false
    kView.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
//    kView.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
    NSLayoutConstraint(item: kView, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 0.83, constant: 0).isActive = true
    kView.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.45).isActive = true
    kView.widthAnchor.constraint(equalTo: v.widthAnchor,multiplier: 0.75).isActive = true
}

//func setUpProfileCatView(v:UIView){
//    profileCatButton.setTitle("Categories", for: .normal)
//    profileCatButton.backgroundColor = UIColor.black
//    
//    profileCatButton.titleLabel?.font! = UIFont(name: "Herculanum",size: 13)!
//    profileCatButton.titleLabel?.textAlignment = .center
//    profileCatButton.titleLabel?.textColor = .white
//    profileCatButton.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
//    profileCatButton.widthAnchor.constraint(equalTo: v.widthAnchor, multiplier: 0.25).isActive = true
//    profileCatButton.heightAnchor.constraint(equalTo: v.heightAnchor, multiplier: 0.03).isActive = true
//    
//    NSLayoutConstraint(item: profileCatButton, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 0.25, constant: 0).isActive = true
//    
//}

func setUpSwipeButton(swipeUpButton:UIButton,infoView:UIView){
    infoView.bringSubviewToFront(swipeUpButton)
    swipeUpButton.setImage(UIImage(named:"logowhite"), for: .normal)
//
//    swipeUpButton.alpha = 0
    swipeUpButton.backgroundColor = .green
    
    swipeUpButton.translatesAutoresizingMaskIntoConstraints = false
    swipeUpButton.widthAnchor.constraint(equalTo: infoView.widthAnchor,multiplier: 0.11).isActive = true
    swipeUpButton.heightAnchor.constraint(equalTo: infoView.heightAnchor,multiplier:0.23).isActive = true
    swipeUpButton.bottomAnchor.constraint(equalTo: infoView.topAnchor).isActive = true
    NSLayoutConstraint(item: swipeUpButton, attribute: .centerX, relatedBy: .equal, toItem: infoView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
}

func setUpInfoBoxView(infoBox:UIView,v:UIView) {    
    infoBox.translatesAutoresizingMaskIntoConstraints = false
    infoBox.alpha = 0
    infoBox.widthAnchor.constraint(equalTo: v.widthAnchor,multiplier:0.85).isActive = true
    infoBox.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier:0.25).isActive = true
    NSLayoutConstraint(item: infoBox, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 1.7, constant: 0).isActive = true
    infoBox.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
    
    infoBox.layer.borderColor = UIColor.white.cgColor
    infoBox.backgroundColor = .black
    infoBox.layer.borderWidth = 3
    infoBox.layer.cornerRadius = 8
}


func setUpShareButton(shareButton: UIButton, v: UIView) {
    shareButton.alpha = 0
    shareButton.addTarget(ViewController(), action:  #selector(ViewController.shareCard), for: .touchUpInside)
    shareButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: shareButton, attribute: .centerX, relatedBy: .equal, toItem: v, attribute: .centerX, multiplier: 0.3, constant: 0).isActive = true
    NSLayoutConstraint(item: shareButton, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 1.51, constant: 0).isActive = true
}

func setUpFlagButton(flagButton:UIButton,v:UIView){
    flagButton.alpha = 0
    flagButton.addTarget(ViewController(), action:  #selector(ViewController.flagCard), for: .touchUpInside)
    flagButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint(item: flagButton, attribute: .centerX, relatedBy: .equal, toItem: v, attribute: .centerX, multiplier: 1.7, constant: 0).isActive = true
    NSLayoutConstraint(item: flagButton, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 1.51, constant: 0).isActive = true
}

func setUpRankView(rank:String,profileView:UIView) {
    rankView.text = rank

    rankView.widthAnchor.constraint(equalTo: profileView.widthAnchor).isActive = true
    rankView.heightAnchor.constraint(equalTo: profileView.heightAnchor,multiplier: 0.5).isActive = true
    rankView.topAnchor.constraint(equalTo: profileView.bottomAnchor).isActive = true
    NSLayoutConstraint(item: rankView, attribute: .centerX, relatedBy: .equal, toItem: profileView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//    NSLayoutConstraint(item: rankView, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 0.17, constant: 0).isActive = true
}

func setUpProfileCatView(categoryButton:dropDownBtn,v:UIView) {
     categoryButton.translatesAutoresizingMaskIntoConstraints = false
     categoryButton.addBorders(edges: [.bottom], color:.white,thickness:1)
     categoryButton.setTitle("Categories", for: .normal)
     categoryButton.backgroundColor = UIColor.black
     
     categoryButton.titleLabel?.font! = UIFont(name: "Herculanum",size: 13)!
     categoryButton.titleLabel?.textAlignment = .center
     categoryButton.titleLabel?.textColor = .white
     categoryButton.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
     categoryButton.widthAnchor.constraint(equalTo: v.widthAnchor, multiplier: 0.25).isActive = true
     categoryButton.heightAnchor.constraint(equalTo: v.heightAnchor, multiplier: 0.03).isActive = true
     NSLayoutConstraint(item: categoryButton, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 0.25, constant: 0).isActive = true
 }
