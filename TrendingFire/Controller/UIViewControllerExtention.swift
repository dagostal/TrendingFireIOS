//
//  UIViewControllerExtention.swift
//  TrendingFire
//
//  Created by alex on 4/15/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import UIKit
import SafariServices

var vSpin:UIView?
 
extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func goToLinkDestination(sender:FireButton) {
         if let url = URL(string:sender.fireLink) {
             if(UIApplication.shared.canOpenURL(url) == true){
                 present(SFSafariViewController(url: url), animated: true, completion: nil)
             }
         }
     }
    
    func showSpinner(onView:UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        vSpin = spinnerView
    }
    
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpin?.removeFromSuperview()
            vSpin = nil
        }
    }
}

class FireButton:UIButton {
    var fireLink:String = ""
}
