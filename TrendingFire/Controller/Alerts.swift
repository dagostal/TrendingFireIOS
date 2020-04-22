//
//  Alerts.swift
//  TrendingFire
//
//  Created by alex on 4/7/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import UIKit

func trendingFireAlerts(alertName:String,sender:UIViewController) -> UIAlertController{
    
    let flagAlert = UIAlertController(title: "Thank you for flagging", message: "Our policy team will review this to ensure it meets our standards", preferredStyle: .alert)
    flagAlert.addAction(UIAlertAction(title: "Fire", style: .default, handler: nil))
    
    let firstTimeAlert = UIAlertController(title: "Welcome To Trending Fire", message: "Swipe Left or Right to the affect the rank of a card. Swipe Up if you would like to save a card.", preferredStyle: .alert)
    firstTimeAlert.addAction(UIAlertAction(title: "Fire", style: .default, handler: nil))
    
    let cardCreationAlert = UIAlertController(title: "Missing Information", message: "Please include information about your card", preferredStyle: .alert)
    cardCreationAlert.addAction(UIAlertAction(title: "Fire", style: .default, handler: nil))
    
    let errorAlert = UIAlertController(title:"Woops",message:"Something went wrong, please check your interenet connection",preferredStyle: .alert)
    errorAlert.addAction(UIAlertAction(title: "Fire", style: .default, handler: nil))
    
    let createAccount = UIAlertController(title: "Create an Account", message: "Create an account to contribute to Trending Fire", preferredStyle: .alert)
    createAccount.addAction(UIAlertAction(title: "Fire", style: .default, handler: {(action:UIAlertAction!) in
        sender.performSegue(withIdentifier: "alert", sender: sender)
    }))
    
    let cantDoApperal = UIAlertController(title: "Coming Soon", message: "Apparel Creation Coming Soon", preferredStyle: .alert)
    cantDoApperal.addAction(UIAlertAction(title: "Fire", style: .default, handler: nil))
    
    let nameTooLong = UIAlertController(title: "Title Too Long", message: "Card Title must be less than 20 characters", preferredStyle: .alert)
    nameTooLong.addAction(UIAlertAction(title: "Fire", style: .default, handler: nil))
    
    let descTooLong = UIAlertController(title: "Description too long", message: "Description must be less than 30 characters", preferredStyle: .alert)
    descTooLong.addAction(UIAlertAction(title: "Fire", style: .default, handler: nil))
        
    let userNameTooLong = UIAlertController(title: "User Name Too Long", message: "Username must be less than 15 characters", preferredStyle: .alert)
    userNameTooLong.addAction(UIAlertAction(title: "Fire", style: .default, handler: nil))
    
    switch alertName {
        case "flagAlert":
            return flagAlert
        case "firstTimeAlert":
            return firstTimeAlert
        case "missingInfo":
            return cardCreationAlert
        case "createAccount":
            return createAccount
        case "cantDoApperal":
            return cantDoApperal
        case "descTooLong":
            return descTooLong
        case "nameTooLong":
            return nameTooLong
        case "userNameTooLong":
            return userNameTooLong
        default:
            return errorAlert
    }
}
