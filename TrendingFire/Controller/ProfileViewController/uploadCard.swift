//
//  uploadCard.swift
//  TrendingFire
//
//  Created by alex on 4/8/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


func uploadCard(params:[String:String],imageToUpload:UIImage,sender:ProfileViewController,popUpView:UIView) {
    
    let imgData = imageToUpload.jpegData(compressionQuality: 0.2)!
    
    Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "photo",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in params {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                } //Optional for extra parameters
        },
    to:"https://agile-dusk-73308.herokuapp.com/upload")
    { (result) in
        switch result {
            
        case .success(let upload, _, _):

            upload.uploadProgress(closure: { (progress) in
                print("Upload Progress: \(progress.fractionCompleted)")
            })

            upload.responseJSON { response in
                if(response.result.value != nil) {                    
                    let responseData = JSON(response.result.value!)
                    print(responseData)
                    if(responseData["success"] == "true") {
                        print("great success!")
                        sender.DesctextInInputField = ""
                        sender.NametextInInputField = ""
                        sender.LinktextInInputField = ""
                        sender.imageToUpload = nil
                        sender.removeSpinner()
                        popUpView.removeFromSuperview()
                let alert = UIAlertController(title: "Success", message: "Card Uploaded Successfully", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Fire", style: .default, handler: nil))
                        sender.present(alert, animated: true)
                        sender.cardCurrentlyDisplayed = false
                    }
                } else {
                    print("upload failed")
                    popUpView.removeFromSuperview()
                    sender.removeSpinner()
                    let alert = UIAlertController(title: "Error", message: "Connection Error, could not upload card", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Can't connect to server", style: .default, handler: nil))
                    sender.present(alert, animated: true)
                    sender.cardCurrentlyDisplayed = false
                }
                 
            }

        case .failure(let encodingError):
            print(encodingError)
            print("ERROR UPLOADING IMAGE")
            let alert = UIAlertController(title: "Error", message: "Connection Error, could not upload card", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Error", style: .default, handler: nil))
            sender.present(alert, animated: true)
            sender.cardCurrentlyDisplayed = false
            popUpView.removeFromSuperview()
        }
    }
}
