//
//  CardPopUpViews.swift
//  TrendingFire
//
//  Created by alex on 4/7/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import UIKit

func setUpPopUpCardView(popUpView:UIView,v:UIView) {
    popUpView.layer.borderColor = UIColor.white.cgColor
    popUpView.layer.borderWidth = 1
    popUpView.layer.cornerRadius = 8
    popUpView.backgroundColor = UIColor.black
    
    popUpView.translatesAutoresizingMaskIntoConstraints = false
    popUpView.leadingAnchor.constraint(equalTo: v.leadingAnchor,constant:15).isActive = true
    popUpView.trailingAnchor.constraint(equalTo: v.trailingAnchor,constant: -15).isActive = true
    popUpView.topAnchor.constraint(equalTo: v.topAnchor,constant: 70).isActive = true
    popUpView.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.8).isActive = true
}

func setUpImageHolder(imageHolder:UIImageView,pv:UIView,image:UIImage){

    imageHolder.image = image
    imageHolder.backgroundColor = UIColor.red
    imageHolder.translatesAutoresizingMaskIntoConstraints = false
    imageHolder.centerXAnchor.constraint(equalTo: pv.centerXAnchor).isActive = true
    imageHolder.topAnchor.constraint(equalTo: pv.topAnchor,constant: 25).isActive = true
    imageHolder.widthAnchor.constraint(equalTo: pv.widthAnchor,multiplier: 0.8).isActive = true
    imageHolder.heightAnchor.constraint(equalTo: pv.heightAnchor,multiplier: 0.5).isActive = true
}

func setUpTextView(textView:UIView,popUpCardView:UIView){
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.bottomAnchor.constraint(equalTo: popUpCardView.bottomAnchor,constant:-10).isActive = true
    textView.widthAnchor.constraint(equalTo: popUpCardView.widthAnchor,multiplier:0.85).isActive = true
    textView.heightAnchor.constraint(equalTo: popUpCardView.heightAnchor,multiplier:0.3).isActive = true
    textView.centerXAnchor.constraint(equalTo: popUpCardView.centerXAnchor).isActive = true
    textView.layer.borderColor = UIColor.white.cgColor
    textView.layer.borderWidth = 1
    textView.layer.cornerRadius = 8
}

func setUpTitleLabel(titleLabel:UILabel,infoView:UIView,title:String) {
    titleLabel.text = title
    titleLabel.font! = UIFont(name: "Herculanum",size: 22)!
    titleLabel.textAlignment = .center
    titleLabel.alpha = 1
    titleLabel.textColor = .white
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.topAnchor.constraint(equalTo: infoView.topAnchor).isActive = true
    titleLabel.widthAnchor.constraint(equalTo: infoView.widthAnchor).isActive = true
    titleLabel.heightAnchor.constraint(equalTo: infoView.heightAnchor,multiplier:0.3).isActive = true
    titleLabel.centerXAnchor.constraint(equalTo: infoView.centerXAnchor).isActive = true
}

func setUpDescLabel(descLabel:UILabel,infoView:UIView,description:String){
    descLabel.text = description
    descLabel.font! = UIFont(name: "Herculanum",size: 16)!
    descLabel.alpha = 1
    
    descLabel.textAlignment = .center
    descLabel.textColor = .white
    descLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: descLabel, attribute: .centerY, relatedBy: .equal, toItem: infoView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    descLabel.widthAnchor.constraint(equalTo: infoView.widthAnchor).isActive = true
    descLabel.heightAnchor.constraint(equalTo: infoView.heightAnchor,multiplier:0.3).isActive = true
    descLabel.centerXAnchor.constraint(equalTo: infoView.centerXAnchor).isActive = true
}

func setUpLinkButton(linkButton:UIButton,infoView:UIView) {

    linkButton.setTitle("Link", for: .normal)
    linkButton.titleLabel!.font = UIFont(name: "Herculanum",size: 18)!
    linkButton.titleLabel!.textAlignment = .center
    linkButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: linkButton, attribute: .centerY, relatedBy: .equal, toItem: infoView, attribute: .centerY, multiplier: 1.7, constant: 0).isActive = true
    linkButton.widthAnchor.constraint(equalTo: infoView.widthAnchor).isActive = true
    linkButton.heightAnchor.constraint(equalTo: infoView.heightAnchor,multiplier:0.3).isActive = true
    linkButton.centerXAnchor.constraint(equalTo: infoView.centerXAnchor).isActive = true

}


func setUpRankLabel(rankLabel: UILabel, infoView: UIView, rank: String) {
    let degreeText = rank + "°"
    rankLabel.text = degreeText
    rankLabel.alpha = 1
    rankLabel.textColor = .orange
    rankLabel.textAlignment = .center
    rankLabel.font! = UIFont(name: "Herculanum",size: 15)!
    rankLabel.translatesAutoresizingMaskIntoConstraints = false

    rankLabel.widthAnchor.constraint(equalTo: infoView.widthAnchor,multiplier: 0.2).isActive = true
    rankLabel.heightAnchor.constraint(equalTo: infoView.heightAnchor,multiplier:0.15).isActive = true
    rankLabel.bottomAnchor.constraint(equalTo: infoView.topAnchor).isActive = true
    rankLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor).isActive = true
}

func setUpAuthorLabel(authorLabel: UILabel, infoView: UIView, author: String) {
    authorLabel.text = author
    authorLabel.textColor = .white
    authorLabel.font! = UIFont(name: "Herculanum",size: 15)!
    authorLabel.alpha = 1
    authorLabel.textAlignment = .right
    authorLabel.translatesAutoresizingMaskIntoConstraints = false
    
    authorLabel.widthAnchor.constraint(equalTo: infoView.widthAnchor,multiplier: 0.7).isActive = true
    authorLabel.heightAnchor.constraint(equalTo: infoView.heightAnchor,multiplier:0.15).isActive = true
    authorLabel.bottomAnchor.constraint(equalTo: infoView.topAnchor).isActive = true
    authorLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor).isActive = true
}
