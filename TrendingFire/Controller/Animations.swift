//
//  Animations.swift
//  TrendingFire
//
//  Created by alex on 4/8/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import UIKit

import UIKit


struct TrendingFireAnimations {
    
    let controller:UIViewController
    
    func profileToMainAnimation() {
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            let transition: CATransition = CATransition()
            transition.duration = 0.2
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.reveal
            transition.subtype = CATransitionSubtype.fromRight
            self.controller.view.window!.layer.add(transition, forKey: nil)
            self.controller.dismiss(animated: false, completion: nil)
        })
    }


    func fireToMain() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
               let transition: CATransition = CATransition()
               transition.duration = 0.25
               transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
               transition.type = CATransitionType.reveal
               transition.subtype = CATransitionSubtype.fromLeft
                self.controller.view.window!.layer.add(transition, forKey: nil)
                self.controller.dismiss(animated: false, completion: nil)
           })
    }
    
    func popUpCard(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 11, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.controller.view.layoutIfNeeded()
        }, completion: nil)
    }
}
