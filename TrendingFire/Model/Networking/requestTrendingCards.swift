//
//  mainLoader.swift
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
    
    func requestTrendingCards(userid:String) {
                let params: [String: String] = [
                    "userID" : userid
                ]
                let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
                
                if let url = URL(string:"https://agile-dusk-73308.herokuapp.com/fireCards") {
            
                    let session = URLSession.shared

                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    let task = session.uploadTask(with: request, from: jsonData,completionHandler: handleTrendingResponse(data:response:error:))
                    task.resume()
                }
        }

    func handleTrendingResponse(data:Data?,response: URLResponse?,error:Error?) {
        if error != nil {
            print("error in response; could not retreive cards")
            print(error!)
            return
        }
        if let safeData = data {
            print("got trending cards response")
            let serialTrendingQueue = DispatchQueue(label: "update.trending.queue")
            var updateTrendingObj: [Card] = []
            let dataJSON = JSON(safeData)
            if(dataJSON["success"] == false) {
                print("could not retreive trending cards")
                self.trendingImagesHolder.updated = true
                self.notifyProfileBoard()
                return;
            }
            if(dataJSON.count < 1) {
                self.trendingImagesHolder.updated = true
                self.notifyProfileBoard()
                    return;
            }
            let trendingCardCount = dataJSON.count
            var loadedCount = 0
            for index in 0..<dataJSON.count {
                let urlString = String(describing: dataJSON[index]["pic"])
                let imgUrl = NSURL(string: urlString)! as URL
                let descText = String(describing: dataJSON[index]["desc"])
                let rankTxt = String(describing: dataJSON[index]["rank"])
                let authorTxt = String(describing: dataJSON[index]["author"])
                let cardId = String(describing: dataJSON[index]["_id"])
                let linkTxt = String(describing: dataJSON[index]["link"])
                let titleTxt = String(describing: dataJSON[index]["title"])
                 
                let session = URLSession(configuration: .default)
                
                let downloadPicTask = session.dataTask(with: imgUrl) { (data, response, error) in
                    if let e = error {
                        print("--")
                        print("Error downloading trending image: \(e)")
                        print(imgUrl,titleTxt)
                        print("--")
                    } else {
                        if let res = response as? HTTPURLResponse {
                            if let imageData = data {
                                let imageForCard = UIImage(data: imageData as Data)
                                if imageForCard != nil {
                                    let rc = Card(url:urlString, desc: descText, rank: rankTxt, author: authorTxt, cardid: cardId,cardTitle: titleTxt,cardLink: linkTxt)
                                    rc.image = imageForCard!
                                    serialTrendingQueue.async {
                                        updateTrendingObj.append(rc)
                                        loadedCount = loadedCount + 1
                                        if(loadedCount == trendingCardCount) {
                                            print("loaded all trending imgs successfully")
                                            self.trendingImagesHolder.updated = true
                                            self.trendingImagesHolder.upDateCardArray(arr: updateTrendingObj)
                                            self.notifyProfileBoard()
                                            return;
                                        }
                                    }
                                } else {
                                    print("had image data but could not convert to uiImage")
                                }
                            } else {
                                print("could not get img data")
                            }
                        }
                   }
                }
                downloadPicTask.resume()
            }
        }
    }
}
