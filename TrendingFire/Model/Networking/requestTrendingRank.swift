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
    func requestTrendingRank(userid:String) {        
                let params: [String: String] = [
                    "userID" : userid
                ]
                let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
                
                if let url = URL(string:"https://agile-dusk-73308.herokuapp.com/getProfileRank") {
            
                    let session = URLSession.shared

                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    let task = session.uploadTask(with: request, from: jsonData,completionHandler: handleRank(data:response:error:))
                    task.resume()
                }
    }
    

    func handleRank(data:Data?,response: URLResponse?,error:Error?) {
        if error != nil {
            print("error in response")
            print(error!)
            return
        }
        if let safeData = data {
            let responseData = JSON(safeData)
            if(responseData["success"] == false) {
                print("could not retreive rank")
                return;
            }
            let rankReturned = String(describing:responseData["rank"])
            let username = String(describing:responseData["username"])
            DispatchQueue.main.async {
                self.assignRankAndName(arr:["rank":rankReturned,"username":username])
            }            
        } else {
            print("error getting repsonse")
            return;
        }
    }
}
