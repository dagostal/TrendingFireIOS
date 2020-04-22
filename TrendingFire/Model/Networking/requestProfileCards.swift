//
//  rankLoader.swift
//  TrendingFire
//
//  Created by alex on 1/25/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//
import UIKit
import SwiftyJSON
import Alamofire
import CoreData

extension ViewController {
    func requestProfileCards(userid:String) {
        
                let params: [String: String] = [
                    "userID" : userid
                ]
                let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
                
                if let url = URL(string:"https://agile-dusk-73308.herokuapp.com/myCards") {
            
                    let session = URLSession.shared

                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    let task = session.uploadTask(with: request, from: jsonData,completionHandler: handleProfileImages(data:response:error:))
                    task.resume()
                }
    }
    

    func handleProfileImages(data:Data?,response: URLResponse?,error:Error?) {
        if error != nil {
            print("error in response")
            print(error!)
                return
            }
        if let safeData = data {
            let responseData = JSON(safeData)
            if(responseData["success"] == false) {
                print("could not retreive trending cards")
                self.createdImagesHolder.updated = true
                self.notifyProfileBoard()
                return;
            }
            let serialProfileQueue = DispatchQueue(label: "update.profile.queue")
            var arrPersonalImgs: [Card] = []
            let countOfUserCards = responseData.count
            if(responseData.count < 1) {
                self.createdImagesHolder.updated = true
                self.notifyProfileBoard()
                return;
            }
            for index in 0..<responseData.count {
                let dataJSON = JSON(safeData)
                let urlString = String(describing: dataJSON[index]["pic"])
                let descText = String(describing: dataJSON[index]["desc"])
                let rankTxt = String(describing: dataJSON[index]["rank"])
                let authorTxt = String(describing: dataJSON[index]["author"])
                let cardId = String(describing: dataJSON[index]["_id"])
                let linkTxt = String(describing: dataJSON[index]["link"])
                let titleTxt = String(describing: dataJSON[index]["title"])
                let imgUrl = URL(string: urlString)!
    
                let session = URLSession(configuration: .default)
                let downloadPicTask = session.dataTask(with: imgUrl) { (data, response, error) in
                    if let e = error {
                        print("--")
                        print("Error downloading profile image: \(e)")
                        print(imgUrl,titleTxt)
                        print("--")
                    } else {
                        if let imageData = data {
                            if let imageForCard = UIImage(data: data! as Data) {
                                let rc = Card(url:urlString, desc: descText, rank: rankTxt, author: authorTxt, cardid: cardId,cardTitle:titleTxt,cardLink:linkTxt)
                                rc.image = imageForCard
                                serialProfileQueue.async {
                                    arrPersonalImgs.append(rc)
                                    if(arrPersonalImgs.count == countOfUserCards) {
                                        self.createdImagesHolder.upDateCardArray(arr:arrPersonalImgs)
                                        self.createdImagesHolder.updated = true
                                        self.notifyProfileBoard()
                                        print("personal cards updated")
                                    }
                                }
                            } else {
                                print("error:cannt load image")
                                return;
                            }
                        } else {
                            print("error:could not download image data")
                            return;
                        }
                    }
                }
                downloadPicTask.resume()
            }
        }
    }
}
