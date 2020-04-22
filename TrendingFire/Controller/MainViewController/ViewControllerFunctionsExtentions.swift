//
//  dismissKeyboard.swift
//  TrendingFire
//
//  Created by alex on 4/12/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import UIKit

extension ViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
                self.categoryButton.tappedOutside()
        }
    }
    
    func setUserId() -> String {
        if(Userdefaults.object(forKey: "userID") != nil) {
            return Userdefaults.object(forKey: "userID") as! String
        }
        return " "
    }
    
    func setLoggedInStatus() -> Bool {
        if(Userdefaults.object(forKey: "loggedIn") != nil) {
            return Userdefaults.object(forKey: "loggedIn") as! Bool
        }
        return false
    }
//    @objc func exitDropDown() {
//        if(self.categoryButton.doneOpening == true && self.categoryButton.isBeingTouched == false) {
//            self.categoryButton.tappedOutside()
//        }
        
    }
