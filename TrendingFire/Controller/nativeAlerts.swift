//
//  shareCard.swift
//  TrendingFire
//
//  Created by alex on 4/8/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import UIKit

func shareCardAlert(self:UIViewController,sender:UIView) {
    UIGraphicsBeginImageContext(self.view.frame.size)
    self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    let textToShare = "Hey, Check out this awesome card. I found it on Trending Fire"
//    if let myWebsite = URL(string: "http://itunes.apple.com/app/idXXXXXXXXX") {//Enter link to your app here
//    let objectsToShare = [textToShare, myWebsite, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
    let objectsToShare = [textToShare, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                 //Excluded Activities
    activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList,UIActivity.ActivityType.saveToCameraRoll,UIActivity.ActivityType.print,UIActivity.ActivityType.assignToContact]
          activityVC.popoverPresentationController?.sourceView = sender
    self.present(activityVC, animated: true, completion: nil)
//    }
}


func upLoadImageAlert(self:UIViewController,sender:UIButton) {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
    let actionSheet = UIAlertController(title: "Card", message: "Select an Image", preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction(title:"Photo Library",style:.default,handler:{(action:UIAlertAction) in
    imagePickerController.sourceType = .photoLibrary
    self.present(imagePickerController, animated: true, completion:nil)
    }))
    actionSheet.addAction(UIAlertAction(title:"Cancel",style:.cancel,handler:{(action:UIAlertAction) in
    }))
    self.present(actionSheet,animated:true,completion:nil)
}
