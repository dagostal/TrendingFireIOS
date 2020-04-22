//
//  postSwipe.swift
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
    
    func postSwipe(swipeVal:String,userIdVal:String) {
        
        let params: [String: String] = [
        "cardId": dataSource[myKolodaView.currentCardIndex-1].id ?? "no id found in card",
        "swipe" : swipeVal,
        "card" : String(myKolodaView.currentCardIndex),
        "author": dataSource[myKolodaView.currentCardIndex-1].authorTxt ?? "failed to get card info",
        "userID": userIdVal
               ]

                let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
                
                if let url = URL(string:"https://agile-dusk-73308.herokuapp.com/cards") {
            
                    let session = URLSession.shared

                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
            let swipeReq = session.uploadTask(with: request, from: jsonData,completionHandler: handleSwipe(data:response:error:))
                    swipeReq.resume()
                }
    }
     func handleSwipe(data:Data?,response: URLResponse?,error:Error?) {
            if error != nil {
                print("error in response")
                print(error!)
                return
            }
            if let safeData = data {
                //check if response was successful
                let responseData = JSON(safeData)
        }
    }
                    
}
