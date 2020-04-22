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
import GoogleMobileAds

extension ViewController {
    
    func requestMainCards(category:[String]) {
        var requestParamString = "?"
        for index in 0..<category.count {
            let subString = "cat"+String(index)+"="+category[index]+"&"
            requestParamString = requestParamString + subString
        }
        print(requestParamString)
            if let url = URL(string:"https://agile-dusk-73308.herokuapp.com/cards"+requestParamString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handleResponse(data:response:error:))
            task.resume()
        }
    }
    
    func handleResponse(data:Data?,response: URLResponse?,error:Error?) {
    if error != nil {
        print("error: could not retreive main cards")
        print(error!)
        DispatchQueue.main.async {
            self.present(trendingFireAlerts(alertName: "",sender:self), animated: true)
        }
        return;
    }
    if let safeData = data {
        let dataJSON = JSON(safeData)
        //need to add a check for server error...
        let serialMainQueue = DispatchQueue(label: "update.main.queue")
        var cardArray: [Card] = []
        var countOfLoadedCards: Int = 0
        
        for index in 0..<dataJSON.count {

            let imageURLString = String(describing: dataJSON[index]["pic"])
            let descText = String(describing: dataJSON[index]["desc"])
            let rankTxt = String(describing: dataJSON[index]["rank"])
            let authorTxt = String(describing: dataJSON[index]["author"])
            let cardId = String(describing: dataJSON[index]["_id"])
            let cardTitle = String(describing: dataJSON[index]["title"])
            let cardLink = String(describing: dataJSON[index]["link"])
            
            let cardObj = Card(url: imageURLString, desc: descText, rank: rankTxt, author: authorTxt, cardid: cardId,cardTitle:cardTitle,cardLink:cardLink)
            
            var imageForCard: UIImage?
            let imageUrl = NSURL(string: imageURLString)! as URL
            
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: imageUrl) { (data, response, error) in
            // The download has finished.
                if let e = error {
                    print("--")
                    print("Error downloading main card image: \(e)")
                    print(imageUrl,cardTitle)
                    print("--")
                } else {
                    if let imageData = data {
                        //  convert the Data into an image and do something with it.
                        imageForCard = UIImage(data: imageData as Data)
                        if imageForCard != nil {
                            //image data successfully added to cardObj
                            cardObj.image = imageForCard!
                        } else {
                            print("had image data but could not convert to uiImage,attached placeholder")
                            imageForCard = UIImage(named: "image1")
                            cardObj.image = imageForCard!
                            return;
                        }
                        serialMainQueue.async {
                            cardArray.append(cardObj)
                            countOfLoadedCards += 1
                            if(countOfLoadedCards == 5) {
                                DispatchQueue.main.async {
                                    self.assignCards(arr:cardArray)
                                }
                            }
                            if(countOfLoadedCards>5) {
                                self.dataSource.append(cardObj)
                                self.myKolodaView.updateCountOFCards()
                            }
                        }
                         // add the completed cardObj to the array
                       
                    } else {
                        print("cannot retreive img data from request")
                        return;
                    }
                }
            }
            downloadPicTask.resume()
            }
        }
    }
}


